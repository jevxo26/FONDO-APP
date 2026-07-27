# Vendor Dashboard — Complete Build Plan

Based on PRD (Vendor Workflow §8), API docs (Vendor Self-Service), and data models.

---

## Current State

7 placeholder pages exist — each renders only `PageHeader` + 3–4 `StatCard`. No tables, forms, data grids, or action flows. Sidebar has 6 nav items in 3 sections, Overview suppressed.

---

## 1. Sidebar Restructure

**File:** `src/data/vendor-dashboard.ts`

Add Overview back, expand to **12 items / 4 sections**:

| Section | Items |
|---------|-------|
| **Business** | Overview, Foods, Orders |
| **Operations** | Kitchens, Staff, Branches |
| **Finance** | Earnings, Bank Accounts |
| **Settings** | Profile, Operating Hours, Service Areas, Settings |

---

## 2. Subpages & Components

### Overview (`/dashboard/vendor`)
- Stat cards: Total Foods, Today's Orders, Pending, Today's Earnings, Avg Rating, Active Kitchens
- Quick Actions: Add Food, View Orders, Toggle Online
- Recent Orders mini-table (last 5)
- Earnings chart (weekly sparkline or mini bar)
- Kitchen status widgets (capacity gauges)

### Foods (`/dashboard/vendor/foods`)
- **DataTable** — columns: Food Name, Category, SKU, Kitchen, Price, Stock Status, Status
- Filters: Status, Category, Kitchen
- Actions: Map new food (modal), Edit mapping, Update price, Update stock, View recipe, View cost
- Sub-routes: `/price`, `/stock`, `/recipes`, `/cost`

### Orders (`/dashboard/vendor/orders`)
- Status filter chips: All, Pending, Confirmed, Preparing, Ready, Picked Up, Delivered, Cancelled
- **DataTable** — columns: Order #, Customer, Items, Total, Status, Payment, Date
- Sub-route: `[id]` detail page — customer info, items, status timeline, assign rider

### Kitchens (`/dashboard/vendor/kitchens`)
- **DataTable** — columns: Name, Code, Branch, Capacity, Prep Time, Status
- CRUD: Add kitchen (modal with branch dropdown), Edit, Delete
- Stats: Active Kitchens, Staff On Duty, Avg Prep Time, Avg Daily Orders

### Staff (`/dashboard/vendor/staff`)
- **DataTable** — columns: Name, Phone, Email, Designation, Branch, Salary, Status, Roles
- CRUD: Add staff (select from platform users), Edit, Delete, Assign Role
- Role assignment modal: KitchenManager/Chef/Cook/Packing + permissions

### Branches (`/dashboard/vendor/branches`) — NEW
- **DataTable** — columns: Name, Code, Area, Phone, Main Branch, Status
- CRUD: Add branch (modal with address fields + lat/lng), Edit, Delete, Set Primary

### Earnings (`/dashboard/vendor/earnings`)
- Stat cards: Today, Week, Month, Pending Settlement
- Wallet balance with hold balance
- **Settlements DataTable** — columns: Settlement #, Date, Order Amount, Commission, Payable, Status
- **Wallet Transactions DataTable** — columns: ID, Type, Amount, Balance, Reference, Date
- Date range picker

### Bank Accounts (`/dashboard/vendor/bank-accounts`) — NEW
- **DataTable** — columns: Bank Name, Account Name, Account #, Type, Routing #, Primary
- CRUD: Add (modal with bank/mobile banking fields), Edit, Delete, Set Primary

### Profile (`/dashboard/vendor/profile`) — NEW (extract from settings)
- Form: Business Name, Owner Name, Phone, Email, Logo, Cover Image, Description
- Online/Offline toggle
- Documents section: Upload table — Type, Number, File, Expiry, Status
- Extended profile: Business Type, Category, Founded Year, Employee Count, Social Links

### Operating Hours (`/dashboard/vendor/operating-hours`) — NEW
- Table: 7 rows (Mon–Sun), columns: Day, Opening, Closing, Closed toggle
- Inline edit or modal per day
- Holidays sub-section: Date picker + name, table

### Service Areas (`/dashboard/vendor/service-areas`) — NEW
- **DataTable** — columns: Division, District, Area, Delivery Charge, Min Order, Est. Delivery Time
- CRUD: Add area (modal), Delete

### Settings (`/dashboard/vendor/settings`)
- Toggle cards: Auto-accept Order, Auto-assign Rider, Allow Custom Meal, Notifications, SMS, Email
- Deactivate account section

---

## 3. Data Layer

New data files (all use seeded PRNG):

| File | Content |
|------|---------|
| `src/data/vendor-foods.ts` | VendorFoodMapping, VendorPrice, VendorStock |
| `src/data/vendor-branches.ts` | Branch list |
| `src/data/vendor-kitchens.ts` | Kitchen list |
| `src/data/vendor-staff.ts` | Staff list |
| `src/data/vendor-earnings.ts` | Settlements, WalletTransactions |
| `src/data/vendor-bank-accounts.ts` | Bank accounts |
| `src/data/vendor-operating-hours.ts` | Weekly hours, holidays |
| `src/data/vendor-service-areas.ts` | Delivery areas |
| `src/data/vendor-profile.ts` | Profile + documents |

---

## 4. Component Structure

Follow admin pattern — one folder per domain:

```
src/components/dashboard/vendor/
├── overview/
├── foods/
│   ├── food-table-section.tsx
│   ├── food-columns.tsx
│   ├── add-food-modal.tsx
│   ├── price-section.tsx
│   ├── stock-section.tsx
│   └── recipe-section.tsx
├── orders/
│   ├── orders-table-section.tsx
│   ├── order-columns.tsx
│   └── order-detail/
├── kitchens/
│   ├── kitchen-table-section.tsx
│   ├── kitchen-columns.tsx
│   └── add-kitchen-modal.tsx
├── staff/
│   ├── staff-table-section.tsx
│   ├── staff-columns.tsx
│   ├── add-staff-modal.tsx
│   └── assign-role-modal.tsx
├── branches/
│   ├── branch-table-section.tsx
│   ├── branch-columns.tsx
│   └── add-branch-modal.tsx
├── earnings/
│   ├── settlement-table-section.tsx
│   ├── settlement-columns.tsx
│   ├── wallet-table-section.tsx
│   └── wallet-columns.tsx
├── bank-accounts/
│   ├── bank-table-section.tsx
│   ├── bank-columns.tsx
│   └── add-bank-modal.tsx
├── profile/
│   ├── profile-form.tsx
│   ├── documents-section.tsx
│   └── online-toggle.tsx
├── operating-hours/
│   ├── hours-table.tsx
│   └── holiday-section.tsx
├── service-areas/
│   ├── area-table-section.tsx
│   ├── area-columns.tsx
│   └── add-area-modal.tsx
└── settings/
    ├── settings-cards.tsx
    └── danger-zone.tsx
```

---

## 5. Page Files (new/modified)

| Path | Action |
|------|--------|
| `src/app/dashboard/vendor/page.tsx` | Rewrite — full overview |
| `src/app/dashboard/vendor/layout.tsx` | Update sidebar, enable Overview |
| `src/app/dashboard/vendor/foods/page.tsx` | Rewrite — table + filters |
| `src/app/dashboard/vendor/foods/price/page.tsx` | NEW |
| `src/app/dashboard/vendor/foods/stock/page.tsx` | NEW |
| `src/app/dashboard/vendor/orders/page.tsx` | Rewrite — table + filters |
| `src/app/dashboard/vendor/orders/[id]/page.tsx` | NEW |
| `src/app/dashboard/vendor/kitchens/page.tsx` | Rewrite — table + CRUD |
| `src/app/dashboard/vendor/staff/page.tsx` | Rewrite — table + CRUD |
| `src/app/dashboard/vendor/branches/page.tsx` | NEW |
| `src/app/dashboard/vendor/earnings/page.tsx` | Rewrite — tables + wallet |
| `src/app/dashboard/vendor/bank-accounts/page.tsx` | NEW |
| `src/app/dashboard/vendor/profile/page.tsx` | NEW |
| `src/app/dashboard/vendor/operating-hours/page.tsx` | NEW |
| `src/app/dashboard/vendor/service-areas/page.tsx` | NEW |
| `src/app/dashboard/vendor/settings/page.tsx` | Rewrite — toggle cards |

---

## 6. Implementation Order

| # | Step | Est. Files | Reason |
|---|------|-----------|--------|
| 1 | Data files | ~12 | All components depend on data |
| 2 | Sidebar restructure + layout + Overview | 2 | Navigation foundation |
| 3 | Orders (table + filters + detail) | 8 | Core operational page |
| 4 | Foods (table + price/stock subpages) | 10 | Core catalog |
| 5 | Kitchens (table + CRUD modal) | 6 | Ops backbone |
| 6 | Staff (table + CRUD + role modal) | 6 | People mgmt |
| 7 | Branches (table + CRUD) | 5 | Location structure |
| 8 | Earnings (settlements + wallet) | 6 | Finance |
| 9 | Bank Accounts (table + CRUD) | 5 | Payout setup |
| 10 | Profile (form + documents + toggle) | 5 | Business identity |
| 11 | Operating Hours (weekly grid + holidays) | 3 | Schedule |
| 12 | Service Areas (table + CRUD) | 5 | Delivery zones |
| 13 | Settings (toggle cards + danger zone) | 2 | Preferences |
