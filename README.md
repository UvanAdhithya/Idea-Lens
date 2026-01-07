# Idea Lens

Idea Lens is a Flutter‑powered AI dashboard that helps you generate, refine, and manage ideas using Google Gemini, with features like photo compression and a reward system.

## ✨ Features

- AI‑powered idea generation & refinement via Google Gemini API
- Photo compression utility (`feature/photo-compressor`)
- Reward/gamification system (`feature/reward-system`)
- Multi‑version dashboards (`dashboard-v3`, `legacy-dashboard`)
- Native mobile/web Flutter app

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **AI**: Google Gemini API
- **API**: Custom backend (BASE_URL configurable)
- **Build**: Flutter CLI

## 🚀 Quick Start

### 1. Clone & Install

```bash
git clone https://github.com/UvanAdhithya/Idea-Lens.git
cd Idea-Lens

##command to install dependencies
flutter pub get


##create .env file
# Google Gemini API Key (get from https://aistudio.google.com/app/apikey)
GEMINI_API_KEY=your_gemini_api_key_here

# Backend/API Base URL
BASE_URL=http://localhost:3000
# Production: BASE_URL=https://your-api-domain.com

##run command
flutter run

