# 🍽️ Recipe Finder App (Flutter)

A clean and modern **Flutter Recipe Finder application** built using **Clean Architecture + BLoC**, powered by **TheMealDB API**.  
Users can search recipes, filter by category & cuisine, view recipe details, and save favorites with local persistence.

---

## ✨ Features

- 🔍 Search recipes by name (debounced search)
- 🏷 Filter recipes by **Category** and **Cuisine (Area)**
- 🔄 Toggle between **Grid** and **List** view
- ❤️ Mark recipes as **Favorites** (persistent using Hive)
- 📄 Detailed recipe view with:
  - Overview
  - Ingredients
  - Step-by-step Instructions
- ▶️ YouTube recipe video integration
- 🔎 Zoomable recipe image
- ⚡ Shimmer loading placeholders
- 📦 Offline persistence for favorites

---

## 🏗 Architecture

This project follows **Clean Architecture** principles:

- **State Management:** flutter_bloc
- **Dependency Injection:** get_it
- **Local Storage:** Hive
- **Networking:** Dio
- **Image Caching:** cached_network_image

---

## 📱 Screens Implemented

- Recipe List Page
- Recipe Detail Page (Tabs: Overview / Ingredients / Instructions)
- Favorites Page
- Image Viewer Page (Zoom support)

---

## 🧪 Known Limitations (Intentional)

- Combined filtering (Category + Area simultaneously) is currently **basic**
  - Logic can be enhanced by intersecting filters
- No pagination (API limitation)
- Offline recipe browsing not supported (except favorites)

> These trade-offs were made to keep the assignment clean and focused.

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK (stable)
- Android Studio / VS Code
- Android device or emulator

### Steps
```bash
flutter pub get
flutter run
