# Task Management App for Gig Workers

A modern, feature-rich task management application built with Flutter and Riverpod. Designed specifically for gig workers to efficiently track and manage their tasks.

## Features

### User Authentication
- ✅ Email/password registration and login
- ✅ Local authentication with state management
- ✅ Secure user sessions with automatic auth state management
- ✅ Clean error handling with user-friendly messages

### Task Management
- ✅ Create, edit, delete, and view tasks
- ✅ Task properties:
  - Title
  - Description
  - Due date
  - Priority (Low, Medium, High)
  - Status (Pending, Completed)
- ✅ Local task storage with reactive updates
- ✅ Task completion tracking
- ✅ Swipe-to-delete functionality

### Task Filtering & Organization
- ✅ Filter tasks by priority level
- ✅ Filter tasks by completion status
- ✅ Automatic task grouping (Today, Tomorrow, This Week)
- ✅ Tasks sorted by due date (earliest first)

### User Interface
- ✅ Modern, clean Material Design
- ✅ Beautiful purple-themed UI
- ✅ Responsive layouts for iOS and Android
- ✅ Intuitive navigation and interactions
- ✅ Smooth animations and transitions

## Tech Stack

- **Framework**: Flutter 3.9.2
- **State Management**: Riverpod 2.6.1
- **Storage**: Local in-memory storage
- **Architecture**: Clean Architecture
- **Date Formatting**: intl 0.19.0

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # App color constants
│   │   └── app_strings.dart      # All UI strings
│   └── providers/
│       ├── auth_providers.dart   # Authentication providers
│       └── task_providers.dart   # Task management providers
├── data/
│   ├── data_sources/
│   │   └── task_remote_data_source.dart  # Firestore data source
│   ├── repositories/
│   │   └── task_repository_impl.dart     # Repository implementation
│   └── services/
│       └── auth_service.dart     # Authentication service
├── domain/
│   └── repositories/
│       └── task_repository.dart  # Repository interface
├── models/
│   ├── app_user.dart             # User model
│   └── task.dart                 # Task model
├── presentation/
│   ├── screens/
│   │   ├── login_screen.dart     # Login screen
│   │   ├── signup_screen.dart    # Sign up screen
│   │   ├── splash_screen.dart    # Onboarding screen
│   │   └── tasks_screen.dart      # Main tasks screen
│   └── widgets/
│       ├── add_task_dialog.dart   # Add/edit task dialog
│       ├── custom_text_field.dart # Reusable text field
│       ├── filter_bottom_sheet.dart  # Filter UI
│       ├── onboarding_painter.dart  # Custom painter for logo
│       ├── social_button.dart    # Social login buttons
│       └── task_item.dart        # Task list item widget
└── main.dart                    # App entry point
├── firebase_options.dart         # Firebase configuration
└── SETUP.md                      # Detailed setup guide
```

## Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

1. **Presentation Layer** - UI screens and widgets
2. **Domain Layer** - Business logic and repository interfaces
3. **Data Layer** - Data sources, repositories, and external services

### State Management with Riverpod

- **authStateProvider**: Streams authentication state changes
- **tasksProvider**: Provides a stream of all user tasks
- **filteredTasksProvider**: Filters tasks based on user-selected criteria
- **taskRepositoryProvider**: Provides task repository instance

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Data Storage

The app currently uses **local in-memory storage** for development and testing. Data persists during the app session but is cleared when you close the app.

### Note on Data Storage

The app currently uses **local in-memory storage** which means:
- Data persists during the app session
- Data is cleared when you close the app
- Perfect for development and testing
- Easy to migrate to a persistent storage solution later

## Usage

### Authentication Flow
1. Launch the app to see the onboarding screen
2. Sign up with email and password, or
3. Log in with existing credentials

### Task Management
1. **Create Task**: Tap the floating action button (+)
2. **Fill Details**: Add title, description, select due date and priority
3. **Save**: Task is saved to Firestore and appears in the list
4. **Complete Task**: Tap the checkbox next to any task
5. **Edit Task**: Tap on a task to modify its details
6. **Delete Task**: Swipe left on a task to reveal delete button
7. **Filter Tasks**: Tap the filter icon to filter by priority/status

### Task Organization
Tasks are automatically grouped by due date:
- **Today**: Tasks due today
- **Tomorrow**: Tasks due tomorrow
- **This Week**: Tasks due within the week

## Dependencies

- `flutter_riverpod`: State management
- `intl`: Date formatting
- `uuid`: Unique ID generation

## Screenshots

The app includes:
- Onboarding screen with branded logo
- Login and Sign Up screens with social login options
- Task list with grouping by date
- Add/Edit task dialog
- Filter bottom sheet

## Future Enhancements

Potential improvements:
- Offline support with local caching
- Task reminders and notifications
- Task categories/tags
- Task statistics and analytics
- Dark mode support
- Export tasks functionality
- Integration with calendar apps

## Contributing

This project is built following Flutter best practices and clean architecture principles. Contributions are welcome!

## License

This project is licensed under the MIT License.

## Support

For setup issues, refer to `SETUP.md` for detailed instructions.
For Firebase configuration, check [Firebase Documentation](https://firebase.google.com/docs).
