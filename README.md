# 📱 Legal Assistance – Flutter Mobile App

The **Legal Assistance Flutter App** is a cross-platform mobile application built using Flutter and Dart, designed to provide seamless interaction between clients and legal professionals. It acts as the mobile frontend of the Legal Assistance system, which includes a powerful RESTful PHP & MySQL backend.

This app allows users to sign up, log in, search for lawyers, submit legal issues, and track case progress — all from their mobile devices. The app also integrates with a **recommendation system** to suggest top-rated lawyers and offers a **real-time secure chat** system for client-lawyer communication.

---

## 📋 Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
- [Screenshots](#screenshots)
- [Dependencies](#dependencies)
- [Folder Structure](#folder-structure)
- [API Integration](#api-integration)
- [License](#license)

---

## ✨ Features

- **User Authentication**
  - Register / Login
  - Profile management

- **Lawyer Discovery**
  - View list of lawyers
  - Search and filter by specialization
  - View lawyer profiles and ratings
  - Receive lawyer recommendations (via cosine similarity)

- **Issue Management**
  - Create and submit legal issues
  - Track issue status (active/inactive)
  - View issue history

- **Secure Messaging**
  - Real-time chat between users and lawyers
  - File sharing within conversations

- **Agency Management**
  - View and select from available legal agencies

- **Multilingual Support** *(optional if implemented)*

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or later)
- Dart SDK
- Android Studio / Xcode / VS Code
- Connection to the running backend (see: [Legal Assistance Web Repo](https://github.com/ASPU-Projects/Legal-Assistance.git))

### Installation

```bash
git clone https://github.com/ASPU-Projects/Legal-Assistance-Mobile.git
cd Legal-Assistance-Mobile
flutter pub get
flutter run
