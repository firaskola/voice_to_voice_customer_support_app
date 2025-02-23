# ConversAI - AI Voice Support Assistant Chat App
## INTRODUCTION

ConversAI is a AI based Customer Support Assistant application build using flutter and firebase that allows users to interact with an AI assistant using voice commands. The app leverages Firebase for authentication and data storage, OpenAI's GPT for conversational AI, and Flutter's speech-to-text and text-to-speech libraries for seamless voice interactions
## Features

#### Voice-to-Text Input:
Speak to the app, and it will transcribe your speech into text.
#### AI-Powered Responses:
Get intelligent responses from OpenAI's GPT model.
#### Text-to-Speech Output: 
The app reads out the AI's responses aloud.
#### Conversational Awareness:
Maintains context across multiple interactions.
#### Firebase Integration:
User authentication and chat history storage.
#### Mute/Unmute Mic:
Automatically unmutes the mic after the AI responds.

## Installation & Setup

### Follow these steps to set up and run the project locally:

#### Clone the Repository:

`git clone https://github.com/firaskola/voice_to_voice_customer_support_app.git`

`cd voice_to_voice_customer_support_app`

#### Install Dependencies:
`flutter pub get`
#### Set Up Firebase:
#### Create a Firebase project at Firebase Console.
Add an Android/iOS app to your Firebase project and download the google-services.json (for Android) or GoogleService-Info.plist (for iOS).

#### Place these files in the appropriate directories:
Android: android/app/google-services.json

iOS: ios/Runner/GoogleService-Info.plist

#### Add OpenAI API Key:
Replace the apiKey variable in lib/screens/tap_to_talk_screen.dart with your OpenAI API key:

`const apiKey = "your-openai-api-key-here";`

#### Run the App:
`flutter run`

## Tech Stack

### Frontend:
Flutter
### Backend:
Firebase (Authentication, Firestore)
### AI:
OpenAI GPT-3.5 Turbo
### Speech-to-Text:
speech_to_text Flutter package
### Text-to-Speech:
flutter_tts Flutter package


## Usage

### Sign In/Up:
Use Firebase Authentication to log in or create an account.
### Start Chatting:
Tap the mic button to start speaking. The app will transcribe your speech and send it to the AI.
### Listen to Responses:
The AI's response will be read aloud, and the mic will automatically unmute for the next input.
### View Chat History:
All conversations are stored in Firestore and displayed in the app.


# SCREENSHOTS

## AUTHENTICATION & WELCOME SCREENS
![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 39 21](https://github.com/user-attachments/assets/cc835d7e-23bd-4701-a1c8-cedec74ff485) ![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 53 31](https://github.com/user-attachments/assets/1892b169-e60f-4651-bd97-fa2d8191c30e)
![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 39 24](https://github.com/user-attachments/assets/7ed8be85-c423-43fd-815f-77cd1dc91213) ![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 39 31](https://github.com/user-attachments/assets/6d1f4954-f408-4269-ab08-7049e5a1fdbe)

## HOME SCREEN, CHAT SCREEN, SIDE DRAWER & PREVIOUS HISTORY
![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 38 38](https://github.com/user-attachments/assets/0950f60f-7797-4ee4-a33a-9a23fdb909e3)

![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 39 16](https://github.com/user-attachments/assets/e5e0e400-18f9-4f47-8ec9-17c4fd3524a1)

![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 38 40](https://github.com/user-attachments/assets/ff9c9aba-b92a-44f1-98ea-2290b389a6d2)

![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 38 45](https://github.com/user-attachments/assets/2140bf77-9288-4068-9af9-a05baaa7d1dc)

![Simulator Screenshot - iPhone 16 Plus - 2025-02-23 at 11 39 08](https://github.com/user-attachments/assets/0248e4a4-dd1f-41ed-a25e-e64ef4738819)












