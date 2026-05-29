# Spendora - Smart Subscription and Spending Tracker

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
  <img src="https://img.shields.io/badge/Swift-6.3-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.3">
  <img src="https://img.shields.io/badge/SwiftData-6.3-5AC8FA?style=for-the-badge&logo=apple&logoColor=white" alt="SwiftData">
  <img src="https://img.shields.io/badge/License-MIT-34C759?style=for-the-badge" alt="MIT License">
</p>


## Overview

### Introduction

Subscription fatigue has become a widespread problem in modern digital life. Users subscribe to streaming platforms, productivity tools, and cloud services but gradually lose track of recurring payments, leading to unnoticed and unnecessary spending.

**Spendora** is a privacy-focused iOS application designed to help users manage and track their subscriptions through manual input without requiring access to bank accounts or financial credentials. All data is stored locally on the device using SwiftData, ensuring complete privacy and control.

The app helps users answer three key questions:

| Question | How Spendora Answers |
|----------|---------------------|
| What am I paying for? | Dashboard shows all active subscriptions |
| How much do I spend each month? | Automatic monthly and yearly calculations |
| When are my next charges due? | Upcoming billing dates and notifications |
---

### Core Functionality

| Feature | Status | Description |
|---------|--------|-------------|
| Add Subscription | Complete | Name, cost, billing cycle, next billing date |
| Edit Subscription | Complete | Update any subscription details |
| Delete Subscription | Complete | Swipe to delete or use detail view |
| Data Persistence | Complete | SwiftData saves all data locally |

### Smart Calculations

| Feature | Status | Description |
|---------|--------|-------------|
| Monthly Total | Complete | Sum of all monthly costs |
| Yearly Total | Complete | Sum of all yearly costs |
| Yearly to Monthly Conversion | Complete | Yearly subscriptions converted to monthly equivalent |
| Sort by Cost or Date | Complete | Sort subscriptions by price or next billing date |

### iOS Integration

| Feature | Status | Description |
|---------|--------|-------------|
| Local Notifications | Complete | 3-day reminders before billing |
| Dark Mode | Complete | Full dark mode support |
| Haptic Feedback | Complete | Tactile feedback on save and delete |
| Home Screen Widget | Planned | Widget extension prepared for future release |

### User Experience

| Feature | Status | Description |
|---------|--------|-------------|
| Search and Filter | Complete | Filter by name or category |
| Categories | Complete | Entertainment, Productivity, Health, etc. |
| Empty State | Complete | Friendly guide when no subscriptions exist |
| Onboarding | Complete | First-launch tutorial |
| Next Charge Card | Complete | Highlights upcoming bill |
| Analytics Card | Complete | Shows average spending and highest subscription |

### Additional Features

| Feature | Status | Description |
|---------|--------|-------------|
| Cancellation Links | Complete | One-tap to cancel Netflix, Spotify, Apple services |
| Privacy Policy | Complete | Built-in privacy policy view |
| Reset All Data | Complete | Clear all data from Settings |

---

## Technology Stack

| Technology | Purpose |
|------------|---------|
| SwiftUI | Modern declarative UI framework |
| SwiftData | Local data persistence (no cloud required) |
| UserNotifications | 3-day billing reminders |
| WidgetKit | Home screen widget (prepared) |
| WebKit | In-app cancellation pages |

---

## Project Structure


```
Spendora/
├── SpendoraApp.swift                     # App entry point with persistent onboarding
│
├── Models/                               # Data models
│   └── Subscription.swift                # SwiftData model with computed properties
│
├── Views/                                ← Different SCREENS (each is unique)
│   ├── Home/                             ← Screen 1
│   │   └── HomeView.swift                # Main dashboard with totals and list
│   ├── Add/                              ← Screen 2
│   │   └── AddSubscriptionView.swift     # Add subscription form
│   ├── Detail/                           ← Screen 3
│   │   └── SubscriptionDetailView.swift  # Detail view with edit/delete
│   └── Settings/                         ← Screen 4
│       └── SettingsView.swift            # App settings and data management
│
├── Components/                           ← Reusable PIECES (all related)
│   ├── SubscriptionCard.swift            # Subscription card component
│   ├── NextChargeCard.swift              # Upcoming bill card
│   ├── EmptyStateView.swift              # Empty state placeholder
│   └── SearchBar.swift                   # Search and filter component
│
├── Services/                             ← Background LOGIC (all related)
│   ├── NotificationService.swift         # Local notification scheduling
│   └── WidgetSyncService.swift           # Widget data sync (prepared)
│
└── Utils/                                # Helper functions
    └── DateExtensions.swift              # Date formatting helpers
```

### Why This Structure?

| Folder | Purpose | Organization Rule |
|--------|---------|-------------------|
| **Views/** | Different SCREENS | Each screen gets its own folder |
| **Components/** | Reusable PIECES | All related components live together |
| **Services/** | Background LOGIC | All related services live together |
| **Models/** | Data model | Single file, no subfolder needed |
| **Utils/** | Helper functions | Single file, no subfolder needed |

This separation follows **industry best practices** for iOS development.


---

## 🚀 Getting Started


## Requirements

| Requirement | Version |
|-------------|---------|
| Xcode | 15.0 or later |
| iOS | 17.0 or later |
| Swift | 5.9 or later |

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/snaimio/Spendora.git
cd Spendora




