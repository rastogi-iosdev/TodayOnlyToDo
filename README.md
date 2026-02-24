# TodayOnlyToDo

A SwiftUI-based **daily task manager** with widget and Siri Intent support, focused on managing tasks for *today only* with a clean and minimal UX.

---
## 📱 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/a64bc965-28a2-4018-ad7c-c19712045c56" width="250"/>
  <img src="https://github.com/user-attachments/assets/14d4d4ce-d2d3-4737-b767-7b380509ca66" width="250"/>
  <img src="https://github.com/user-attachments/assets/e0b17942-8ec0-4c8d-b1cb-4d8be57d0c2b" width="250"/>
</p>

## 1. Overall Architecture

- **Pattern**: MVVM  
- **Layers**:
  - `Models` → Data structure (`TodoTask`)
  - `ViewModel` → Business logic (`TaskViewModel`)
  - `Views` → SwiftUI UI components
  - `Services` → Persistence & Notifications
  - `Intents` → Siri & Shortcut interactions
  - `Widget` → Home screen widget

---

## 📂 2. File-by-File Breakdown

### App Entry

#### `App/TodayOnlyToDoApp.swift`
- Entry point of the application
- Initializes root view (`ContentView`)
- Injects dependencies (ViewModel)

---

### Models

#### `Models/TodoTask.swift`
- Core data model for a task
- Contains:
  - `id`
  - `title`
  - `isCompleted`
  - `date`
- Conforms to `Codable` for persistence

---

### ViewModel

#### `ViewModel/TaskViewModel.swift`
- Central business logic layer
- Responsibilities:
  - Manage task list (`@Published`)
  - Add / delete / toggle tasks
  - Filter tasks for **today**
  - Sync with persistence layer
  - Notify widget updates

---

### Views

#### `Views/ContentView.swift`
- Root container view
- Hosts main navigation / TodayView

#### `Views/TodayView.swift`
- Core screen showing today's tasks
- Displays task list
- Connects UI with ViewModel

#### `Views/HeaderView.swift`
- Top section UI (title, date, etc.)
- Improves visual hierarchy

#### `Views/TaskRow.swift`
- Single task cell
- Handles:
  - Toggle complete
  - UI state rendering

#### `Views/AddTodoSheet.swift`
- Modal sheet to add new tasks
- Input handling + validation

#### `Views/SettingsView.swift`
- App settings UI
- Includes notification rescheduling

---

### Services

#### `Services/PersistenceManager.swift`
- Handles local data storage
- Uses file storage
- Encodes/decodes `TodoTask`

#### `Services/NotificationManager.swift`
- Manages local notifications
- Features:
  - Schedule reminders
  - Permission handling

---

### Intents (Siri + Widget Actions)

#### `Intents/AddTaskIntent.swift`
- Allows adding tasks via Siri / Shortcuts

#### `Intents/CompleteTaskIntent.swift`
- Mark task as completed externally

#### `Intents/OpenTodayIntent.swift`
- Deep link to open today’s screen

#### `Intents/TaskStorage.swift`
- Shared storage layer between:
  - App
  - Widget
  - Intents
- Critical for data consistency

---

### Extensions

#### `Extensions.swift`
- Utility extensions
- Includes conversion of Date to String

---

### Widget

#### `TodayWidget/TodayWidget.swift`
- Widget UI implementation
- Displays today's tasks

#### `TodayWidget/TodayWidgetBundle.swift`
- Entry point for widget bundle

#### `WidgetInfo.plist`
- Widget configuration

---

### Tests

#### `TodayOnlyToDoTests/TaskViewModelTests.swift`
- Unit tests for:
  - Task creation
  - Completion logic
  - Filtering

#### `TodayOnlyToDoTests/MockClasses.swift`
- Mock dependencies for isolation testing

---

### UI Tests

#### `TodayOnlyToDoUITests.swift`
#### `TodayOnlyToDoUITestsLaunchTests.swift`
- Basic UI and launch testing

---

## ⚖️ 3. Key Decisions & Tradeoffs

### Used Lightweight Persistence
- Chose simple storage instead of CoreData  
- ✔Faster implementation  
- ❌ Limited scalability

### Centralized ViewModel
- Single source of truth  
- ✔ Easy state management  
- ❌ Can grow large over time

### Widget + Intents Integration
- Improves usability significantly  
- ❌ Adds complexity in shared storage & sync

### Today-only Filtering
- Keeps UX minimal and focused  
- ❌ No task history

---

## 4. Improvements (If Given More Time)

### Architecture
- Split ViewModel into smaller modules
- Introduce protocol-based DI

### Data
- Migrate to CoreData / Realm
- Add:
  - Task history
  - Categories
  - Sync (iCloud)

### 📱 UI/UX
- Animations (task completion)
- Better onboarding
- Accessibility support

### Features
- Recurring tasks
- Smart reminders
- Productivity analytics

### Testing
- Increase coverage
- Add widget + intent testing

---

## Final Summary

This project demonstrates:

- Clean **MVVM architecture**
- Strong **SwiftUI fundamentals**
- Real-world features:
  - Widgets
  - Siri Intents
  - Notifications
- Good separation of concerns with scalable structure
