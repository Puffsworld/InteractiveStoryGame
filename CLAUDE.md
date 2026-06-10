# Project Preferences & Architecture Guide

## Overview
Interactive Story Game - A cozy, cinematic (Studio Ghibli style) story reader with resume capabilities.

## Design Document Preferences

When requesting design documents or architecture reviews, I prefer:

### Format
- **Concise**: 1-2 pages of actual design content
- **Pseudo code only** for implementation sections (not full Swift)
- **Mermaid diagrams** for architecture and data flows
- **Checklist format** for integration tasks

### Avoid in Design Docs
- ❌ Full implementation code
- ❌ Verbose details or obvious explanations
- ❌ Multiple code variations
- ❌ Implementation details better left to coding phase

### Key Sections to Include
- Overview & Goal
- Functional Requirements
- Non-Functional Requirements
- High-Level Design (with Mermaid diagrams)
- Data Model
- Implementation Guide (pseudo code)
- Integration Checklist
- Trade-off Analysis (must include explicit decisions!)
- Edge Cases
- Future Enhancements

### Trade-off Analysis Requirements
- Always show "Option Chosen ✅" with rationale, not just pros/cons
- Include comparison tables (Chosen vs Alternative)
- End with clear decision statement or migration strategy
- **Every analysis must conclude with a solution**

### Organization Preference
- Use **headers for separation** (### Section, #### Subsection)
- ❌ Avoid numbering subsections (6.1, 6.2, 6.3)
- ❌ Avoid bullet-point enumeration of steps
- Headers provide sufficient visual structure

## Current Architecture

### Views & ViewModels
- **HomeView / HomeViewModel** - Story discovery and resume hints
- **GamePlayView / GamePlayViewModel** - Story reading and choice tracking
- **SaveGameManager** - (New) Handles persistence for game state

### Data Models
- **StoryNodeModel** - Single story node/scene
- **SavedGameState** - Game progress snapshot
  - storyID, currentNodeID, pathHistory, storyLog, savedAt

### Storage
- **UserDefaults** for saves (prototype phase)
- Plan: Migrate to server backend for cross-device sync

### Features
- [x] Story reading with choices
- [x] Path history tracking
- [x] Story logging
- [ ] Resume from last position
- [ ] Multiple story support (in progress)

## Team Preferences
- Animations: Dissolve & Float (cross dissolve + fade in text) for "cozy" feel
- Code style: Follow existing patterns in codebase
- Testing: Include manual test cases in design docs when relevant

---

**Last Updated**: 2026-04-15
**Contact**: Check project repository for contribution guidelines
