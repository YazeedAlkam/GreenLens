# GreenLens — Project Reference Guide

Quick-search reference for the most important parts of the codebase.
Use Ctrl+F on a keyword (e.g. "tariff", "engineer cost", "status", "report")
to find the explanation and the file that implements it.

---

## 1. What the app is

GreenLens is a Flutter app for an energy-audit company. It manages the full
lifecycle of an energy audit project: a **Section Head** creates the project
and assigns **Engineers**, the **CEO** approves it, engineers enter on-site
audit data (lighting, AC, equipment, machines), both CEO and Section Head
approve the audit, and finally PDF reports are generated through a separate
report server and the project is marked Completed.

- Frontend: Flutter (this repo), Firebase Auth + Cloud Firestore.
- Backend: `greenlens-report-server` (Node/Express on Railway) that fills
  Word templates with project data + chart images and converts them to PDF
  with LibreOffice.

---

## 2. User roles

Stored in `users/{uid}.role` in Firestore; chosen at sign-up
([sign_up.dart](lib/authentication/sign_up.dart)). After login,
[sign_in.dart](lib/authentication/sign_in.dart) reads the role via
`UserModel.fetchCurrent()` and routes to the matching dashboard:

| Role | Dashboard | Main abilities |
|---|---|---|
| Section Head | [section_head_dashboard.dart](lib/section_head_pages/section_head_dashboard.dart) | Create/edit projects, assign engineers, approve submitted audits |
| Engineer | [engineer_dashboard.dart](lib/engineer_pages/engineer_dashboard.dart) | Enter audit data for assigned projects, generate reports, mark complete |
| CEO | [ceo_dashboard.dart](lib/ceo_pages/ceo_dashboard.dart) | Approve/deny new projects and audits, set engineer hourly rates |

The roles dropdown lives in `roles` in [main.dart](lib/main.dart); CEO is
added dynamically only when no CEO account exists yet.

---

## 3. Project status lifecycle (the most-asked question)

Statuses live in `projects/{id}.status`. Transitions
(documented at the top of [project_service.dart](lib/firebase/project_service.dart)):

```
Section Head saves draft          → "Draft"
Section Head submits              → "Awaiting Approval"   (CEO reviews project info)
CEO approves project info         → "In Progress"          (engineers can enter audit data)
Engineer submits audit            → "Awaiting Approval"    (CEO AND Section Head must both approve)
Both approve audit                → "Ready"                (reports can be generated)
CEO or Section Head denies        → "Denied"
Engineer marks as completed       → "Completed"            (moves to Previous Projects)
```

Special case — **Denied**: a project denied *before* audit data exists goes
back to the Section Head (still shown in active lists); a project denied
*after* the audit was submitted goes back through the audit-review flow.
This filter is implemented in `ProjectService.getActiveProjects()` and
`getEngineerActiveProjects()`.

---

## 4. Firestore schema

| Collection / doc | Contents |
|---|---|
| `users/{uid}` | name, email, role, createdAt, customId (sequential int), rate (engineer hourly rate in JOD, set by CEO) |
| `projects/{autoId}` | status, customId ("P-0001"), createdBy, createdAt, updatedAt, clientInfo, projectInfo, costs, assignedEngineers (list of UIDs), auditData |
| `meta/userCounter` | lastId — sequential counter for user customIds |
| `meta/projectCounter` | lastId — sequential counter for project IDs ("P-0001") |

Sub-maps of a project document:
- `clientInfo`: mainContact, secondContact, extraContacts (each name/position/email/phone)
- `projectInfo`: projectName, buildingType, floorArea, noOfFloors, operatingHrsPerDay, daysPerWeek, initiationDate, deadlineDate, salesMark, bills (12 months), averageMonthlyBill
- `costs`: transportationCost, machineryOperatingCost, otherCosts (strings as typed)
- `auditData`: building, lighting (list of areas), ac (list of groups), equipment (list of items), machines (list of lines)

**Sequential IDs**: generated inside a *Firestore transaction* that reads and
increments `meta/projectCounter` (or `userCounter`) atomically, so two users
saving simultaneously can never get the same ID. See
`ProjectService.saveProject()` and `AuthService.signUp()`.

---

## 5. Key calculations (memorize these)

| Calculation | Formula | Where |
|---|---|---|
| Energy tariff | `0.12 JOD per kWh` — constant `energyTariffJodPerKwh` | [main.dart](lib/main.dart) |
| Equipment / machines annual energy | rated power (kW) × quantity × yearly hours | equipment_body / machines_body + their review pages |
| Lighting annual energy | rated power × no. of lights × yearly hours | [lighting_body.dart](lib/engineer_pages/lighting_body.dart) |
| AC annual energy | Split: units × power × hours; Packaged: packages × power × hours; Central: chiller power × hours | [ac_review.dart](lib/engineer_pages/ac_review.dart) `_computeKwh` |
| Energy cost | annual kWh × 0.12 | every review page `_energyCost` |
| Engineer cost | Σ over assigned engineers: hourly rate × 8 hrs/day × working days between initiation and deadline | `_computeEngineerCost()` in [create_new_project_flow.dart](lib/section_head_pages/create_new_project/create_new_project_flow.dart) |
| Working days | every day except **Friday and Saturday** (Jordanian weekend) | `_workingDaysBetween()` (same file + review_body) |
| Total project cost | transportation + machinery + other + engineer cost | [cost_body.dart](lib/section_head_pages/create_new_project/cost_body.dart) `_recompute` |
| Average monthly bill | mean of the bill amounts > 0 over the last 12 months | [bills_body.dart](lib/section_head_pages/create_new_project/bills_body.dart) `_recalculateAverage` |
| Savings assumption | **20%** flat (`_savingsFactor = 0.20`) applied to "after implementation" series in charts | [project_charts_grid.dart](lib/shared_files/charts/project_charts_grid.dart) |

---

## 6. The two wizards

### Create New Project (Section Head) — 5 steps
[create_new_project_flow.dart](lib/section_head_pages/create_new_project/create_new_project_flow.dart)
1. Client Info → 2. Project Info → 3. Assign Engineers → 4. Costs → 5. Review
- Two overlay sub-pages: **Bills** (12-month bill entry, from step 2) and
  **All Contacts** (from step 5).
- Every step is kept mounted in an `IndexedStack` and each form state uses
  `AutomaticKeepAliveClientMixin`, so data survives navigating between steps.
- The parent flow pulls data out of each step with `GlobalKey<...State>` and
  methods like `getClientInfo()`, `getProjectInfo()`, `getCosts()`.
- "Save Draft" → status `Draft`; "Save Project" → `Awaiting Approval`.

### Audit Data Entry (Engineer) — 6 steps
[audit_data_entery_flow.dart](lib/engineer_pages/audit_data_entery_flow.dart)
1. Building → 2. Lighting → 3. AC → 4. Equipment → 5. Machinery → 6. Review
- Same IndexedStack + GlobalKey pattern.
- Each section saves under `auditData.<section>` via
  `ProjectService.saveAuditSection()`.
- `readOnly: true` is reused for the CEO / Section Head review screens —
  same widgets, fields disabled, Submit becomes Close.

---

## 7. Reports pipeline

[report_service.dart](lib/firebase/report_service.dart) — three endpoints on
the Railway server:

| Report | Endpoint | Charts attached |
|---|---|---|
| Technical | `/generate-report` | 4 charts |
| Cost | `/generate-cost-report` | savings donut only |
| Technical & Cost | `/generate-tech-cost-report` | 4 charts |

Flow for every report:
1. Fetch full project document from Firestore.
2. Get a fresh **Firebase ID token** → sent as `Authorization: Bearer` (the
   server verifies it with Firebase Admin — that's the security model).
3. Charts are captured client-side as PNG bytes from `RepaintBoundary`
   widgets ([project_charts_grid.dart](lib/shared_files/charts/project_charts_grid.dart))
   and attached as multipart files `chart1..chart4`.
4. `_sanitize()` recursively converts Firestore `Timestamp`s to ISO strings
   so the document can be JSON-encoded.
5. Server fills a Word template, converts to PDF with LibreOffice (30–60 s,
   client timeout 120 s), returns PDF bytes.
6. `saveAndOpenPdf()` is platform-specific via **conditional imports**:
   [report_download_web.dart](lib/firebase/report_download_web.dart) (browser
   anchor download) vs [report_download_mobile.dart](lib/firebase/report_download_mobile.dart)
   (temp file + open) vs stub.

---

## 8. Charts (4 cards)

[project_charts_grid.dart](lib/shared_files/charts/project_charts_grid.dart)
loads the project and computes all series; cards are in `lib/shared_files/charts/`:
1. **Savings Donut** — annual energy cost split by system (Lighting / AC / Equipment / Machines), from audit data.
2. **Annual Consumption** — monthly kWh bar chart from the 12 entered bills.
3. **Potential Savings** — before vs after kWh (after = before × 0.8).
4. **Estimated Cost** — current vs savings-adjusted monthly cost in JOD.

Each card sits in a keyed `RepaintBoundary` so it can be captured as a PNG
for the PDF reports.

---

## 9. Authentication

[auth_service.dart](lib/firebase/auth_service.dart):
- `signUp()` creates the Firebase Auth account, then in **one transaction**
  increments `meta/userCounter` and writes `users/{uid}` (name, email, role,
  customId).
- `signIn()` → Firebase Auth; role is fetched afterwards by
  [user_model.dart](lib/authentication/user_model.dart) `fetchCurrent()`.
- `sendPasswordResetEmail()` powers the "Forgot password?" dialog.
- `_handleAuthException()` maps Firebase error codes to friendly messages.

---

## 10. Shared UI building blocks

| Widget | File | Purpose |
|---|---|---|
| `Footer` + `FooterMode` enum | [footer.dart](lib/shared_files/footer.dart) | One bottom action bar for all wizards; the enum picks which buttons show (normal / review / backOnly / viewOnly / done / auditNormal / submitReview / acceptDeny / markComplete / saveChanges) |
| `CustomAppBar` | [custom_app_bar.dart](lib/shared_files/custom_app_bar.dart) | Standard green header with title/subtitle |
| `NavigationBarLines` (steppers) | create_new_project/shared_files/nav_bar.dart, assign_engineers/shared_files/nav_bar.dart, navbar_eng.dart | Step circles + connectors + progress bar for each wizard |
| `Background` | [background.dart](lib/shared_files/background.dart) | Decorative auth-screen background |
| `ProjectsTemplate` | [projects_template.dart](lib/shared_files/projects_template.dart) | Dashboard project card with status badge |
| Color palette + tariff | [main.dart](lib/main.dart) | All `const Color`s and `energyTariffJodPerKwh` are global so a change propagates app-wide |

Status badge colors: `inProgressColor` (purple), `awaitingApprovalColor`
(amber), `draftColor` (grey), `deniedColor` (red), `readyColor` (green).

---

## 11. Patterns worth naming in a viva

- **Service layer**: all Firestore access goes through `ProjectService` /
  `AuthService` / `ReportService` — UI widgets never query Firestore
  directly (except the CEO rates page, which batches writes itself).
- **Firestore transactions** for sequential human-readable IDs.
- **GlobalKey + State accessor methods** instead of a state-management
  package: the wizard parent owns navigation, children own their form state.
- **IndexedStack + AutomaticKeepAliveClientMixin** to preserve form state
  across wizard steps.
- **readOnly flag reuse**: the same entry widgets serve as review screens
  for the CEO/Section Head by disabling inputs.
- **Conditional imports** for platform-specific PDF download (web vs mobile).
- **RepaintBoundary chart capture** to embed live Flutter charts in
  server-generated PDFs.
- **Client-side sorting** (instead of Firestore `orderBy` with `where`) to
  avoid composite-index requirements.
- **Dual approval**: audit needs both CEO and Section Head approval; each
  reviewer writes their flag and the project only becomes "Ready" when both
  are set (see [ceo_audit_review_page.dart](lib/ceo_pages/ceo_audit_review_page.dart)).

---

## 12. File map (where to look for anything)

```
lib/
├── main.dart                      # entry point, routes, colors, tariff constant
├── authentication/               # sign in / sign up / UserModel
├── firebase/
│   ├── auth_service.dart          # auth + user creation transaction
│   ├── project_service.dart       # ALL project Firestore reads/writes
│   ├── report_service.dart        # talks to the report server
│   └── report_download_*.dart     # platform-specific PDF saving
├── section_head_pages/
│   ├── create_new_project/        # 5-step wizard (+ bills, contacts sub-pages)
│   ├── assign_engineers/          # 2-step re-assignment flow
│   ├── active_projects/ previous_projects/
│   └── section_head_dashboard.dart
├── engineer_pages/
│   ├── audit_data_entery_flow.dart  # 6-step audit wizard
│   ├── *_body.dart                # entry forms (building/lighting/ac/equipment/machines)
│   ├── *_review.dart              # read-only review tables with kWh/cost calcs
│   ├── project_page.dart          # charts + report generation + mark complete
│   ├── project_summary_page.dart  # full project drill-down
│   └── shared_files/              # AC group forms, forum state, engineer nav bar
├── ceo_pages/
│   ├── ceo_project_review_page.dart   # approve/deny new projects
│   ├── ceo_audit_review_page.dart     # approve/deny submitted audits (dual approval)
│   ├── assign_engineer_costs_page.dart # set hourly rates (feeds engineer cost calc)
│   └── ceo_dashboard.dart / ceo_active_projects_page.dart
└── shared_files/
    ├── footer.dart                # FooterMode-driven action bar
    ├── charts/                    # 4 chart cards + grid + theme
    └── custom_app_bar.dart, background.dart, projects_template.dart
```