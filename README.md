# GiftKeeper 🎁

A Flutter application for keeping track of birthdays and planning thoughtful gifts for the people in your life.

## Features

- 🎂 Add and manage people's birthdays
- 🔔 Receive reminders before upcoming birthdays
- 🎁 Store gift ideas and information about each person
- 💭 Generate personalised gift suggestions using AI
- 💾 Store personal data locally using Hive
- 📱 Cross-platform Flutter application

## Screenshots

### GiftKeeper

![GiftKeeper home screen](home.jpg)

### AI Gift Suggestions

![AI gift suggestions](ai-suggestions.jpg)

### Backend API

![FastAPI backend](backend.jpg)

## Tech Stack

- **Flutter & Dart** — application development
- **Hive** — local data storage
- **flutter_local_notifications** — birthday reminders
- **Timezone** — notification scheduling
- **FastAPI & Python** — backend development
- **Groq API** — AI-powered gift suggestions

## Architecture

```text
Flutter App
     │
     │ Person information + generated prompt
     ▼
FastAPI Backend
     │
     │ API key stored as environment variable
     ▼
Groq API
     │
     ▼
AI-generated gift suggestions
     │
     ▼
Flutter App
```

The Flutter application does not directly communicate with the Groq API or contain the Groq API key. Instead, requests are sent to a local FastAPI backend, which handles communication with Groq.

## Project Structure

```text
lib/
├── models/       # Data models
├── screens/      # Application screens
├── services/     # Notifications, storage and AI services
└── ...

backend/
├── main.py              # FastAPI application
├── requirements.txt     # Python dependencies
└── .gitignore           # Excludes secrets and environment files
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Python 3
- Android Studio or Xcode, depending on the target platform

### Installation

Clone the repository:

```bash
git clone <repository-url>
cd giftkeeper
```

Install Flutter dependencies:

```bash
flutter pub get
```

### Backend Setup

Navigate to the backend:

```bash
cd backend
```

Create a virtual environment:

```bash
python3 -m venv .venv
```

Activate it:

**macOS / Linux:**

```bash
source .venv/bin/activate
```

Install the required packages:

```bash
pip install -r requirements.txt
```

### API Configuration

Create a `.env` file inside the `backend` directory:

```text
GROQ_API_KEY=YOUR_API_KEY
```

The `.env` file is excluded from version control using `.gitignore` and should never be committed or shared publicly.

### Run the Backend

From the `backend` directory:

```bash
uvicorn main:app --reload
```

The backend will run locally and provide the endpoint used by the Flutter application.

### Run the Application

From the project root:

```bash
flutter run
```

The backend must be running locally for AI-generated gift suggestions to work.

## Security Assessment

Because GiftKeeper handles personal information such as relationships, interests, birthdays, gift history and personal notes, a technical security assessment was conducted to evaluate potential privacy and security risks.

The assessment considered:

- Device theft and unauthorised access
- Malware accessing local application storage
- Personal information being transmitted to third-party AI services
- Exposure of API credentials
- Notification privacy
- Data minimisation and user control

One key finding was that directly communicating with the Groq API from the Flutter application would require the API credential to be included in the client. This could allow the credential to potentially be extracted from the application.

### Security Improvement

The original architecture was:

```text
Flutter App → Groq API
```

The API integration was subsequently changed to:

```text
Flutter App → FastAPI Backend → Groq API
```

The Groq API key is now stored as an environment variable on the backend rather than being included in the Flutter application.

The assessment also identified potential future improvements such as encrypting sensitive local data, improving notification privacy, minimising information sent to external services, and giving users greater control over stored information.

## What I Learned

This project provided practical experience with:

- Flutter and Dart
- Local data persistence using Hive
- Notification scheduling
- Asynchronous programming
- REST API communication
- Backend development with FastAPI
- Environment variables and credential management
- Evaluating privacy and security risks in an application

The security assessment was particularly useful in demonstrating that building a functional application is only one part of software development. Data also needs to be considered throughout its collection, storage, transmission and processing.

## Future Improvements

- Encrypt sensitive local data
- Improve notification privacy
- Add more personalised gift recommendations
- Add filtering and search functionality
- Add optional cloud backup and synchronisation
- Further improve privacy controls
