#  Idea Lens

**Idea Lens** is an AI-powered mobile learning app that helps users turn **everyday objects into creative DIY projects** using their phone camera.  
Users scan materials around them, and the app intelligently suggests step-by-step projects they can build, learn from, and resume anytime.

---

## 🚀 What Problem Does Idea Lens Solve?

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

## 🧠 Core Idea (In One Line)

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

## ▶️ How to Run the App

### 1️⃣ Prerequisites
- Flutter SDK (latest stable)
- Android Studio or VS Code
- Android Emulator or physical device
- Internet connection (for AI calls)

### Verify setup:
```bash
flutter doctor
```

### 1. Clone & Install

```bash
git clone https://github.com/UvanAdhithya/Idea-Lens.git
cd Idea-Lens
