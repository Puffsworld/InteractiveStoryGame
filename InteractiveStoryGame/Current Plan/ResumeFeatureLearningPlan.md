# Resume Feature Learning Plan

## Goal

Build a small resume feature so a player can leave a story and later continue from the same scene.

This feature also clarifies one design issue: the project currently has a `pathHistory` property that you intend to be human-readable. That is a valid design. If `pathHistory` is for display/debugging, it should keep `loggingID` values. Resume should use a separate machine-readable node path.

## Mental Model

There are two different ID types in this project:

| Concept | Example | Meaning |
|---|---|---|
| `StoryModel.id` | `"story1"` | The whole story shown in the home gallery |
| `StoryNodeModel.id` | `"132457"` | One scene/node inside a story |
| `StoryNodeModel.loggingID` | `"Start"` | Human-readable label for display/debugging |

Important decision:

| Property | Stores | Used For |
|---|---|---|
| `pathHistory` | `loggingID` values | Human-readable progress trail |
| `nodePathHistory` | `StoryNodeModel.id` values | Save/restore lookup |

Resume should save the whole story ID plus the path of node IDs:

```swift
storyID = "story1"
nodePathHistory = ["132457", "repair_engine", "ending_escape"]
```

To resume, load the save, read `nodePathHistory.last`, then look up that node in `stories`.

Your intuition is mostly correct: the node ID is the unique identifier used to find a specific scene again. The save itself should be keyed by `storyID`, because each story has its own save. Inside that saved value, the current node ID tells the app where to resume.

## Step 1: Update The Saved Game Model

### File To Change

`InteractiveStoryGame/Common/GameSave/SaveGameState.swift`

### Why

This struct is the shape of the data that will be stored in `UserDefaults`.

The current model stores some information that is not needed yet, like `playTime`. For a beginner-friendly first version, save the minimum data needed for two real use cases:

- resume the game later
- preserve the readable path for future developer analysis

Because you want `pathHistory` to stay human-readable, the save model should store both `pathHistory` and a clearly named machine-readable property such as `nodePathHistory`.

### Swift Concept

You will learn:

- `struct`: a lightweight data container
- `Codable`: allows Swift to convert the model to/from JSON
- computed property: a value calculated from other stored values

### Target Shape

```swift
struct SavedGameState: Codable {
    let version: Int
    let storyID: String
    let pathHistory: [String]
    let nodePathHistory: [String]
    let savedAt: Date

    var currentNodeID: String? {
        nodePathHistory.last
    }
}
```

### Done When

- `SavedGameState` has `version`, `storyID`, `pathHistory`, `nodePathHistory`, and `savedAt`.
- `pathHistory` stores readable `loggingID` values for future analysis.
- `nodePathHistory` stores real node IDs for resume.
- `currentNodeID` is computed from `nodePathHistory.last`.
- The model imports `Foundation`, not `SwiftUI`, because it is not UI code.

## Step 2: Create A Save Manager

### File To Add

`InteractiveStoryGame/Common/GameSave/SaveGameManager.swift`

### Why

The game needs one object responsible for saving, loading, checking, and deleting progress.

Putting this behind a protocol makes the code easier to test later. The real app can use `UserDefaults`; tests can use a fake in-memory save manager.

### Swift Concept

You will learn:

- `protocol`: a contract that says what methods an object must provide
- `final class`: a reference type that cannot be subclassed
- `UserDefaults`: simple iOS key-value storage
- `JSONEncoder` / `JSONDecoder`: convert Swift models to/from stored data
- optional return values like `SavedGameState?`

### Target API

```swift
protocol SaveGameManaging {
    func save(_ state: SavedGameState)
    func load(storyID: String) -> SavedGameState?
    func hasSavedGame(storyID: String) -> Bool
    func delete(storyID: String)
}
```

Then implement:

```swift
final class UserDefaultsSaveGameManager: SaveGameManaging {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private func key(for storyID: String) -> String {
        "story_save_\(storyID)"
    }
}
```

Add the four required methods using `JSONEncoder`, `JSONDecoder`, `defaults.set`, `defaults.data`, and `defaults.removeObject`.

### Done When

- The app has a `SaveGameManaging` protocol.
- The app has a `UserDefaultsSaveGameManager` class.
- Saves are keyed by `"story_save_\(storyID)"`.

## Step 3: Separate Human History From Resume History

### File To Change

`InteractiveStoryGame/GamePlay/Model/GamePlayViewModel.swift`

### Why

Resume needs real node IDs. Human-readable history can use `loggingID`.

The current code uses one property, `pathHistory`, for both ideas. That is confusing because `stories` is keyed by node ID, not logging ID.

The clean fix is to keep `pathHistory` as readable history and add a new property for restore.

### Swift Concept

You will learn the importance of giving each property one clear job.

One list can be for humans. Another list can be for machines.

### Add A New Property

Keep:

```swift
@Published var pathHistory: [String] = []
```

Use it for `loggingID` values.

Add:

```swift
@Published var nodePathHistory: [String] = []
```

Use it for `StoryNodeModel.id` values.

### Update `makeChoice`

Instead of replacing the existing append, keep readable history and also append node history:

```swift
self.pathHistory.append(nextNode.loggingID)
self.nodePathHistory.append(nextNode.id)
```

### Update Fresh Start Logic

```swift
self.pathHistory = [currentStoryModel.loggingID]
self.nodePathHistory = [initialStoryID]
```

### Done When

- `pathHistory` contains human-readable `loggingID` values.
- `nodePathHistory` contains machine-readable `StoryNodeModel.id` values.
- Save/restore uses `nodePathHistory`, not `pathHistory`.

## Step 4: Inject Story ID And Save Manager Into `GamePlayViewModel`

### File To Change

`InteractiveStoryGame/GamePlay/Model/GamePlayViewModel.swift`

### Why

The view model currently knows the initial node ID, but it does not know the whole story ID. Saves must be stored per story, so the view model needs `storyID`.

The view model also needs a save manager so it can save and restore progress.

### Swift Concept

You will learn dependency injection.

Dependency injection means passing an object into another object instead of creating it secretly inside. This makes code easier to test and easier to change later.

### Add Properties

```swift
let storyID: String
let saveManager: SaveGameManaging
```

### Update Initializer

Change the production initializer so it accepts:

```swift
init(
    storyID: String,
    initialStoryID: String,
    fileName: String,
    bundle: Bundle = .main,
    saveManager: SaveGameManaging = UserDefaultsSaveGameManager()
)
```

Inside the initializer, assign:

```swift
self.storyID = storyID
self.saveManager = saveManager
self.initialStoryID = initialStoryID
```

### Done When

- `GamePlayViewModel` has both `storyID` and `saveManager`.
- Existing call sites are updated or temporarily given defaults.

## Step 5: Add `initializeNewGame()`

### File To Change

`InteractiveStoryGame/GamePlay/Model/GamePlayViewModel.swift`

### Why

Right now reset logic lives directly inside `resetGame()`. Resume also needs to start a fresh game when there is no valid save.

Create one helper so both places use the same logic.

### Swift Concept

You will learn how private helper methods reduce duplication.

### Add Method

```swift
private func initializeNewGame() {
    self.currentStoryModel = stories[initialStoryID]
    self.storyLog = []
    self.currentChoice = currentStoryModel?.choices ?? []
    self.pathHistory = currentStoryModel.map { [$0.loggingID] } ?? []
    self.nodePathHistory = [initialStoryID]
}
```

### Done When

- `initializeNewGame()` sets current node, choices, story log, and path history.
- It also sets `nodePathHistory` to the starting node ID.
- `resetGame()` can call this helper later.

## Step 6: Add Restore Logic

### File To Change

`InteractiveStoryGame/GamePlay/Model/GamePlayViewModel.swift`

### Why

When the player opens a story, the app should restore saved progress if a valid save exists.

If there is no save, or the save points to a node that no longer exists, the app should start fresh.

### Swift Concept

You will learn:

- `if let`: safely unwrap optional values
- fallback logic: try restore first, then start fresh

### Add Method

```swift
func restoreOrStart() {
    if let savedState = saveManager.load(storyID: storyID),
       let currentNodeID = savedState.currentNodeID,
       let restoredNode = stories[currentNodeID] {
        self.nodePathHistory = savedState.nodePathHistory
        self.currentStoryModel = restoredNode
        self.currentChoice = restoredNode.choices
        self.pathHistory = rebuildReadablePath(from: savedState.nodePathHistory)
    } else {
        initializeNewGame()
    }
}
```

For the first version, `rebuildReadablePath` can be simple:

```swift
private func rebuildReadablePath(from nodeIDs: [String]) -> [String] {
    nodeIDs.compactMap { stories[$0]?.loggingID }
}
```

### Done When

- Valid saves restore the current node.
- Valid saves restore `nodePathHistory`.
- Readable `pathHistory` is rebuilt from node IDs.
- Missing or invalid saves start a new game.

## Step 7: Save After Each Choice

### File To Change

`InteractiveStoryGame/GamePlay/Model/GamePlayViewModel.swift`

### Why

The safest save moment is immediately after a successful choice. If the destination node exists and the game moved forward, save the new path.

If the destination node is an ending, delete the save instead. A finished story should not show up as resumable.

### Swift Concept

You will learn how to keep persistence close to the state change that requires it.

### Add Helper

```swift
private func persistAfterNavigation() {
    if currentStoryModel.type == .ending {
        saveManager.delete(storyID: storyID)
    } else {
        let state = SavedGameState(
            version: 1,
            storyID: storyID,
            pathHistory: pathHistory,
            nodePathHistory: nodePathHistory,
            savedAt: Date()
        )
        saveManager.save(state)
    }
}
```

Then call it at the end of `makeChoice`, after appending `nextNode.id` to `nodePathHistory`.

### Done When

- Choosing a standard node saves progress.
- Choosing an ending node deletes progress.

## Step 8: Update Reset Behavior

### File To Change

`InteractiveStoryGame/GamePlay/Model/GamePlayViewModel.swift`

### Why

When the user taps Restart Game, old saved progress should be cleared. Otherwise the story may accidentally resume from stale progress.

### Change

Update `resetGame()`:

```swift
public func resetGame() {
    saveManager.delete(storyID: storyID)
    initializeNewGame()
}
```

### Done When

- Restart deletes saved progress.
- Restart resets the in-memory game state.

## Step 9: Remove Reset On Disappear

### File To Change

`InteractiveStoryGame/GamePlay/GamePlayView.swift`

### Why

This is currently the most dangerous line for resume:

```swift
.onDisappear {
  viewModel.resetGame()
}
```

Leaving the story should not reset it. Leaving is exactly when the user expects resume to work later.

### Swift Concept

You will learn SwiftUI lifecycle:

- `onAppear`: runs when the view becomes visible
- `onDisappear`: runs when the view leaves
- `onReceive`: listens for system events

### Change

Remove the `onDisappear` reset.

Add:

```swift
.onAppear {
    viewModel.restoreOrStart()
}
```

Later, add background saving:

```swift
.onReceive(NotificationCenter.default.publisher(
    for: UIApplication.didEnterBackgroundNotification
)) { _ in
    viewModel.saveOnBackground()
}
```

You will also need this method in `GamePlayViewModel`:

```swift
func saveOnBackground() {
    persistAfterNavigation()
}
```

### Done When

- Opening gameplay attempts to restore.
- Leaving gameplay does not reset progress.
- Backgrounding the app saves current progress.

## Step 10: Pass The Real Story ID From Home

### File To Change

`InteractiveStoryGame/HomeView/ViewModel/GalleryCellViewModel.swift`

### Why

`GamePlayViewModel` now needs both:

- `storyModel.id`: whole story ID, used for save key
- `storyModel.initialStoryID`: starting node ID, used to start the story

### Change

Update `createGamePlayViewModel()` so it passes:

```swift
return GamePlayViewModel(
    storyID: storyModel.id,
    initialStoryID: storyModel.initialStoryID,
    fileName: storyModel.fileName
)
```

### Done When

- Each story saves independently.
- Playing Story A does not overwrite Story B's save.

## Step 11: Show A Continue Indicator On Home

### Files To Change

`InteractiveStoryGame/HomeView/ViewModel/GalleryCellViewModel.swift`

`InteractiveStoryGame/HomeView/ViewModel/HomeViewModel.swift`

`InteractiveStoryGame/HomeView/Components/GameCard.swift`

`InteractiveStoryGame/HomeView/Components/FeaturedGameCard.swift`

### Why

The user should be able to see which stories have saved progress.

Keep this small for now. A simple `"Continue"` pill is enough.

### Swift Concept

You will learn how data flows:

`SaveGameManager` -> `HomeViewModel` -> `GalleryCellViewModel` -> SwiftUI card

### Gallery Cell Change

Add:

```swift
let hasResumableProgress: Bool
```

Update initializer:

```swift
init(storyModel: StoryModel, hasResumableProgress: Bool = false) {
    self.storyModel = storyModel
    self.hasResumableProgress = hasResumableProgress
}
```

### Home View Model Change

Inject a save manager:

```swift
private let saveManager: SaveGameManaging
```

Initializer:

```swift
init(
    storyManifestFileName: String = "StoryManifestExample",
    bundle: Bundle = .main,
    saveManager: SaveGameManaging = UserDefaultsSaveGameManager()
) {
    self.saveManager = saveManager
    self.loadStories(from: storyManifestFileName, bundle: bundle)
}
```

When creating a gallery cell:

```swift
GalleryCellViewModel(
    storyModel: story,
    hasResumableProgress: saveManager.hasSavedGame(storyID: story.id)
)
```

### Card UI Change

In each card, add a simple conditional:

```swift
if viewModel.hasResumableProgress {
    Text("Continue")
}
```

Style it lightly later.

### Done When

- A story with a save shows `"Continue"`.
- A story without a save does not.

## Step 12: Manual Test Checklist

Use the app before writing unit tests.

- [ ] Open app and start a story.
- [ ] Make one choice.
- [ ] Return home.
- [ ] Open the same story again.
- [ ] Confirm it resumes at the chosen node.
- [ ] Restart the story.
- [ ] Leave and reopen.
- [ ] Confirm it starts fresh.
- [ ] Reach an ending.
- [ ] Return home.
- [ ] Confirm the story no longer shows `"Continue"`.
- [ ] Start Story A and Story B separately.
- [ ] Confirm each story resumes independently.

## Step 13: Unit Tests

### Files To Add Or Change

`InteractiveStoryGameTests/Common/GameSave/SaveGameManagerTests.swift`

`InteractiveStoryGameTests/GamePlay/Model/GamePlayViewModelTest.swift`

`InteractiveStoryGameTests/HomeViewModelTests.swift`

### Why

Tests give you confidence that save/restore behavior does not break when you later change the UI.

### Save Manager Tests

Test:

- save then load returns the same state
- missing save returns `nil`
- `hasSavedGame` is false before save and true after save
- delete removes the save

Use a test `UserDefaults` suite instead of `.standard`.

### View Model Tests

Test:

- choosing a standard node saves progress using `nodePathHistory`
- choosing an ending deletes progress
- reset deletes progress
- restore with valid save sets the current node
- restore with invalid save starts fresh
- `pathHistory` stores `loggingID` values for readability
- `nodePathHistory` stores node IDs for resume

### Done When

- Tests pass.
- Manual testing also passes.

## Suggested Commit Plan

Keep commits small so the history is easy to understand.

- Commit 1: Update saved state model and add save manager
- Commit 2: Add `nodePathHistory` and keep `pathHistory` readable
- Commit 3: Wire save and restore into `GamePlayViewModel`
- Commit 4: Update `GamePlayView` lifecycle
- Commit 5: Add Home `"Continue"` indicator
- Commit 6: Add tests

## Final Definition Of Done

- [ ] User can leave a story and resume later.
- [ ] Progress is saved after each valid choice.
- [ ] Progress is deleted on ending.
- [ ] Progress is deleted on restart.
- [ ] `pathHistory` stores human-readable `loggingID` values.
- [ ] `nodePathHistory` stores only node IDs.
- [ ] Home can show whether a story is resumable.
- [ ] Manual test checklist passes.
- [ ] Unit tests cover save/restore basics.
