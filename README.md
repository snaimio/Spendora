# Spendora - Smart Subscription & Spending Tracker

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2017%2B-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS 17+">
  <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/Framework-SwiftUI-007AFF?style=for-the-badge&logo=apple&logoColor=white" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Database-SwiftData-5AC8FA?style=for-the-badge&logo=apple&logoColor=white" alt="SwiftData">
  <img src="https://img.shields.io/badge/Widget-WidgetKit-34C759?style=for-the-badge&logo=apple&logoColor=white" alt="WidgetKit">
  <img src="https://img.shields.io/badge/License-MIT-34C759?style=for-the-badge" alt="MIT License">
</p>

---

## 📌 Overview

Subscription fatigue has become a major financial challenge in modern digital life. Users frequently subscribe to streaming platforms, software-as-a-service (SaaS) tools, cloud storage, and fitness memberships, but gradually lose track of recurring billing cycles—leading to unnoticed and wasteful spending.

**Spendora** is a privacy-first, premium iOS application designed to track and optimize subscription spending completely offline without requiring access to bank accounts or sensitive credentials. Built natively with **SwiftUI**, **SwiftData**, **Swift Charts**, and **WidgetKit**, Spendora keeps all user data 100% private and on-device.

### ❓ Core Problem Solved

| Key Question | How Spendora Answers It |
|---|---|
| **What subscriptions am I paying for?** | Clean, searchable dashboard categorized by category, price, and frequency. |
| **How much am I spending each month & year?** | Real-time automated total and average spending metrics in your local currency. |
| **When are my upcoming charges due?** | Interactive timeline, next-charge countdown cards, and 3-day local notifications. |
| **How can I export & share my reports?** | Native PDF report generation & CSV spreadsheet export. |

---

## ✨ Features & Architecture

### 📊 Subscription Management & Analytics

| Feature | Status | Description |
|---|:---:|---|
| **Subscription Tracking** | ✅ Complete | Full CRUD (Create, Read, Update, Delete) via SwiftData. |
| **Smart Billing Cycles** | ✅ Complete | Monthly, Yearly, Quarterly, and Weekly billing calculations. |
| **Currency Engine** | ✅ Complete | Multi-currency engine (CAD, USD, EUR, GBP, JPY, AUD, CHF, INR, BRL, CNY, etc.). |
| **SF Symbols Payment Methods** | ✅ Complete | Premium payment method selectors (Credit, Debit, Apple Pay, PayPal, Bank Transfer). |
| **Search & Filtering** | ✅ Complete | Instant live search by name or category with dynamic sort chips. |

### 📲 iOS 17 Integration & Home Screen Widgets

| Integration | Status | Description |
|---|:---:|---|
| **Home Screen Widgets** | ✅ Complete | iOS 17 Small and Medium widgets powered by App Group (`group.com.trios2026sn.Spendora`). |
| **Local Reminders** | ✅ Complete | 3-day advance billing notifications via `UNUserNotificationCenter`. |
| **Interactive Charts** | ✅ Complete | Interactive category breakdown and spending timeline graphs via **Swift Charts**. |
| **PDF & CSV Export** | ✅ Complete | One-tap PDF summary vector generation and CSV export via `UniformTypeIdentifiers`. |
| **Direct Cancellation Links** | ✅ Complete | Quick direct links to cancel subscriptions on official provider portals. |

---

## 🛠️ Technology Stack

- **UI Framework**: SwiftUI (iOS 17+)
- **Data Persistence**: SwiftData (`@Model`, `@Query`, `ModelContext`)
- **Widget Extension**: WidgetKit (Small & Medium interactive widgets)
- **Data Visualization**: Swift Charts (`Chart`, `SectorMark`, `BarMark`)
- **Document Export**: PDFKit & `UniformTypeIdentifiers` (CSV)
- **Notifications**: UserNotifications (`UNUserNotificationCenter`)
- **Typography & Aesthetics**: Custom monospaced financial digit extensions (`Font+App.swift`) & SF Symbols

---

## 📂 Project Structure

```
Spendora/
├── SpendoraApp.swift                     # App entry point with SwiftData container
│
├── Models/                               # Data models
│   └── Subscription.swift                # SwiftData @Model schema & PaymentMethod enum
│
├── Services/                             # Core Business Logic
│   ├── CurrencyManager.swift             # Currency conversion & formatting engine
│   ├── NotificationService.swift         # Local 3-day billing notification manager
│   ├── WidgetSyncService.swift           # Real-time WidgetKit App Group synchronization
│   ├── PDFExportService.swift            # Native PDF document builder
│   └── CSVExportService.swift            # CSV data exporter
│
├── Extensions/                           # Design Tokens & Helpers
│   └── Font+App.swift                    # Monospaced financial typography system
│
├── Views/                                # SwiftUI Feature Screens
│   ├── Home/                             # Main Dashboard, Hero header, Next Charge card
│   ├── Subscriptions/                    # Subscription detail & edit views
│   ├── Add/                              # Add subscription form
│   ├── Reports/                          # Swift Charts analytics & PDF/CSV export
│   ├── Onboarding/                       # First-launch welcome flow
│   └── Settings/                         # Settings, Currency picker & About Capstone
│
└── SpendoraWidget/                       # Home Screen Widget Extension
    └── SpendoraWidget.swift              # iOS 17 Small and Medium WidgetKit views
```

---

## 🚀 Getting Started

### Prerequisites

| Requirement | Minimum Version |
|---|---|
| **Xcode** | 15.0 or later (Xcode 16+ recommended) |
| **iOS Deployment Target** | iOS 17.0 or later |
| **Swift** | 5.9 or later (Swift 6 compatible) |

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/snaimio/Spendora.git
   cd Spendora
   ```

2. **Open the project in Xcode**:
   ```bash
   open Spendora.xcodeproj
   ```

3. **Build & Run**:
   - Select an **iOS 17+ Simulator** or connected **iPhone**.
   - Press **`Cmd + R`** (or click the Run button) in Xcode to compile and launch.

---

## 👨‍💻 Capstone Project Metadata

- **Developer**: Sheikh Naim
- **Contact Email**: [Sheikh.Naim@triosstudent.com](mailto:Sheikh.Naim@triosstudent.com)
- **Institution**: triOS College Mobile Application Development Capstone 2026

---

## 📄 License

This project is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.
