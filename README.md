# GiftKeeper 🎁

A Flutter app for keeping track of birthdays and planning thoughtful gifts for the people in your life.

## Features

* 🎂 Add and manage people's birthdays
* 🔔 Receive reminders before upcoming birthdays
* 🎁 Store gift ideas and information about each person
* 💭 Answer questions about a person to help generate gift suggestions
* 💾 Store data locally for convenient offline use
* 📱 Cross-platform Flutter application

## Tech Stack

* **Flutter & Dart** — application development
* **Hive** — local data storage
* **flutter_local_notifications** — birthday reminders
* **Timezone** — scheduling notifications accurately

## Project Structure

```text
lib/
├── models/       # Data models
├── screens/      # Application screens
├── services/     # Notifications and other services
└── ...
```

## Getting Started

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or Xcode, depending on the target platform

### Installation

Clone the repository:

```bash
git clone <repository-url>
cd giftkeeper
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## What I Learned

This project was built to develop practical experience with Flutter and mobile application development. It involved working with local data persistence, notification scheduling, state management, UI design, and organising a multi-screen application.

## Future Improvements

* More personalised gift recommendations
* Improved notification customisation
* Additional filtering and search functionality
* Cloud backup and synchronisation

