# Spendora - Smart Subscription and Spending Tracker

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![SwiftData](https://img.shields.io/badge/SwiftData-supported-green.svg)](https://developer.apple.com/xcode/swiftdata/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

## Overview

**Spendora** is a privacy-first iOS application that helps users track, manage, and understand their recurring subscriptions. No bank connections required — all data stays locally on the user's device.

### Problem Statement

Subscription fatigue is a growing issue. Users subscribe to multiple services (Netflix, Spotify, Apple One, etc.) but lose track of monthly spending, leading to unexpected charges and wasted money.

### Solution

Spendora provides a clean, intuitive dashboard where users can manually track subscriptions without sharing sensitive financial data.

---

## Features

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

Spendora/
├── SpendoraApp.swift # App entry point with onboarding
│
├── Models/
│ └── Subscription.swift # SwiftData model with computed properties
│
├── Views/
│ ├── Home/
│ │ └── HomeView.swift # Main dashboard with totals and list
│ ├── Add/
│ │ └── AddSubscriptionView.swift # Add subscription form
│ ├── Detail/
│ │ └── SubscriptionDetailView.swift # Detail view with edit and delete
│ └── Settings/
│ └── SettingsView.swift # App settings and data management
│
├── Components/
│ ├── SubscriptionCard.swift # Reusable subscription card component
│ ├── NextChargeCard.swift # Upcoming bill highlight card
│ ├── EmptyStateView.swift # Empty state placeholder
│ └── SearchBar.swift # Search and filter component
│
├── Services/
│ ├── NotificationService.swift # Local notification scheduling
│ └── WidgetSyncService.swift # Widget data sync (prepared)
│
└── Utils/
└── DateExtensions.swift # Date helper functions


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




