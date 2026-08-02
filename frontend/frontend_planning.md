# Construction Site Management System - Frontend Planning Document

## 1. Project Overview
This document outlines the architecture, features, and module planning for the frontend (Flutter App) of the Construction Site Management System. The mobile app interfaces with the Node.js backend to provide a robust, role-based experience for Admins, Managers, and Engineers on-site.

## 2. Technology Stack
*   **Framework:** Flutter
*   **Language:** Dart
*   **State Management:** BLoC
*   **Routing:** GoRouter
*   **Network/API:** http package
*   **Local Storage:** flutter_secure_storage (for JWT tokens)
*   **Image Handling:** image_picker (for Proof Photos)
*   **Environment Config:** flutter_dotenv

## 3. App Architecture
The frontend will follow a feature-driven (modular) directory structure. This mirrors the Domain-Driven Design of the backend, making it easier to scale and maintain.

### Proposed Directory Structure (`lib/`)
*   `core/`: Shared utilities, themes, constants, networking client, routing setup.
*   `features/`: Domain-specific features. Each feature will contain:
    *   `data/`: Repositories, models, and remote data sources.
    *   `domain/`: Entities and use cases (if using Clean Architecture).
    *   `presentation/`: UI screens, widgets, and state controllers (BLoCs / Cubits).
*   `shared/`: Reusable widgets (buttons, text fields, cards) used across multiple features.

## 4. Frontend Module & Feature Status

This table maps directly to the backend API modules, tracking the progress of UI and integration implementation in the Flutter app.

| Feature / Module | Status | Description |
| :--- | :--- | :--- |
| **App Setup & Theming** | Pending | Initial project structure, routing, theme setup (colors, typography). |
| **Auth UI** | Pending | Login, Registration screens, state management for authentication, token storage. |
| **Dashboard** | Pending | Role-based landing page with quick stats, pending tasks, and recent sites. |
| **Company Profile** | Pending | Screens to view and update company details. |
| **Member Management**| Pending | UI for Admins/Managers to add/remove users and assign roles within a company. |
| **Site Management** | Pending | List of sites, Site creation form, and Site details view. |
| **Site Assignment**| Pending | Interface to assign company members to specific sites. |
| **Task Management** | Pending | Task list/Kanban view, creating tasks, assigning deadlines and priorities. |
| **Task Progress** | Pending | Screens/Dialogs for Engineers to update the status of their assigned tasks. |
| **Daily Reports** | Pending | Form for Engineers to submit daily site reports and view historical reports. |
| **Issues** | Pending | Interface to log blockers or problems encountered on-site. |
| **Proof Photos** | Pending | Camera/Gallery integration to attach photos to reports and issues. |
| **Report Approval** | Pending | Dedicated view for Managers to review submitted reports and approve/reject them. |

## 5. Next Steps & Implementation Plan

### Phase 1: Foundation & Authentication
1.  Setup Flutter project structure (`core`, `features`, `shared`).
2.  Configure routing (`GoRouter`) and state management.
3.  Implement global App Theme (colors, fonts).
4.  Build Auth UI (Login/Register) and integrate with backend API.

### Phase 2: Core Entity Management (Admin/Manager Focus)
1.  Implement Dashboard layout.
2.  Build Company and Member management screens.
3.  Build Site creation and listing screens.
4.  Implement Site Assignment interfaces.

### Phase 3: Operations (Engineer/Manager Focus)
1.  Task listing and creation screens.
2.  Task progress update flows.
3.  Daily report submission forms.

### Phase 4: Advanced Features & Media
1.  Issue logging UI.
2.  Implement native camera/gallery integration for Proof Photos.
3.  Build the Report Approval workflow for managers.
4.  Polish UI/UX and add final validations.
