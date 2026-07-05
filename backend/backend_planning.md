# Construction Site Management System - Backend Planning Document

## 1. Project Overview
This document outlines the architecture, data models, and module planning for the backend of the Construction Site Management System. The system is designed to support multi-tenant usage (via Companies) and manages construction sites, user roles, daily reporting, and task progress.

## 2. Technology Stack
*   **Runtime/Environment:** Node.js, Express.js (v5)
*   **Language:** TypeScript
*   **Database:** PostgreSQL
*   **ORM:** Drizzle ORM
*   **Data Validation:** Zod
*   **Authentication:** JSON Web Tokens (JWT), bcryptjs
*   **Dev Tools:** `tsx` for local development, `drizzle-kit` for database migrations/studio.

## 3. System Architecture
The backend follows a modular, Domain-Driven Design (DDD) inspired architecture. Each domain entity is encapsulated in its own module within the `src/modules` directory.

### Directory Structure
*   `src/app.ts`: Express application setup, global middleware (CORS, Error Handler), and route aggregation.
*   `src/config/`: Configuration files (e.g., environment variables).
*   `src/database/`: Drizzle ORM configuration, migrations, and schema definitions.
*   `src/middleware/`: Global middleware such as `authMiddleware` and `errorMiddleware`.
*   `src/modules/`: Domain-specific modules (Auth, Company, Site, Task, etc.). Each typically contains:
    *   `*.routes.ts`: Express router definitions.
    *   `*.controller.ts`: Request/response handling.
    *   `*.service.ts`: Core business logic.
    *   `*.repository.ts`: Database interaction (optional, currently seen in `daily_report`).
    *   `*.validation.ts`: Zod schema definitions for request validation.
    *   `*.types.ts`: TypeScript interfaces and types.
*   `src/shared/`: Shared utilities, enums (e.g., `SiteStatus`, `TaskStatus`).

## 4. Database Schema & Data Model
The system uses PostgreSQL, with relationships carefully modeled to support a multi-tenant hierarchy.

### Core Entities
1.  **Users (`users`)**
    *   Central identity for authentication.
    *   Roles: `admin`, `manager`, `engineer`.
2.  **Companies (`companies`)**
    *   Represents the top-level tenant organization.
    *   Created by a User.
3.  **Company Members (`company_members`)**
    *   Maps Users to Companies with specific organizational roles.
4.  **Sites (`sites`)**
    *   Construction projects belonging to a Company.
    *   Fields: Name, Code, Address/Location, Coordinates, Status (`ACTIVE`, `ON_HOLD`, `COMPLETED`, `ARCHIVED`).
5.  **Site Assignments (`site_assignments`)**
    *   Maps Company Members to specific Sites to control access and responsibilities.
6.  **Tasks (`tasks`)**
    *   Specific work items bound to a Site.
    *   Fields: Priority, Status, Start/Due dates, assigned creator.
7.  **Task Progress (`task_progress`)**
    *   Tracks updates and status changes for tasks over time.
8.  **Daily Reports (`daily_report`)**
    *   Summaries of site activities.
9.  **Issues (`issues`) & Proof Photos (`proof_photos`)**
    *   Tracks on-site problems and visual evidence for reports/issues.
10. **Report Approvals (`report_approval`)**
    *   Workflow system for managers to approve submitted reports.

## 5. API Module Status

| Module | Status | Description |
| :--- | :--- | :--- |
| **Auth** | Fully Integrated | Registration, Login, Token generation. |
| **Company** | Fully Integrated | Company creation and management. |
| **Company Member**| Fully Integrated | Adding/managing users within a company. |
| **Site** | Fully Integrated | CRUD for construction sites. |
| **Site Assignment**| Fully Integrated | Assigning personnel to sites. |
| **Task** | Fully Integrated | Task management on sites. |
| **Daily Report** | In Progress | Currently has Service/Repository/Validation, but missing Controllers/Routes. |
| **Issues/Photos** | Planned | Database schemas exist, pending module implementation. |

## 6. Next Steps & Implementation Plan

### Phase 1: Complete Daily Report Module
*   Implement `daily_report.controller.ts` to handle HTTP requests for creating, viewing, and listing daily reports.
*   Implement `daily_report.routes.ts` and register it in `src/app.ts` (`/api/v1/daily-reports`).

### Phase 2: Implement Issues and Proof Photos
*   Create the `issues` module (routes, controller, service, validation) to allow users to report and track site blockers.
*   Create the `proof_photos` module, potentially integrating with cloud storage (e.g., AWS S3, Cloudinary) to handle image uploads for Daily Reports and Issues.

### Phase 3: Implement Report Approvals
*   Create the `report_approval` module to build the workflow for managers/admins to review and approve/reject Daily Reports.

### Phase 4: Refinement & Optimization
*   Add pagination and filtering to list endpoints (Sites, Tasks, Reports).
*   Implement strict Role-Based Access Control (RBAC) middleware to ensure users only access resources within their Company and Site Assignment scope.
*   Add comprehensive unit and integration tests.
