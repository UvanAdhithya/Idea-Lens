#  Idea Lens

**Idea Lens** is an AI-powered mobile learning app that helps users turn **everyday objects into creative DIY projects** using their phone camera.  
Users scan materials around them, and the app intelligently suggests step-by-step projects they can build, learn from, and resume anytime.

---

## What Problem Does Idea Lens Solve?

Many learners:
- Don’t know **what to build** with the materials they already have
- Get overwhelmed by long tutorials
- Drop off mid-project and can’t resume easily

**Idea Lens solves this by:**
- Using AI to understand real-world objects
- Generating **personalized DIY projects**
- Guiding users with **clear, step-by-step instructions**
- Allowing users to **exit and resume projects later**

---

## Core Idea (In One Line)

> **Scan → Get Ideas → Build Step-by-Step → Learn by Doing**

---

## ✨ Key Features

### 📷 AI Material Scanning
- Users scan items using their phone camera
- AI detects materials (e.g., paper, bottles, cardboard)
- Projects are generated based on detected items

### 🧩 AI-Generated DIY Projects
- 3 difficulty levels: Easy, Medium, Hard
- Projects use **only scanned materials**
- Each project has exactly **5 clear steps**

### ▶️ Step-by-Step Project Viewer
- One step at a time (focused learning)
- Large, touch-friendly navigation
- Clear separation between step navigation and app navigation

### 💾 Resume Later Support
- Users can exit a project anytime
- Progress is automatically saved
- Home screen shows a **Resume Project** card

### 🏠 Clean Mobile Dashboard
- Scan CTA (primary action)
- Active project card
- Recommended projects
- Skill & progress snapshot
- Gamification summary

### 🏆 Gamification
- Points for completing steps and projects
- Encourages consistency and learning
- Designed to motivate without distracting

---

## 🧭 Navigation Philosophy

- **Android back button** → exits project and saves progress
- **Next / Previous buttons** → navigate steps
- Project steps are **state-based**, not route-based
- Prevents users from getting stuck inside projects

---

## 🛠️ Tech Stack

| Layer | Technology |
|------|------------|
| Frontend | Flutter (Material 3) |
| AI | Google Gemini API (Vision + Text) |
| Camera | Flutter Camera / Image Picker |
| Backend | Firebase (Firestore) |
| State | Local state + persisted progress |
| Platform | Android (iOS-ready) |

---

## How to Run the App

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio or VS Code
- Android Emulator or physical device
- Internet connection (for AI calls)

 Verify setup:
```bash
flutter doctor
```

### 1. Clone & Install

```bash
git clone https://github.com/UvanAdhithya/Idea-Lens.git
cd Idea-Lens
```
### 2.Install Dependencies
```bash
flutter pub get
```

### Create .env file
```bash
# Google Gemini API Key (get from https://aistudio.google.com/app/apikey)
GEMINI_API_KEY=your_gemini_api_key_here

# Backend/API Base URL
BASE_URL=http://localhost:3000
# Production: BASE_URL=https://your-api-domain.com
```

### Run the app
```bash
flutter run
```

##  Demo Flow 

1. Open the app 
![Alt text](images/home_screen.jpeg)
2. Tap **Scan**  
3. Capture an image of nearby objects  
![Alt text](images/analayze_page.jpeg)
4. View AI-generated project suggestions  
6. Start a project  
6. Exit mid-way  
7. Resume the project later from the Home screen  

---

## 🏆 Why Idea Lens Stands Out

- Combines **computer vision + learning**
- Encourages **hands-on, real-world creativity**
- Strong UX decisions (resume later, clean navigation)
- Scalable for education, makers, and self-learning

---

## 🔮 Future Enhancements

- Step validation using camera feedback
- Offline project mode
- Teacher / parent dashboard
- Skill-based learning analytics
- Community project sharing
