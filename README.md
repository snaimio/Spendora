# Spendora — iOS Subscription Tracker
### Mobile Application Development Capstone Project 2026

![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.9%20%2F%206.0-FA7343?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-007AFF?style=flat-square&logo=swift&logoColor=white)
![SwiftData](https://img.shields.io/badge/Database-SwiftData-5AC8FA?style=flat-square&logo=apple&logoColor=white)
![WidgetKit](https://img.shields.io/badge/Extension-WidgetKit-34C759?style=flat-square&logo=apple&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-gray?style=flat-square)

**Spendora** is a native iOS application built as a final Capstone Project. It helps users track recurring subscriptions, manage upcoming renewal dates, log bill payments, and analyze spending habits — all with 100% offline, on-device privacy.

---

## 🎥 App Demonstration

<p align="center">
  <img src="screenshots/demo_preview.gif" width="340" alt="Spendora App Interactive Preview" />
</p>

<p align="center">
  <a href="demo/Spendora_Demo.mp4">
    <img src="https://img.shields.io/badge/Watch-Full%20Demo%20Video%20with%20Narration-2AB7A9?style=for-the-badge&logo=apple&logoColor=white" alt="Watch Demo Video" />
  </a>
</p>

* **Video Walkthrough**: [`demo/Spendora_Demo.mp4`](demo/Spendora_Demo.mp4) (Complete demonstration with voice narration covering all features)

---

## 📱 Screenshots

| Dashboard & Budget | Subscriptions List | Service Details & Actions |
|:---:|:---:|:---:|
| <img src="screenshots/dashboard.png" width="240" alt="Dashboard" /> | <img src="screenshots/subscriptions.png" width="240" alt="Subscriptions" /> | <img src="screenshots/service_details.png" width="240" alt="Service Details" /> |

| Add Subscription | AI Insights & Savings | Yearly Report & Charts |
|:---:|:---:|:---:|
| <img src="screenshots/add_subscription.png" width="240" alt="Add Subscription" /> | <img src="screenshots/ai_insights_1.png" width="240" alt="AI Insights" /> | <img src="screenshots/yearly_report.png" width="240" alt="Yearly Report" /> |

| Savings Challenges | Home Screen Widgets | Settings & Backup |
|:---:|:---:|:---:|
| <img src="screenshots/challenges.png" width="240" alt="Challenges" /> | <img src="screenshots/widget.png" width="240" alt="Widgets" /> | <img src="screenshots/settings.png" width="240" alt="Settings" /> |

---

## ✨ Key Features

* **Executive Dashboard**: Real-time monthly spend total in San Francisco Rounded typography, budget utilization gauge, and active subscription count.
* **1-Tap Payment Logging & Instant Undo**: Log payments directly from the next charge card or subscription list to advance billing dates (+1 month or +1 year) and update notifications. Made a mistake? Tap Undo to instantly roll back.
* **Quick Presets & Custom Services**: 15+ pre-configured subscription presets (Netflix, Spotify, ChatGPT, Apple One) with custom theme color chips, reminder lead times, and billing cycles.
* **Smart Search, Filters & Swipe Actions**: Search subscriptions, filter by active or cancelled status, sort by price or renewal date, swipe to mark paid or undo, and long-press for iOS context menus.
* **Direct Provider Cancellation Link**: Open the provider's official cancellation webpage directly in Safari with one tap.
* **AI Cost Insights & Utility Scoring**: Rate subscriptions 1 to 5 stars. The app identifies low-rated services and calculates potential annual savings from cancelling or downgrading.
* **Yearly Reports & Statements**: Interactive Swift Charts comparing historical and projected spending, category breakdowns, PDF statement generation, and CSV spreadsheet export.
* **Home & Lock Screen Widgets**: Small, Medium, Large, and Lock Screen widgets styled in Midnight Sage Teal (`#0E2426`) with the official Spendora logo, updating live via App Groups (`group.com.trios2026sn.Spendora`).
* **Privacy-First Settings & Data Control**: 100% offline SwiftData persistence, multi-currency support (CAD, USD, EUR, GBP, etc.), custom reminder times, and full JSON backup and restore.

---

## 🛠️ Technology Stack & Architecture

Spendora follows the **MVVM** design pattern and uses 100% native Apple frameworks:

* **Language**: Swift 5.9 / Swift 6
* **UI Framework**: SwiftUI (Apple Human Interface Guidelines, SF Symbols, custom theme tokens)
* **Local Database**: SwiftData (`@Model`) for offline persistence
* **Data Visualization**: Swift Charts for interactive yearly and category analytics
* **Widget Extension**: WidgetKit (`StaticConfiguration` + App Group `UserDefaults`)
* **Notifications**: Local notifications via `UNUserNotificationCenter`
* **File Export**: PDF vector rendering and CSV data generation

---

## 🚀 How to Run

### Prerequisites
* Mac running macOS Sonoma (14.0+) or macOS Sequoia
* Xcode 15.0 or later
* iOS 17.0+ Simulator or physical device

### Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/snaimio/Spendora.git
   cd Spendora
   ```
2. **Open in Xcode**:
   ```bash
   open Spendora/Spendora.xcodeproj
   ```
3. **Build and Run**:
   * Select the `Spendora` target and choose an iPhone simulator (e.g., iPhone 15 Pro or iPhone 16 Pro).
   * Press **Cmd + R** to run.

---

## 👨‍💻 Capstone Project Details

* **Author**: Sheikh Naim
* **Course**: Mobile Application Development Capstone 2026
* **License**: [MIT License](LICENSE)
