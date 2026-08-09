# GiftKeeper 🎁

A Flutter app for keeping track of birthdays and planning thoughtful gifts for the people in your life.

## Features

* 🎂 Add and manage people's birthdays
* 🔔 Receive reminders before upcoming birthdays
* 🎁 Store gift ideas and information about each person
* 💭 Answer questions about a person to help generate gift suggestions
* 💾 Store personal data locally using Hive
* 📱 Cross-platform Flutter application

## Tech Stack

* **Flutter & Dart** — application development
* **Hive** — local data storage
* **flutter_local_notifications** — birthday reminders
* **Timezone** — accurate notification scheduling
* **Groq API** — AI-powered gift suggestions

## Project Structure

```text
lib/
├── models/       # Data models
├── screens/      # Application screens
├── services/     # Notifications, storage and AI services
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

### API Configuration

GiftKeeper uses the Groq API to generate gift suggestions.

Create the following file:

```text
lib/constants/api_keys.dart
```

and add your API key:

```dart
const String groqApiKey = "YOUR_API_KEY";
```

> **Note:** API keys are excluded from version control and should never be committed to the repository.

### Run the Application

```bash
flutter run
```

## What I Learned

This project was built to develop practical experience with Flutter and mobile application development. It involved working with local data persistence, notification scheduling, asynchronous operations, UI design, API integration, and organising a multi-screen application.

## Future Improvements

* More personalised gift recommendations
* Improved notification customisation
* Additional filtering and search functionality
* Cloud backup and synchronisation
