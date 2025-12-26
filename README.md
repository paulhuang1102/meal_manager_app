# Meal Manager

A Flutter application for managing meal orders with person management and statistics tracking.

## Requirements

- Flutter 3.38.5
- Dart 3.10.4

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:
```bash
flutter run
```

## Login Credentials

- **Username:** `admin`
- **Password:** `admin`

## Features

- User authentication
- Person management (Create, Read, Update, Delete)
- Advanced person filtering (by name, age range, birth month)
- Meal ordering system (breakfast, lunch, dinner)
- Real-time meal statistics

## Architecture

Built with Clean Architecture principles using BLoC pattern for state management.

**Key packages:**
- flutter_bloc - State management
- get_it - Dependency injection
- shared_preferences - Local storage
- dartz - Functional programming
