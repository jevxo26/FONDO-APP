# FONDO — API Reference

> **Base URL:** `http://localhost:3000/api`  
> **Response Envelope:**
> ```json
> { "success": true, "message": "string", "data": { … } }
> ```
> **Error Response:**
> ```json
> { "success": false, "message": "string", "error": { "code": "string?", "details": "any?" } }
> ```
> **Auth:** JWT Bearer in `Authorization: Bearer <token>` header  
> **Refresh:** httpOnly cookie named `refreshToken` (set by login, read by /auth/refresh)  
> **Request body:** JSON. `*` = required. Omitted fields = optional.

### Auth Flow

```
POST /auth/register → user object (no tokens)
POST /auth/login    → { token, user } + refreshToken cookie
  ↓
Use Authorization: Bearer <token> for all [JWT] endpoints
  ↓
POST /auth/refresh  → { token } (reads refreshToken from cookie)
POST /auth/logout   → clears cookie, invalidates session
```

**Status Legend**
| | Meaning |
|---|---------|
| 🟢 | Built and working |
| ⚪ | Planned (not started) |

**Quick reference:** [`API_REFERENCE.md`](./API_REFERENCE.md) — one-page route table.

## Index

<div style="display: flex; gap: 40px;">
<div>

| | Feature | Workflow Module |
|---|---|---|
| 🟢 | [Auth](#1-auth) | Module 1 |
| 🟢 | [Users & Profile](#2-users--profile) | Module 1 |
| 🟢 | [Food Catalog (Customer)](#3-food-catalog-customer) | Module 4 |
| 🟢 | [Food Admin (CRUD)](#4-food-admin-crud) | Module 4 |
| 🟢 | [Cart & Checkout](#5-cart--checkout) | Module 7 |
| 🟢 | [Orders](#6-orders) | Module 7 |
| 🟢 | [Customers (Admin)](#7-customers-admin) | Module 1 |
| 🟢 | [Vendors](#8-vendors) | Module 3 |
| ⚪ | [Packages & Meal Plans](#9-packages--meal-plans) | Module 6 |
| ⚪ | [Subscriptions](#10-subscriptions) | Module 12 |

</div>
<div>

| | Feature | Workflow Module |
|---|---|---|
| 🟢 | [Payments](#11-payments) | Module 8 |
| 🟢 | [Customer Wallet](#12-customer-wallet) | Module 8 |
| 🟢 | [Vendor Settlements](#13-vendor-settlements) | Module 8 |
| ⚪ | [Riders](#14-riders) | Module 9 |
| ⚪ | [Deliveries & Tracking](#15-deliveries--live-tracking) | Module 9 |
| ⚪ | [Notifications](#16-notifications) | Module 10 |
| ⚪ | [Support Tickets](#17-support-tickets) | Module 10 |
| ⚪ | [CMS](#18-cms) | Module 11 |
| ⚪ | [Reports & Analytics](#19-reports--analytics) | Module 14 |
| ⚪ | [Roles & Permissions](#20-roles--permissions) | Module 2 |
| ⚪ | [System Settings](#21-system-settings) | Module 11 |

</div>
</div>

---

## Conventions

### Pagination
`GET` list endpoints accept `?page=1&limit=20`. Response:
```json
{ "items": [], "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int" }
```

### Soft Delete
Models with `deletedAt` use soft delete. `DELETE` marks record as deleted, not removed.

### Standard CRUD
`GET /resource` — list all (paginated)  
`GET /resource/:id` — get one  
`POST /resource` — create  
`PATCH /resource/:id` — partial update  
`DELETE /resource/:id` — delete

---

<a id="1-auth"></a>
## 1. Auth

🟢 **All 10 endpoints built. No auth required unless marked `[JWT]`.**

### 🟢 `POST /auth/register`

Create customer account. Sets `refreshToken` as httpOnly cookie.

**Request `*` = required**
```json
{
  "firstName": "*String",
  "lastName": "*String",
  "phone": "*String (+8801XXXXXXXXX)",
  "email": "*String (valid email)",
  "password": "*String (min 6 chars)",
  "gender": "String (MALE|FEMALE|OTHER)",
  "avatar": "String (URL)",
  "dateOfBirth": "Date (ISO)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "firstName": "String",
  "lastName": "String",
  "phone": "String",
  "email": "String",
  "avatar": "String?",
  "gender": "String?",
  "dateOfBirth": "String?",
  "role": "CUSTOMER",
  "status": "ACTIVE",
  "isPhoneVerified": false,
  "isEmailVerified": false,
  "lastLoginAt": null,
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### 🟢 `POST /auth/login`

Provide **either** email or phone + password. Sets `refreshToken` as httpOnly cookie.

**Request**
```json
{
  "email": "String (if no phone)",
  "phone": "String (if no email)",
  "password": "*String"
}
```

**Response `200`**
```json
{
  "token": "String (JWT access token)",
  "user": {
    "id": "UUID",
    "firstName": "String",
    "lastName": "String",
    "phone": "String",
    "email": "String",
    "avatar": "String?",
    "gender": "String?",
    "dateOfBirth": "String?",
    "role": "String",
    "status": "String",
    "isPhoneVerified": false,
    "isEmailVerified": false,
    "lastLoginAt": "DateTime?",
    "createdAt": "DateTime",
    "updatedAt": "DateTime"
  }
}
```

### 🟢 `POST /auth/otp/send`

**Request**
```json
{
  "phone": "String (if no email)",
  "email": "String (if no phone)",
  "purpose": "*String (LOGIN|REGISTER|FORGOT_PASSWORD|PHONE_VERIFY|EMAIL_VERIFY)"
}
```

**Response `200`**
```json
{
  "otp": "String (6-digit, dev only)",
  "message": "OTP sent successfully"
}
```

### 🟢 `POST /auth/otp/verify`

**Request**
```json
{
  "phone": "String (if no email)",
  "email": "String (if no phone)",
  "otp": "*String (6 digits)",
  "purpose": "*String (LOGIN|REGISTER|FORGOT_PASSWORD|PHONE_VERIFY|EMAIL_VERIFY)"
}
```

**Response `200`**
```json
{ "message": "OTP verified successfully" }
```

### 🟢 `POST /auth/refresh`

Reads `refreshToken` from httpOnly cookie first. Falls back to request body.

**Request**
```json
{ "refreshToken": "String (only if not in cookie)" }
```

**Response `200`**
```json
{ "token": "String (new JWT access token)" }
```

### 🟢 `POST /auth/logout`

Clears `refreshToken` cookie. Reads token from cookie automatically.

**Request** — none
**Response `200`**
```json
{ "message": "Logged out successfully" }
```

### 🟢 `POST /auth/forgot-password`

Sends reset token. **Dev only** — returns token directly.

**Request**
```json
{ "email": "*String" }
```

**Response `200`**
```json
{ "resetToken": "String (32-byte hex)", "expiresIn": 3600 }
```

### 🟢 `POST /auth/reset-password`

**Request**
```json
{
  "token": "*String (from forgot-password)",
  "password": "*String (min 6 chars)"
}
```

**Response `200`**
```json
{ "message": "Password reset successful" }
```

### 🟢 `PATCH /auth/change-password`

**[JWT]**

**Request**
```json
{
  "currentPassword": "*String",
  "newPassword": "*String (min 6 chars)"
}
```

**Response `200`**
```json
{ "message": "Password changed successfully" }
```

### 🟢 `GET /auth/me`

**[JWT]** Returns full profile with addresses and notification settings.

**Response `200`**
```json
{
  "id": "UUID",
  "firstName": "String",
  "lastName": "String",
  "phone": "String",
  "email": "String",
  "avatar": "String?",
  "gender": "String?",
  "dateOfBirth": "String?",
  "role": "String",
  "status": "String",
  "isPhoneVerified": false,
  "isEmailVerified": false,
  "lastLoginAt": "DateTime?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime",
  "profile": {
    "profession": "String?",
    "occupation": "String?",
    "company": "String?",
    "bio": "String?",
    "preferredLanguage": "String?",
    "timezone": "String?",
    "profileCompletionPercentage": "Float?"
  },
  "addresses": [
    {
      "id": "UUID",
      "label": "String?",
      "receiverName": "String",
      "receiverPhone": "String",
      "area": "String",
      "district": "String",
      "division": "String",
      "isDefault": false,
      "createdAt": "DateTime",
      "updatedAt": "DateTime"
    }
  ],
  "notificationSetting": {
    "pushNotification": false,
    "emailNotification": false,
    "smsNotification": false,
    "orderNotification": false,
    "paymentNotification": false,
    "promotionNotification": false,
    "chatNotification": false,
    "marketingNotification": false,
    "systemNotification": false
  }
}
```

---

<a id="2-users--profile"></a>
## 2. Users & Profile

🟢 **All 14 endpoints built.**

### Own Profile

#### 🟢 `PATCH /users/me`

**[JWT]** Update own profile. Only sends changed fields.

**Request**
```json
{
  "firstName": "String",
  "lastName": "String",
  "phone": "String",
  "email": "String",
  "avatar": "String (URL)",
  "gender": "String (MALE|FEMALE|OTHER)",
  "dateOfBirth": "Date (ISO)"
}
```

**Response `200`** — same shape as `GET /auth/me` user object (without profile/addresses/nested)

#### 🟢 `DELETE /users/me`

**[JWT]** Soft-delete own account.

**Response `200`**
```json
{ "id": "UUID", "status": "INACTIVE", "deletedAt": "DateTime" }
```

### Admin: User Management

#### 🟢 `GET /users`

**[JWT] [ADMIN|SUPER_ADMIN]** List all users.

**Query**: `?page=1&limit=20&role=CUSTOMER&search=&status=`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "firstName": "String",
      "lastName": "String",
      "phone": "String",
      "email": "String",
      "avatar": "String?",
      "gender": "String?",
      "dateOfBirth": "String?",
      "role": "String",
      "status": "String",
      "isPhoneVerified": false,
      "isEmailVerified": false,
      "lastLoginAt": "DateTime?",
      "createdAt": "DateTime",
      "updatedAt": "DateTime"
    }
  ],
  "total": "Int",
  "page": "Int",
  "limit": "Int",
  "totalPages": "Int"
}
```

#### 🟢 `POST /users`

**[JWT] [ADMIN|SUPER_ADMIN]** Create a user.

**Request**
```json
{
  "firstName": "*String",
  "lastName": "*String",
  "phone": "*String",
  "email": "*String",
  "password": "String (min 6, auto-generated if omitted)",
  "gender": "*String (MALE|FEMALE|OTHER)",
  "avatar": "String (URL)",
  "dateOfBirth": "Date (ISO)"
}
```

**Response `201`** — created user (same shape as GET /users item)

#### 🟢 `GET /users/:id`

**[JWT] [self|ADMIN|SUPER_ADMIN]**

**Response `200`** — full user object (same shape as GET /users item)

#### 🟢 `PATCH /users/:id`

**[JWT] [ADMIN|SUPER_ADMIN]** Update any user.

**Request** — same shape as `PATCH /users/me`
**Response `200`** — updated user object

### Addresses

All **[JWT]** — user's own addresses only.

#### 🟢 `GET /users/me/addresses`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "label": "String? (Home|Office|Other)",
      "receiverName": "String",
      "receiverPhone": "String",
      "country": "String?",
      "division": "String",
      "district": "String",
      "upazila": "String?",
      "area": "String",
      "road": "String?",
      "house": "String?",
      "floor": "String?",
      "apartment": "String?",
      "landmark": "String?",
      "postalCode": "String?",
      "latitude": "Float?",
      "longitude": "Float?",
      "deliveryInstruction": "String?",
      "isDefault": false,
      "createdAt": "DateTime",
      "updatedAt": "DateTime"
    }
  ]
}
```

#### 🟢 `POST /users/me/addresses`

**Request**
```json
{
  "label": "String (Home|Office|Other)",
  "receiverName": "*String",
  "receiverPhone": "*String",
  "country": "String",
  "division": "*String",
  "district": "*String",
  "upazila": "String",
  "area": "*String",
  "road": "String",
  "house": "String",
  "floor": "String",
  "apartment": "String",
  "landmark": "String",
  "postalCode": "String",
  "latitude": "Float",
  "longitude": "Float",
  "deliveryInstruction": "String",
  "isDefault": false
}
```

**Response `201`** — created address (same shape as GET items)

#### 🟢 `PATCH /users/me/addresses/:id`

**Request** — partial subset of POST body
**Response `200`** — updated address object

#### 🟢 `DELETE /users/me/addresses/:id`

**Response `200`** — soft-deleted address object (`deletedAt` set)

#### 🟢 `PATCH /users/me/addresses/:id/default`

**Request** — none
**Response `200`** — updated address with `isDefault: true`

### Devices

All **[JWT]**

#### 🟢 `GET /users/me/devices`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "deviceId": "String",
      "deviceType": "String",
      "deviceName": "String?",
      "operatingSystem": "String?",
      "osVersion": "String?",
      "appVersion": "String?",
      "browser": "String?",
      "pushToken": "String",
      "ipAddress": "String?",
      "lastActiveAt": "DateTime?",
      "createdAt": "DateTime",
      "updatedAt": "DateTime"
    }
  ]
}
```

#### 🟢 `POST /users/me/devices`

**Request**
```json
{
  "deviceId": "*String",
  "deviceType": "*String (ios|android|web)",
  "pushToken": "*String",
  "deviceName": "String",
  "operatingSystem": "String",
  "osVersion": "String",
  "appVersion": "String",
  "browser": "String",
  "ipAddress": "String"
}
```

**Response `201`** — created device (same shape as GET items)

#### 🟢 `DELETE /users/me/devices/:id`

**Response `200`** — deleted device object

### Notification Settings

All **[JWT]**

#### 🟢 `GET /users/me/notification-settings`

**Response `200`**
```json
{
  "pushNotification": false,
  "emailNotification": false,
  "smsNotification": false,
  "orderNotification": false,
  "paymentNotification": false,
  "promotionNotification": false,
  "chatNotification": false,
  "marketingNotification": false,
  "systemNotification": false
}
```

#### 🟢 `PATCH /users/me/notification-settings`

**Request** — same shape as GET response (partial allowed)
**Response `200`** — updated settings

### Login History

#### 🟢 `GET /users/me/login-history`

**[JWT]** Paginated.

**Query**: `?page=1&limit=20`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "deviceId": "String?",
      "ipAddress": "String?",
      "browser": "String?",
      "platform": "String?",
      "country": "String?",
      "city": "String?",
      "loginMethod": "String (email|phone)",
      "loginStatus": "String (success|failed)",
      "loggedInAt": "DateTime?",
      "loggedOutAt": "DateTime?",
      "createdAt": "DateTime"
    }
  ],
  "total": "Int",
  "page": "Int",
  "limit": "Int",
  "totalPages": "Int"
}
```

---

<a id="3-food-catalog-customer"></a>
## 3. Food Catalog (Customer)

🟢 **All 10 endpoints built. Public unless marked `[JWT]`.**

### 🟢 `GET /foods`

Browse foods with filters and pagination. Public.

**Query**
```
?page=1&limit=20
&categoryId=UUID
&foodType=VEG|NON_VEG|VEGAN|SEAFOOD
&spiceLevel=MILD|MEDIUM|HOT|EXTRA_HOT
&dietType=String (e.g. Keto, Diabetic)
&minPrice=Float
&maxPrice=Float
&search=String (name/slug)
&sortBy=name|price|rating|popularity
&sortOrder=asc|desc
```

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "name": "String",
      "slug": "String",
      "shortDescription": "String?",
      "thumbnail": "String (URL)?",
      "coverImage": "String (URL)?",
      "foodType": "Enum (VEG|NON_VEG|VEGAN|SEAFOOD)",
      "spiceLevel": "String?",
      "preparationTime": "Int (minutes)?",
      "calories": "Float?",
      "protein": "Float?",
      "fat": "Float?",
      "carbohydrate": "Float?",
      "servingSize": "String?",
      "isFeatured": false,
      "isPopular": false,
      "isRecommended": false,
      "category": { "id": "UUID", "name": "String", "slug": "String" },
      "variants": [
        { "id": "UUID", "name": "String", "price": "Float", "discountPrice": "Float?", "servingSize": "String?" }
      ],
      "addons": [
        {
          "id": "UUID", "name": "String", "isRequired": false, "maxSelection": "Int?",
          "items": [ { "id": "UUID", "name": "String", "price": "Float", "image": "String?", "status": "String" } ]
        }
      ],
      "rating": { "averageRating": "Float", "totalReview": "Int" },
      "labels": [ { "id": "UUID", "label": "String", "color": "String?" } ],
      "tags": [ { "name": "String" } ],
      "diets": [ { "dietType": "String" } ],
      "discount": { "discountType": "PERCENTAGE|FLAT", "discountValue": "Float" } | null
    }
  ],
  "total": "Int",
  "page": "Int",
  "limit": "Int",
  "totalPages": "Int"
}
```

### 🟢 `GET /foods/:id`

Get single food by ID. Public.

**Response `200`** — same item shape as list, plus:
```json
{
  "...": "(all fields from list item)",
  "subCategory": { "id": "UUID", "name": "String", "slug": "String" } | null,
  "nutrition": {
    "calories": "Float?", "protein": "Float?", "fat": "Float?",
    "carbohydrate": "Float?", "fiber": "Float?", "sugar": "Float?",
    "sodium": "Float?", "cholesterol": "Float?", "servingSize": "String?"
  } | null,
  "ingredients": [
    { "id": "UUID", "ingredientName": "String", "quantity": "String?", "unit": "String?", "isOptional": false }
  ],
  "allergens": [
    { "id": "UUID", "allergen": "String", "description": "String?" }
  ],
  "schedules": [
    { "id": "UUID", "mealType": "BREAKFAST|LUNCH|DINNER|SNACKS", "startTime": "String", "endTime": "String", "status": "String?" }
  ],
  "gallery": [ { "id": "UUID", "image": "String", "sortOrder": 0 } ],
  "availability": { "id": "UUID", "isAvailable": true, "availableFrom": "String?", "availableTo": "String?", "availableDays": ["String"] } | null,
  "preparation": { "id": "UUID", "preparationTime": "Int?", "cookTime": "Int?", "packingTime": "Int?" } | null,
  "prices": [ { "id": "UUID", "basePrice": "Float", "salePrice": "Float?", "currency": "String?", "status": "String?" } ],
  "discounts": [ { "id": "UUID", "discountType": "String", "discountValue": "Float", "status": "String?" } ],
  "images": [ { "id": "UUID", "image": "String", "sortOrder": 0 } ],
  "tags": [ { "id": "UUID", "name": "String", "slug": "String" } ]
}
```

### 🟢 `GET /foods/slug/:slug`

Get food by slug. Public.

**Response `200`** — same shape as `GET /foods/:id`

### 🟢 `GET /foods/categories/list`

List all food categories with subcategories and food counts. Public.

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "name": "String",
      "slug": "String",
      "description": "String?",
      "icon": "String?",
      "image": "String?",
      "sortOrder": 0,
      "status": "String?",
      "_count": { "foods": "Int" },
      "subCategories": [
        { "id": "UUID", "name": "String", "slug": "String", "status": "String?" }
      ]
    }
  ]
}
```

### 🟢 `GET /foods/categories/:id`

Get category with subcategories and food count. Public.

**Response `200`** — single category object (same shape as list item)

### 🟢 `GET /foods/tags/list`

List all food tags with usage counts. Public.

**Response `200`**
```json
{
  "items": [
    { "id": "UUID", "name": "String", "slug": "String", "_count": { "tagMappings": "Int" } }
  ]
}
```

### 🟢 `POST /foods/:foodId/favorite`

**[JWT] [CUSTOMER]**

**Request** — none
**Response `200`** — favorite object
```json
{ "id": "UUID", "userId": "UUID", "foodId": "UUID", "createdAt": "DateTime" }
```

### 🟢 `DELETE /foods/:foodId/favorite`

**[JWT] [CUSTOMER]**

**Request** — none
**Response `200`** — deleted favorite object

### 🟢 `GET /foods/:foodId/reviews`

List approved reviews. Public.

**Query**: `?page=1&limit=10`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "rating": "Int (1-5)",
      "review": "String?",
      "status": "approved",
      "createdAt": "DateTime",
      "customer": { "id": "UUID", "firstName": "String", "lastName": "String", "avatar": "String?" }
    }
  ],
  "total": "Int",
  "page": "Int",
  "limit": "Int",
  "totalPages": "Int"
}
```

### 🟢 `POST /foods/:foodId/reviews`

**[JWT] [CUSTOMER]**

**Request**
```json
{
  "rating": "*Int (1-5)",
  "review": "String"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "customerId": "UUID",
  "rating": "Int",
  "review": "String?",
  "status": "approved",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

---

<a id="4-food-admin-crud"></a>
## 4. Food Admin (CRUD)

🟢 **All 34 endpoints built. Mounted at `/api/admin` prefix.**
**[JWT] [ADMIN|SUPER_ADMIN]** unless noted.

### Food CRUD

#### 🟢 `POST /admin/foods`

**Request**
```json
{
  "categoryId": "*UUID",
  "subCategoryId": "UUID",
  "name": "*String",
  "slug": "*String (unique)",
  "shortDescription": "String",
  "description": "String",
  "thumbnail": "String (URL)",
  "coverImage": "String (URL)",
  "preparationTime": "Int (minutes)",
  "calories": "Float",
  "protein": "Float",
  "fat": "Float",
  "carbohydrate": "Float",
  "servingSize": "String",
  "foodType": "*Enum (VEG|NON_VEG|VEGAN|SEAFOOD)",
  "spiceLevel": "String",
  "isFeatured": false,
  "isPopular": false,
  "isRecommended": false,
  "status": "String (draft|active|archived)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodCode": "String",
  "categoryId": "UUID",
  "subCategoryId": "UUID?",
  "name": "String",
  "slug": "String",
  "shortDescription": "String?",
  "description": "String?",
  "thumbnail": "String?",
  "coverImage": "String?",
  "preparationTime": "Int?",
  "calories": "Float?",
  "protein": "Float?",
  "fat": "Float?",
  "carbohydrate": "Float?",
  "servingSize": "String?",
  "foodType": "String",
  "spiceLevel": "String?",
  "isFeatured": false,
  "isPopular": false,
  "isRecommended": false,
  "status": "draft",
  "createdAt": "DateTime",
  "updatedAt": "DateTime",
  "category": { "id": "UUID", "name": "String", "slug": "String" },
  "nutrition": { "foodId": "UUID", "calories": null, "protein": null, "fat": null, "carbohydrate": null, "fiber": null, "sugar": null, "sodium": null, "cholesterol": null, "servingSize": null },
  "rating": { "foodId": "UUID", "averageRating": 0, "totalReview": 0, "fiveStar": 0, "fourStar": 0, "threeStar": 0, "twoStar": 0, "oneStar": 0 },
  "visibility": { "foodId": "UUID", "isVisible": false, "isFeatured": false, "isRecommended": false, "displayOrder": 0 }
}
```

#### 🟢 `PUT /admin/foods/:id`

**Request** — same shape as POST (all fields optional for update)
**Response `200`** — updated food object (flat, no includes)

#### 🟢 `DELETE /admin/foods/:id`

Soft-delete (sets `deletedAt` + `status: archived`).

**Response `200`** — updated food object

### Category CRUD

#### 🟢 `POST /admin/categories`

**Request**
```json
{
  "name": "*String",
  "slug": "*String (unique)",
  "description": "String",
  "icon": "String",
  "image": "String (URL)",
  "sortOrder": "Int",
  "status": "String (active|inactive)"
}
```

**Response `201`** — created category with all fields

#### 🟢 `PUT /admin/categories/:id`

**Request** — partial subset of POST body
**Response `200`** — updated category

#### 🟢 `DELETE /admin/categories/:id`

Soft-delete (sets `deletedAt` + `status: inactive`).

**Response `200`** — updated category

### SubCategory CRUD

#### 🟢 `POST /admin/categories/:categoryId/subcategories`

**Request**
```json
{
  "name": "*String",
  "slug": "*String (unique)",
  "description": "String",
  "icon": "String",
  "image": "String (URL)",
  "sortOrder": "Int",
  "status": "String (active|inactive)"
}
```

**Response `201`** — created subcategory

#### 🟢 `PUT /admin/subcategories/:id`

**Request** — partial subset of POST body
**Response `200`** — updated subcategory

#### 🟢 `DELETE /admin/subcategories/:id`

Soft-delete (sets `deletedAt` + `status: inactive`).

**Response `200`** — updated subcategory

### Variant CRUD

#### 🟢 `POST /admin/foods/:foodId/variants`

**Request**
```json
{
  "name": "*String",
  "description": "String",
  "price": "*Float",
  "discountPrice": "Float",
  "weight": "String",
  "servingSize": "String",
  "status": "String (active|deleted)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "name": "String",
  "description": "String?",
  "price": "Float",
  "discountPrice": "Float?",
  "weight": "String?",
  "servingSize": "String?",
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `PUT /admin/variants/:id`

**Request** — partial subset of POST body
**Response `200`** — updated variant

#### 🟢 `DELETE /admin/variants/:id`

Soft-delete (sets `status: deleted`).

**Response `200`** — updated variant

### Addon CRUD

#### 🟢 `POST /admin/foods/:foodId/addons`

**Request**
```json
{
  "name": "*String",
  "isRequired": false,
  "maxSelection": "Int (null = unlimited)",
  "status": "String (active|deleted)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "name": "String",
  "isRequired": false,
  "maxSelection": "Int?",
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `PUT /admin/addons/:id`

**Request** — partial subset of POST body
**Response `200`** — updated addon

#### 🟢 `DELETE /admin/addons/:id`

Soft-delete (also marks all items as `status: deleted`).

**Response `200`** — updated addon

### Addon Item CRUD

#### 🟢 `POST /admin/addons/:addonId/items`

**Request**
```json
{
  "name": "*String",
  "price": "*Float",
  "image": "String (URL)",
  "status": "String (active|deleted)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "addonId": "UUID",
  "name": "String",
  "price": "Float",
  "image": "String?",
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `PUT /admin/addon-items/:id`

**Request** — partial subset of POST body
**Response `200`** — updated addon item

#### 🟢 `DELETE /admin/addon-items/:id`

Soft-delete (sets `status: deleted`).

**Response `200`** — updated addon item

### Nutrition

#### 🟢 `GET /admin/foods/:foodId/nutrition`

**Response `200`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "calories": "Float?",
  "protein": "Float?",
  "fat": "Float?",
  "carbohydrate": "Float?",
  "fiber": "Float?",
  "sugar": "Float?",
  "sodium": "Float?",
  "cholesterol": "Float?",
  "servingSize": "String?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `PATCH /admin/foods/:foodId/nutrition`

Upserts nutrition record for the food.

**Request**
```json
{
  "calories": "Float",
  "protein": "Float",
  "fat": "Float",
  "carbohydrate": "Float",
  "fiber": "Float",
  "sugar": "Float",
  "sodium": "Float",
  "cholesterol": "Float",
  "servingSize": "String"
}
```

**Response `200`** — nutrition object (same shape as GET)

### Ingredients

#### 🟢 `POST /admin/foods/:foodId/ingredients`

**Request**
```json
{
  "ingredientName": "*String",
  "quantity": "String",
  "unit": "String",
  "isOptional": false
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "ingredientName": "String",
  "quantity": "String?",
  "unit": "String?",
  "isOptional": false,
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `DELETE /admin/ingredients/:id`

Hard-deletes ingredient.

**Response `200`** — deleted ingredient object

### Allergens

#### 🟢 `POST /admin/foods/:foodId/allergens`

**Request**
```json
{
  "allergen": "*String",
  "description": "String"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "allergen": "String",
  "description": "String?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `DELETE /admin/allergens/:id`

Hard-deletes allergen.

**Response `200`** — deleted allergen object

### Prices

#### 🟢 `POST /admin/foods/:foodId/prices`

**Request**
```json
{
  "basePrice": "*Float",
  "salePrice": "Float",
  "currency": "String (default BDT)",
  "effectiveFrom": "Date (ISO)",
  "effectiveTo": "Date (ISO)",
  "status": "String (active|inactive)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "basePrice": "Float",
  "salePrice": "Float?",
  "currency": "BDT",
  "effectiveFrom": "DateTime?",
  "effectiveTo": "DateTime?",
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### Discounts

#### 🟢 `POST /admin/foods/:foodId/discounts`

**Request**
```json
{
  "discountType": "*Enum (PERCENTAGE|FLAT)",
  "discountValue": "*Float",
  "startDate": "Date (ISO)",
  "endDate": "Date (ISO)",
  "status": "String (active|inactive)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "discountType": "PERCENTAGE|FLAT",
  "discountValue": "Float",
  "startDate": "DateTime?",
  "endDate": "DateTime?",
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `DELETE /admin/discounts/:id`

Soft-delete (sets `status: inactive`).

**Response `200`** — updated discount object

### Tags

#### 🟢 `POST /admin/foods/:foodId/tags`

**Request**
```json
{ "tagIds": "*[UUID] (at least 1)" }
```

**Response `200`**
```json
{ "count": "Int (newly added)" }
```

#### 🟢 `DELETE /admin/foods/:foodId/tags/:tagId`

**Response `200`** — deleted tag mapping

#### 🟢 `POST /admin/tags`

Create a new food tag.

**Request**
```json
{
  "name": "*String",
  "slug": "*String (unique)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "name": "String",
  "slug": "String",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### Labels

#### 🟢 `POST /admin/foods/:foodId/labels`

**Request**
```json
{
  "label": "*String",
  "color": "String (hex code)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "label": "String",
  "color": "String?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `DELETE /admin/labels/:id`

Hard-deletes label.

**Response `200`** — deleted label object

### Availability

#### 🟢 `PATCH /admin/foods/:foodId/availability`

Upserts availability record.

**Request**
```json
{
  "isAvailable": true,
  "availableFrom": "String (HH:mm)",
  "availableTo": "String (HH:mm)",
  "availableDays": ["String (Monday|Tuesday|...)"]
}
```

**Response `200`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "isAvailable": true,
  "availableFrom": "String?",
  "availableTo": "String?",
  "availableDays": ["String"],
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### Schedules

#### 🟢 `POST /admin/foods/:foodId/schedules`

**Request**
```json
{
  "mealType": "*Enum (BREAKFAST|LUNCH|DINNER|SNACKS)",
  "startTime": "*String (HH:mm)",
  "endTime": "*String (HH:mm)",
  "status": "String (active|deleted)"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "mealType": "String",
  "startTime": "String",
  "endTime": "String",
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

#### 🟢 `DELETE /admin/schedules/:id`

Soft-delete (sets `status: deleted`).

**Response `200`** — updated schedule

### Visibility

#### 🟢 `PATCH /admin/foods/:foodId/visibility`

Upserts visibility record.

**Request**
```json
{
  "isVisible": true,
  "isFeatured": true,
  "isRecommended": true,
  "displayOrder": "Int"
}
```

**Response `200`**
```json
{
  "id": "UUID",
  "foodId": "UUID",
  "isVisible": false,
  "isFeatured": false,
  "isRecommended": false,
  "displayOrder": 0,
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

---

<a id="5-cart--checkout"></a>
## 5. Cart & Checkout

🟢 **All 20 endpoints built. Mounted at `/api/cart`.**
All require **[JWT] [CUSTOMER]**.

All cart mutation endpoints return the full cart object (see GET /cart response).

### Cart Object (returned by all cart endpoints)

```json
{
  "id": "UUID",
  "customerId": "UUID",
  "packageId": "UUID?",
  "customMealPlanId": "UUID?",
  "couponId": "UUID?",
  "subtotal": 0.00,
  "discount": 0.00,
  "deliveryCharge": 50.00,
  "vat": 0.00,
  "totalAmount": 0.00,
  "status": "active",
  "createdAt": "DateTime",
  "updatedAt": "DateTime",
  "items": [
    {
      "id": "UUID",
      "cartId": "UUID",
      "foodId": "UUID",
      "packageMealId": "UUID?",
      "quantity": 1,
      "unitPrice": 0.00,
      "totalPrice": 0.00,
      "createdAt": "DateTime",
      "updatedAt": "DateTime",
      "food": { "id": "UUID", "name": "String", "thumbnail": "String?" },
      "addons": [
        { "id": "UUID", "cartItemId": "UUID", "addonItemId": "UUID", "quantity": 1, "price": 0.00, "createdAt": "DateTime" }
      ]
    }
  ],
  "meals": [
    {
      "id": "UUID",
      "cartId": "UUID",
      "dayNumber": 1,
      "mealType": "String",
      "mealTime": "String?",
      "createdAt": "DateTime",
      "updatedAt": "DateTime",
      "foods": [
        { "id": "UUID", "cartMealId": "UUID", "foodId": "UUID", "quantity": 1, "isReplacement": false, "food": { "id": "UUID", "name": "String" } }
      ]
    }
  ],
  "summary": {
    "id": "UUID",
    "cartId": "UUID",
    "itemCount": 0,
    "mealCount": 0,
    "subtotal": 0.00,
    "discount": 0.00,
    "deliveryCharge": 50.00,
    "vat": 0.00,
    "grandTotal": 0.00,
    "createdAt": "DateTime",
    "updatedAt": "DateTime"
  }
}
```

### 🟢 `GET /cart`

Get current user's active cart. Auto-creates empty cart if none exists.

**Request** — none
**Response `200`** — full cart object

### 🟢 `POST /cart`

Initialize cart with a package or custom meal plan.

**Request**
```json
{
  "packageId": "UUID (if no customMealPlanId)",
  "customMealPlanId": "UUID (if no packageId)"
}
```

**Response `200`** — full cart object (with package meals pre-populated)

### 🟢 `DELETE /cart`

Clear all items, meals, addons, coupons from cart.

**Request** — none
**Response `200`** — full cart object (empty)

### 🟢 `POST /cart/items`

Add food item to cart. If same food+packageMeal exists, increments quantity.

**Request**
```json
{
  "foodId": "*UUID",
  "packageMealId": "UUID",
  "quantity": "Int (default 1)",
  "unitPrice": "*Float"
}
```

**Response `200`** — full cart object

### 🟢 `PATCH /cart/items/:id`

Update item quantity.

**Request**
```json
{ "quantity": "*Int (min 1)" }
```

**Response `200`** — full cart object

### 🟢 `DELETE /cart/items/:id`

Remove item + its addons.

**Response `200`** — full cart object

### 🟢 `POST /cart/items/:itemId/addons`

Add addon to a cart item.

**Request**
```json
{
  "addonItemId": "*UUID",
  "quantity": "Int (default 1)",
  "price": "*Float"
}
```

**Response `200`** — full cart object

### 🟢 `DELETE /cart/addons/:id`

Remove addon from item.

**Response `200`** — full cart object

### 🟢 `POST /cart/meals`

Add a meal slot (package flow).

**Request**
```json
{
  "dayNumber": "*Int",
  "mealType": "*String",
  "mealTime": "String"
}
```

**Response `200`** — full cart object

### 🟢 `DELETE /cart/meals/:id`

Remove meal + its foods.

**Response `200`** — full cart object

### 🟢 `POST /cart/meals/:mealId/foods`

Select food for a meal.

**Request**
```json
{
  "foodId": "*UUID",
  "quantity": "Int (default 1)",
  "isReplacement": false
}
```

**Response `200`** — full cart object

### 🟢 `DELETE /cart/meals/:mealId/foods/:foodId`

Remove food from meal.

**Response `200`** — full cart object

### --- Checkout ---

### 🟢 `POST /cart/checkout`

Get checkout summary for current cart.

**Request** — none

**Response `200`**
```json
{
  "subtotal": 0.00,
  "discount": 0.00,
  "deliveryCharge": 50.00,
  "vat": 0.00,
  "grandTotal": 0.00,
  "itemCount": 0,
  "mealCount": 0,
  "appliedCoupon": { "code": "String", "discountAmount": 0.00 } | null,
  "deliveryAddress": {
    "id": "UUID",
    "label": "String?",
    "area": "String",
    "district": "String",
    "division": "String",
    "road": "String?",
    "house": "String?",
    "isDefault": false
  } | null,
  "availablePaymentMethods": [
    { "id": "UUID", "name": "String", "logo": "String?", "isDefault": false }
  ]
}
```

### 🟢 `POST /cart/checkout/apply-coupon`

**Request**
```json
{ "couponCode": "*String" }
```

**Response `200`**
```json
{ "valid": true, "discountAmount": 0.00, "newTotal": 0.00 }
```

### 🟢 `DELETE /cart/checkout/remove-coupon`

**Request** — none
**Response `200`**
```json
{ "message": "Coupon removed" }
```

### 🟢 `POST /cart/checkout/select-address`

**Request**
```json
{ "addressId": "*UUID" }
```

**Response `200`**
```json
{ "message": "Address selected", "addressId": "UUID" }
```

### 🟢 `POST /cart/checkout/place-order`

Converts cart to order. Cart becomes `converted`.

**Request**
```json
{
  "cartId": "*UUID",
  "addressId": "*UUID",
  "paymentMethodId": "*UUID",
  "notes": "String",
  "deliverySchedule": {
    "deliveryDate": "*Date (ISO)",
    "deliverySlot": "String"
  }
}
```

**Response `201`**
```json
{
  "orderId": "UUID",
  "orderNumber": "String (FND-YYYYMMDD-XXXXX)",
  "totalAmount": 0.00,
  "paymentUrl": "String"
}
```

---

<a id="6-orders"></a>
## 6. Orders

🟢 **All 16 endpoints built. Mounted at `/api` prefix.**

### 🟢 `GET /orders`

**[JWT] [CUSTOMER]** List current customer's orders. Paginated.

**Query**: `?page=1&limit=10&status=CONFIRMED|PREPARING|DELIVERED|CANCELLED`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "orderNumber": "String",
      "orderStatus": "String",
      "totalAmount": 0.00,
      "paymentStatus": "String",
      "deliveryStatus": "String",
      "placedAt": "DateTime",
      "items": [
        { "id": "UUID", "foodId": "UUID", "quantity": 1, "unitPrice": 0.00, "totalPrice": 0.00 }
      ],
      "payment": { "id": "UUID", "paymentNumber": "String", "status": "String", "amount": 0.00 }
    }
  ],
  "total": "Int",
  "page": "Int",
  "limit": "Int",
  "totalPages": "Int"
}
```

### 🟢 `GET /orders/:id`

**[JWT] [CUSTOMER|ADMIN|VENDOR]** Full order detail with all nested relations.

**Response `200`**
```json
{
  "id": "UUID",
  "orderNumber": "String",
  "customerId": "UUID",
  "vendorId": "UUID?",
  "packageId": "UUID?",
  "customMealPlanId": "UUID?",
  "addressId": "UUID",
  "couponId": "UUID?",
  "subtotal": 0.00,
  "discount": 0.00,
  "deliveryCharge": 50.00,
  "vat": 0.00,
  "totalAmount": 0.00,
  "paymentStatus": "PENDING",
  "orderStatus": "PENDING",
  "deliveryStatus": "PENDING",
  "notes": "String?",
  "placedAt": "DateTime",
  "confirmedAt": "DateTime?",
  "completedAt": "DateTime?",
  "cancelledAt": "DateTime?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime",

  "customer": { "id": "UUID", "fullName": "String", "email": "String", "phone": "String" },
  "vendor": { "id": "UUID", "businessName": "String", "phone": "String", "email": "String" } | null,

  "items": [
    {
      "id": "UUID", "orderId": "UUID", "foodId": "UUID",
      "quantity": 1, "unitPrice": 0.00, "totalPrice": 0.00,
      "food": { "id": "UUID", "name": "String", "slug": "String", "thumbnail": "String?", "foodType": "String", "preparationTime": "Int?", "calories": "Float?", "protein": "Float?", "fat": "Float?", "carbohydrate": "Float?", "servingSize": "String?", "status": "String" }
    }
  ],

  "meals": [
    {
      "id": "UUID", "orderId": "UUID", "dayNumber": 1, "mealType": "String", "mealTime": "String?", "deliveryDate": "DateTime?", "status": "String?",
      "foods": [
        { "id": "UUID", "orderMealId": "UUID", "foodId": "UUID", "quantity": 1 }
      ]
    }
  ],

  "schedules": [
    { "id": "UUID", "orderId": "UUID", "deliveryDate": "DateTime", "deliverySlot": "String?" }
  ],

  "statusHistories": [
    { "id": "UUID", "orderId": "UUID", "previousStatus": "String?", "currentStatus": "String", "changedBy": "String", "remarks": "String?", "createdAt": "DateTime" }
  ],

  "timeline": [
    { "id": "UUID", "orderId": "UUID", "title": "String", "description": "String?", "status": "String", "createdAt": "DateTime" }
  ],

  "cancellation": {
    "id": "UUID", "orderId": "UUID", "cancelledBy": "String", "reason": "String", "createdAt": "DateTime"
  } | null,

  "refunds": [
    { "id": "UUID", "orderId": "UUID", "paymentId": "UUID", "refundAmount": 0.00, "refundMethod": "String?", "refundStatus": "String", "processedBy": "UUID", "processedAt": "DateTime", "createdAt": "DateTime" }
  ],

  "feedback": {
    "id": "UUID", "orderId": "UUID", "customerId": "UUID", "rating": 5, "review": "String?", "createdAt": "DateTime", "updatedAt": "DateTime"
  } | null,

  "invoice": {
    "id": "UUID", "orderId": "UUID", "invoiceNumber": "String", "subtotal": 0.00, "discount": 0.00, "vat": 0.00, "deliveryCharge": 0.00, "grandTotal": 0.00, "createdAt": "DateTime", "updatedAt": "DateTime"
  } | null,

  "delivery": {
    "id": "UUID", "orderId": "UUID", "deliveryCode": "String", "deliveryStatus": "String",
    "rider": { "id": "UUID", "fullName": "String", "phone": "String" } | null
  } | null,

  "payment": {
    "id": "UUID", "paymentNumber": "String", "orderId": "UUID", "customerId": "UUID", "paymentMethodId": "UUID", "amount": 0.00, "status": "String", "createdAt": "DateTime", "updatedAt": "DateTime"
  } | null
}
```

### 🟢 `PATCH /orders/:id`

**[JWT] [CUSTOMER|ADMIN]** Update notes or delivery schedule. Only allowed when order is PENDING or CONFIRMED.

**Request**
```json
{
  "notes": "String",
  "deliverySchedule": {
    "deliveryDate": "*Date (ISO)",
    "deliverySlot": "String"
  }
}
```

**Response `200`** — updated order (flat, no includes)

### 🟢 `DELETE /orders/:id`

**[JWT] [SUPER_ADMIN]** Soft-delete.

**Response `200`** — updated order with `deletedAt` set

### 🟢 `POST /orders/:id/cancel`

**[JWT] [CUSTOMER|ADMIN]** Cancel order. Valid from PENDING, CONFIRMED, PAYMENT_PENDING. Marks payment as REFUNDED.

**Request**
```json
{
  "reason": "*String",
  "cancelledBy": "*String (customer|admin)"
}
```

**Response `200`**
```json
{ "orderId": "UUID", "status": "CANCELLED" }
```

### 🟢 `PATCH /orders/:id/status`

**[JWT] [ADMIN|VENDOR]** Transition order status. Valid flow:

```
PENDING → CONFIRMED → PREPARING → READY_FOR_PICKUP → PICKED_UP → ON_THE_WAY → DELIVERED → COMPLETED
```

Any active status → CANCELLED (where allowed). Creates status history + timeline entry.

**Request**
```json
{
  "status": "*String (CONFIRMED|PREPARING|READY_FOR_PICKUP|PICKED_UP|ON_THE_WAY|DELIVERED|CANCELLED)",
  "remarks": "String"
}
```

**Response `200`** — no data (status history + timeline created)

### 🟢 `PATCH /orders/:id/assign-vendor`

**[JWT] [ADMIN]**

**Request**
```json
{ "vendorId": "*UUID" }
```

**Response `200`** — updated order (flat)

### 🟢 `PATCH /orders/:id/assign-rider`

**[JWT] [ADMIN|VENDOR]** Creates/updates Delivery record + sets order `deliveryStatus: ASSIGNED`.

**Request**
```json
{ "riderId": "*UUID" }
```

**Response `200`** — no data (side effects only)

### 🟢 `GET /admin/orders`

**[JWT] [ADMIN|SUPER_ADMIN]** List all orders with advanced filters. Paginated.

**Query**: `?page=1&limit=20&status=&paymentStatus=&vendorId=&customerId=&dateFrom=&dateTo=`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID", "orderNumber": "String", "orderStatus": "String", "totalAmount": 0.00, "paymentStatus": "String", "placedAt": "DateTime",
      "customer": { "id": "UUID", "fullName": "String", "phone": "String" },
      "items": [ { "id": "UUID", "foodId": "UUID", "quantity": 1, "totalPrice": 0.00, "food": { "id": "UUID", "name": "String", "thumbnail": "String?" } } ],
      "payment": { "id": "UUID", "paymentNumber": "String", "status": "String", "amount": 0.00 }
    }
  ],
  "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int"
}
```

### 🟢 `GET /vendors/:vendorId/orders`

**[JWT] [VENDOR]** List orders assigned to vendor. Paginated.

**Query**: `?page=1&limit=20&status=`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID", "orderNumber": "String", "orderStatus": "String", "totalAmount": 0.00, "placedAt": "DateTime",
      "customer": { "id": "UUID", "fullName": "String" },
      "items": [ { "id": "UUID", "foodId": "UUID", "quantity": 1, "food": { "id": "UUID", "name": "String" } } ]
    }
  ],
  "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int"
}
```

### 🟢 `POST /orders/:orderId/refund`

**[JWT] [ADMIN]** Process refund for cancelled order. Creates OrderRefund → updates Payment status → sets order REFUNDED.

**Request**
```json
{
  "amount": "*Float",
  "refundMethod": "String",
  "reason": "*String"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "orderId": "UUID",
  "paymentId": "UUID",
  "refundAmount": 0.00,
  "refundMethod": "String?",
  "refundStatus": "completed",
  "processedBy": "UUID",
  "processedAt": "DateTime"
}
```

### 🟢 `GET /orders/:orderId/refunds`

**[JWT] [ADMIN]** List all refunds for order.

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID", "orderId": "UUID", "paymentId": "UUID",
      "refundAmount": 0.00, "refundMethod": "String?", "refundStatus": "String",
      "processedBy": "UUID", "processedAt": "DateTime", "createdAt": "DateTime"
    }
  ]
}
```

### 🟢 `POST /orders/:orderId/feedback`

**[JWT] [CUSTOMER]** Submit or update feedback. Only for DELIVERED / COMPLETED orders. Upserts — calling again updates rating/review.

**Request**
```json
{
  "rating": "*Int (1-5)",
  "review": "String"
}
```

**Response `201`**
```json
{
  "id": "UUID",
  "orderId": "UUID",
  "customerId": "UUID",
  "rating": 5,
  "review": "String?",
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### 🟢 `GET /orders/:orderId/invoice`

**[JWT] [CUSTOMER|ADMIN]** Get or auto-generate invoice.

**Response `200`**
```json
{
  "id": "UUID",
  "orderId": "UUID",
  "invoiceNumber": "String (INV-FND-YYYYMMDD-XXXXX)",
  "subtotal": 0.00,
  "discount": 0.00,
  "vat": 0.00,
  "deliveryCharge": 50.00,
  "grandTotal": 0.00,
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### 🟢 `PATCH /order-meals/:id/status`

**[JWT] [ADMIN|VENDOR]** Update individual meal status.

**Request**
```json
{ "status": "*String" }
```

**Response `200`** — updated order meal
```json
{
  "id": "UUID",
  "orderId": "UUID",
  "dayNumber": 1,
  "mealType": "String",
  "mealTime": "String?",
  "deliveryDate": "DateTime?",
  "status": "updated-status"
}
```

---

<a id="7-customers-admin"></a>
## 7. Customers (Admin)

🟢 **All 6 endpoints built. Mounted at `/api/admin/customers`.**
**[JWT] [ADMIN|SUPER_ADMIN]**

### 🟢 `GET /api/admin/customers`

List all customers with aggregates. Paginated.

**Query:** `?page=1&limit=20&search=String (firstName|lastName|email|phone)&status=ACTIVE|INACTIVE|SUSPENDED|BANNED`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID",
      "fullName": "String",
      "phone": "String",
      "email": "String",
      "status": "String",
      "totalOrders": "Int",
      "totalSpent": "Float",
      "subscriptionCount": "Int",
      "walletBalance": "Float",
      "lastOrderDate": "DateTime?",
      "joinedAt": "DateTime"
    }
  ],
  "total": "Int",
  "page": "Int",
  "limit": "Int",
  "totalPages": "Int"
}
```

### 🟢 `GET /api/admin/customers/:id`

Get full customer detail — profile, addresses, wallet, last order, aggregates.

**Response `200`**
```json
{
  "id": "UUID",
  "fullName": "String",
  "phone": "String",
  "email": "String",
  "avatar": "String?",
  "gender": "String?",
  "dateOfBirth": "DateTime?",
  "status": "String",
  "isPhoneVerified": false,
  "isEmailVerified": false,
  "lastLoginAt": "DateTime?",
  "joinedAt": "DateTime",
  "profile": {
    "profession": "String?", "occupation": "String?", "company": "String?",
    "bio": "String?", "preferredLanguage": "String?", "timezone": "String?",
    "profileCompletionPercentage": "Float?"
  } | null,
  "addresses": [
    {
      "id": "UUID", "label": "String?", "receiverName": "String", "receiverPhone": "String",
      "area": "String", "district": "String", "division": "String",
      "road": "String?", "house": "String?", "isDefault": false,
      "createdAt": "DateTime", "updatedAt": "DateTime"
    }
  ],
  "wallet": {
    "id": "UUID", "customerId": "UUID", "walletNumber": "String",
    "balance": "Float", "holdBalance": "Float", "currency": "String", "status": "String",
    "transactions": [
      {
        "id": "UUID", "walletId": "UUID",
        "transactionType": "CREDIT|DEBIT", "amount": "Float",
        "balanceBefore": "Float", "balanceAfter": "Float",
        "referenceType": "String?", "referenceId": "String?",
        "remarks": "String?", "createdAt": "DateTime"
      }
    ]
  } | null,
  "totalOrders": "Int",
  "totalSubscriptions": "Int",
  "totalPayments": "Int",
  "totalSpent": "Float",
  "lastOrder": {
    "placedAt": "DateTime", "orderStatus": "String", "totalAmount": "Float"
  } | null
}
```

### 🟢 `GET /api/admin/customers/:id/orders`

Paginated list of customer's orders.

**Query:** `?page=1&limit=20&status=`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID", "orderNumber": "String", "orderStatus": "String", "totalAmount": 0.00, "placedAt": "DateTime",
      "items": [
        { "id": "UUID", "foodId": "UUID", "quantity": 1, "food": { "id": "UUID", "name": "String", "image": "String?" } }
      ],
      "payment": { "status": "String", "amount": "Float" }
    }
  ],
  "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int"
}
```

### 🟢 `GET /api/admin/customers/:id/subscriptions`

Paginated list of customer's subscriptions.

**Query:** `?page=1&limit=20`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID", "subscriptionNumber": "String", "status": "String",
      "startDate": "DateTime", "endDate": "DateTime?",
      "totalAmount": "Float", "paidAmount": "Float",
      "autoRenew": false, "createdAt": "DateTime", "updatedAt": "DateTime"
    }
  ],
  "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int"
}
```

### 🟢 `GET /api/admin/customers/:id/wallet`

Get customer's wallet with paginated transactions.

**Query:** `?page=1&limit=20`

**Response `200`**
```json
{
  "wallet": {
    "id": "UUID", "customerId": "UUID", "walletNumber": "String",
    "balance": "Float", "holdBalance": "Float",
    "currency": "String", "status": "String",
    "createdAt": "DateTime", "updatedAt": "DateTime"
  } | null,
  "transactions": {
    "items": [
      {
        "id": "UUID", "walletId": "UUID",
        "transactionType": "CREDIT|DEBIT", "amount": "Float",
        "balanceBefore": "Float", "balanceAfter": "Float",
        "referenceType": "String?", "referenceId": "String?",
        "remarks": "String?", "createdAt": "DateTime"
      }
    ],
    "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int"
  }
}
```

### 🟢 `GET /api/admin/customers/:id/payments`

Paginated list of customer's payments.

**Query:** `?page=1&limit=20`

**Response `200`**
```json
{
  "items": [
    {
      "id": "UUID", "paymentNumber": "String", "amount": "Float",
      "status": "String", "createdAt": "DateTime",
      "order": { "orderNumber": "String" }
    }
  ],
  "total": "Int", "page": "Int", "limit": "Int", "totalPages": "Int"
}

---

<a id="8-vendors"></a>
## 8. Vendors

🟢 **Built** — see [source](../../server/routes/vendorRoutes.ts), [controller](../../server/controllers/vendorController.ts)

All endpoints are mounted at `/api`. Routes marked ⚠️ have **no auth middleware** yet (see [source](../../server/routes/vendorRoutes.ts)).

---

### Core Vendor Lifecycle ⚠️

**Auth:** None currently — routes lack `verifyToken` + `authorize()` middleware

### `POST /api/vendor/add`
Create vendor + user in a single transaction. Auto-generates `vendorCode` and creates wallet + settings.

**Request**
```json
{
  "firstName": "*String",
  "lastName": "*String",
  "email": "*String",
  "phone": "*String",
  "password": "*String",
  "businessName": "*String",
  "ownerName": "*String",
  "tradeLicenseNumber": "*String",
  "tinNumber": "String",
  "binNumber": "String"
}
```

**Response `201`**
```json
{
  "user": { "id": "UUID", "email": "String", "role": "VENDOR" },
  "vendor": { "id": "UUID", "vendorCode": "String", "businessName": "String", "ownerName": "String", "email": "String", "phone": "String", "tradeLicenseNumber": "String", "tinNumber": "String", "binNumber": "String", "status": "PENDING", "verificationStatus": "UNVERIFIED", "isActive": true, "isOnline": false, "createdAt": "DateTime" }
}
```

### `GET /api/vendor/all`
List vendors. Returns each vendor with `profile` and `_count.branches`.

**Query:** `?status=ACTIVE&verificationStatus=VERIFIED&isActive=true`

**Response `200`**
```json
{
  "success": true,
  "message": "Vendors extracted successfully",
  "data": [
    {
      "id": "UUID",
      "vendorCode": "String",
      "businessName": "String",
      "ownerName": "String",
      "phone": "String",
      "email": "String",
      "status": "VendorStatus",
      "verificationStatus": "VerificationStatus",
      "isActive": "Boolean",
      "isOnline": "Boolean",
      "profile": { "about": "String", "logo": "String", "website": "String" },
      "_count": { "branches": "Int" }
    }
  ]
}
```

### `GET /api/vendor/:vendorCode`
Get vendor by `vendorCode`. Includes `profile`, `settings`, `wallet`, `branches` (each with `kitchens`).

**Response `200`**
```json
{
  "id": "UUID",
  "vendorCode": "String",
  "businessName": "String",
  "ownerName": "String",
  "phone": "String",
  "email": "String",
  "tradeLicenseNumber": "String",
  "tinNumber": "String",
  "binNumber": "String",
  "logo": "String",
  "coverImage": "String",
  "description": "Text",
  "status": "VendorStatus",
  "verificationStatus": "VerificationStatus",
  "isActive": "Boolean",
  "isOnline": "Boolean",
  "commissionType": "String",
  "commissionValue": "Float",
  "openingTime": "String",
  "closingTime": "String",
  "profile": { "about": "String", "mission": "String", "story": "String", "foundedYear": "Int" },
  "settings": { "autoAcceptOrder": "Boolean", "autoAssignRider": "Boolean", "allowCustomMeal": "Boolean", "notificationEnabled": "Boolean" },
  "wallet": { "balance": "Decimal", "holdBalance": "Decimal", "currency": "String", "status": "String" },
  "branches": [
    {
      "id": "UUID",
      "branchCode": "String",
      "branchName": "String",
      "phone": "String",
      "email": "String",
      "division": "String",
      "district": "String",
      "area": "String",
      "road": "String",
      "house": "String",
      "latitude": "Float",
      "longitude": "Float",
      "isMainBranch": "Boolean",
      "kitchens": [
        { "id": "UUID", "kitchenCode": "String", "kitchenName": "String", "capacity": "Int", "preparationTime": "Int", "status": "String" }
      ]
    }
  ],
  "createdAt": "DateTime",
  "updatedAt": "DateTime"
}
```

### `PATCH /api/vendor/:vendorCode`
Update vendor fields. Protected fields (`id`, `vendorCode`, `email`, `phone`, `tradeLicenseNumber`, `tinNumber`, `binNumber`, `createdAt`, `updatedAt`) are stripped from the request body.

**Request**
```json
{ "businessName": "String", "ownerName": "String", "logo": "String", "coverImage": "String", "description": "Text", "status": "VendorStatus", "isActive": "Boolean", "isOnline": "Boolean" }
```

### `DELETE /api/vendor/:vendorCode`
Soft-delete — sets `deletedAt` and `isActive = false`.

---

### Profile

### `PUT /api/vendor/:vendorCode/profile`
Upsert vendor profile. Creates if not exists, updates if exists.

**Request**
```json
{ "about": "Text", "mission": "Text", "story": "Text", "foundedYear": "Int", "website": "String", "facebook": "String", "instagram": "String", "youtube": "String" }
```

---

### Branches

### `POST /api/vendor/:vendorCode/branches`
Add a branch. Auto-generates `branchCode`.

**Request**
```json
{ "branchName": "*String", "phone": "String", "email": "String", "division": "String", "district": "String", "area": "String", "road": "String", "house": "String", "latitude": "Float", "longitude": "Float", "isMainBranch": "Boolean" }
```

### `GET /api/vendor/:vendorCode/branches`
List all branches for a vendor. Each branch includes its `kitchens`.

---

### Kitchens

### `POST /api/vendor/branches/:branchId/kitchens`
Add a kitchen to a branch. Auto-generates `kitchenCode`. Resolves vendor mapping from the branch.

**Request**
```json
{ "kitchenName": "*String", "capacity": "Int", "preparationTime": "Int" }
```

---

### Documents

### `POST /api/vendor/:vendorCode/documents`
Upload a compliance document.

**Request**
```json
{ "documentType": "*String (Trade License|NID|Food License)", "documentNumber": "*String", "documentFile": "*String (URL)", "issueDate": "Date", "expiryDate": "Date" }
```

### `PATCH /api/vendor/documents/:docId/verify`
Verify or reject a document. **Auth:** JWT (Admin)

**Request**
```json
{ "status": "*String (VERIFIED|REJECTED)", "verifiedBy": "String (userId)" }
```

---

### Wallet & Settlements

### `GET /api/vendor/:vendorCode/wallet`
Get vendor wallet with transaction history.

**Response**
```json
{
  "id": "UUID",
  "vendorId": "UUID",
  "balance": "Decimal",
  "holdBalance": "Decimal",
  "currency": "BDT",
  "status": "active",
  "transactions": [
    { "id": "UUID", "transactionType": "CREDIT|DEBIT", "amount": "Decimal", "balanceBefore": "Decimal", "balanceAfter": "Decimal", "referenceId": "String", "remarks": "String", "createdAt": "DateTime" }
  ]
}
```

### `GET /api/vendor/:vendorCode/settlements`
List settlement history for vendor.

**Response**
```json
[
  {
    "id": "UUID",
    "vendorId": "UUID",
    "settlementNumber": "String",
    "settlementPeriodStart": "DateTime",
    "settlementPeriodEnd": "DateTime",
    "totalOrders": "Int",
    "grossAmount": "Decimal",
    "totalCommission": "Decimal",
    "vatAmount": "Decimal",
    "adjustmentAmount": "Decimal",
    "totalPayable": "Decimal",
    "netAmount": "Decimal",
    "paymentStatus": "String (pending|paid)",
    "paymentDate": "DateTime"
  }
]
```

### `POST /api/vendor/:vendorCode/settlements/trigger`
Generate a settlement invoice manually.

**Request**
```json
{ "grossAmount": "*Float", "totalCommission": "*Float", "totalPayable": "*Float" }
```

---

### Settings & Hours

### `PATCH /api/vendor/:vendorCode/settings`
Update vendor operational flags.

**Request**
```json
{ "autoAcceptOrder": "Boolean", "autoAssignRider": "Boolean", "allowCustomMeal": "Boolean", "notificationEnabled": "Boolean" }
```

### `PUT /api/vendor/:vendorCode/operating-hours`
Replace all operating hours for vendor (deletes existing, inserts new).

**Request**
```json
{ "hours": [
  { "day": "*String (Monday|Tuesday|...|Sunday)", "openingTime": "*String (HH:mm)", "closingTime": "*String (HH:mm)" }
] }
```

---

### Vendor Finance (ID-based)

**Auth:** JWT (Vendor, Admin, SuperAdmin)

### `GET /api/vendors/:vendorId/wallet`
Get vendor wallet by ID. Auto-creates wallet if missing.

### `GET /api/vendors/:vendorId/wallet/transactions`
List wallet transactions for vendor. Paginated.

**Query:** `?page=1&limit=20`

### `GET /api/vendors/:vendorId/settlements`
List settlements for vendor. Paginated.

**Query:** `?page=1&limit=20`

---

### Vendor Orders

**Auth:** JWT (Vendor)

### `GET /api/vendors/:vendorId/orders`
List orders assigned to vendor. Paginated. Delegates to `GET /api/orders` with vendor filter.

**Query:** `?page=1&limit=20&status=`

---

### Admin Order Assignment

**Auth:** JWT (Admin)

### `PATCH /api/orders/:id/assign-vendor`
Assign or reassign a vendor to an order. Overrides `CartOrderAllocation` logic.

**Request**
```json
{ "vendorId": "*UUID" }
```

---

<a id="9-packages--meal-plans"></a>
## 9. Packages & Meal Plans

⚪ **Planned** — not started.

### Public Endpoints

### `GET /packages`
List available packages.

**Query:** `?page=1&limit=20&categoryId=&packageType=&status=active`  
**Response**
```json
{
  "items": [
    {
      "id": "UUID",
      "packageCode": "String",
      "name": "String",
      "slug": "String",
      "description": "Text",
      "thumbnail": "String",
      "coverImage": "String",
      "packageType": "String",
      "durationDays": "Int",
      "totalMeals": "Int",
      "price": "Float",
      "discountPrice": "Float",
      "currency": "String",
      "isCustomizable": "Boolean",
      "category": { "id": "UUID", "name": "String" },
      "tags": [ "String" ],
      "benefits": [ { "title": "String", "description": "String", "icon": "String" } ],
      "nutrition": { "dailyCalories": "Float", "dailyProtein": "Float", "dailyCarb": "Float", "dailyFat": "Float" },
      "rating": { "averageRating": "Float", "totalReview": "Int" }
    }
  ],
  "pagination": {}
}
```

### `GET /packages/:id`
Get package with full detail — days, meals, foods, schedule, rules.

**Response**
```json
{
  "id": "UUID",
  "...": "...",
  "rules": { "minimumOrderDays": "Int", "maximumOrderDays": "Int", "minimumMealsPerDay": "Int", "allowPause": "Boolean", "allowSkipMeal": "Boolean", "allowCancellation": "Boolean", "advancePaymentRequired": "Boolean" },
  "schedule": { "deliveryDays": "[String]", "deliveryTimeStart": "String", "deliveryTimeEnd": "String", "mealCutoffTime": "String" },
  "days": [
    {
      "dayNumber": "Int",
      "title": "String",
      "meals": [
        { "mealType": "String", "mealTime": "String", "calories": "Float", "foods": [ { "foodId": "UUID", "foodName": "String", "thumbnail": "String", "quantity": "Int", "isOptional": "Boolean" } ] }
      ]
    }
  ]
}
```

### --- Admin Package CRUD ---

**Auth:** JWT (Admin) for all below

### `POST /packages`
**Request**
```json
{ "packageCode": "*String", "name": "*String", "slug": "*String", "description": "Text", "packageType": "*String", "durationDays": "*Int", "totalMeals": "*Int", "price": "*Float", "discountPrice": "Float", "currency": "String", "isCustomizable": "Boolean", "status": "String" }
```

### `PATCH /packages/:id`
### `DELETE /packages/:id`

### `POST /packages/:packageId/days`
**Request**
```json
{ "dayNumber": "*Int", "title": "String", "description": "String" }
```

### `POST /package-days/:dayId/meals`
**Request**
```json
{ "mealType": "*Enum (Breakfast|Lunch|Dinner|Snacks)", "mealTime": "*String (HH:mm)", "calories": "Float" }
```

### `POST /package-meals/:mealId/foods`
**Request**
```json
{ "foodId": "*UUID", "quantity": "Int", "isOptional": "Boolean", "sortOrder": "Int" }
```

### `DELETE /package-meal-foods/:id`

### `POST /packages/:packageId/prices`
```json
{ "basePrice": "*Float", "discountPrice": "Float", "vat": "Float", "deliveryCharge": "Float", "effectiveFrom": "Date", "effectiveTo": "Date" }
```

### `PATCH /packages/:packageId/rules`
```json
{ "minimumOrderDays": "Int", "maximumOrderDays": "Int", "advancePaymentRequired": "Boolean", "allowPause": "Boolean", "allowSkipMeal": "Boolean", "allowCancellation": "Boolean" }
```

### `POST /packages/:packageId/benefits`
```json
{ "title": "*String", "description": "String", "icon": "String", "sortOrder": "Int" }
```

### `PATCH /packages/:packageId/nutrition`
```json
{ "dailyCalories": "Float", "dailyProtein": "Float", "dailyCarbohydrate": "Float", "dailyFat": "Float", "dailyFiber": "Float" }
```

### `PATCH /packages/:packageId/schedule`
```json
{ "deliveryDays": "[String]", "deliveryTimeStart": "String", "deliveryTimeEnd": "String", "mealCutoffTime": "String" }
```

### `PATCH /packages/:packageId/availability`
```json
{ "availableFrom": "Date", "availableTo": "Date", "availableDays": "[String]", "status": "String" }
```

### --- Package Reviews ---

### `GET /packages/:packageId/reviews`
### `POST /packages/:packageId/reviews`
**Auth:** JWT (Customer)
```json
{ "rating": "*Int (1-5)", "review": "String", "orderId": "UUID" }
```

### --- Custom Meal Plans ---

**Auth:** JWT (Customer)

### `GET /customers/me/meal-plans`
List custom meal plans.

### `POST /customers/me/meal-plans`
**Request**
```json
{ "packageId": "*UUID", "name": "*String", "totalDays": "*Int" }
```

### `GET /meal-plans/:id`
Get plan with days and meals.

### `DELETE /meal-plans/:id`

### `POST /meal-plans/:planId/meals`
```json
{ "dayNumber": "*Int", "mealType": "*Enum", "mealTime": "String" }
```

### `POST /meal-plans/:planId/meal-foods`
```json
{ "customMealId": "*UUID", "foodId": "*UUID", "quantity": "Int" }
```

### --- Preferences & Restrictions ---

**Auth:** JWT (Customer)

### `GET /customers/me/preferences`
### `POST /customers/me/preferences`
```json
{ "mealType": "String", "preferredCuisine": "String", "spiceLevel": "String", "preferredCalories": "Float", "preferredProtein": "Float" }
```

### `DELETE /preferences/:id`

### `GET /customers/me/dietary-restrictions`
### `POST /customers/me/dietary-restrictions`
```json
{ "restrictionType": "*String (No Beef|No Pork|Vegetarian|Vegan|etc.)", "description": "String" }
```

### `DELETE /dietary-restrictions/:id`

---

<a id="10-subscriptions"></a>
## 10. Subscriptions

⚪ **Planned** — not started.

### `POST /subscriptions`
Subscribe to a package.

**Auth:** JWT (Customer)  
**Request**
```json
{ "packageId": "*UUID (or customMealPlanId)", "customMealPlanId": "UUID", "startDate": "*Date", "endDate": "*Date", "duration": "*Int", "autoRenew": "Boolean" }
```

**Response `201`**
```json
{ "id": "UUID", "subscriptionNumber": "String", "status": "ACTIVE", "startDate": "Date", "endDate": "Date" }
```

### `GET /subscriptions`
List customer's subscriptions.

**Auth:** JWT (Customer)  
**Query:** `?page=1&limit=10&status=active|paused|expired|cancelled`  
**Response**
```json
{
  "items": [
    {
      "id": "UUID",
      "subscriptionNumber": "String",
      "package": { "name": "String", "thumbnail": "String" },
      "status": "String",
      "startDate": "Date",
      "endDate": "Date",
      "autoRenew": "Boolean",
      "totalAmount": "Float",
      "paidAmount": "Float",
      "nextDeliveryDate": "Date",
      "daysCompleted": "Int",
      "daysRemaining": "Int"
    }
  ],
  "pagination": {}
}
```

### `GET /subscriptions/:id`
Get full subscription detail.

**Response**
```json
{
  "id": "UUID",
  "subscriptionNumber": "String",
  "customer": { "id": "UUID", "fullName": "String", "phone": "String" },
  "package": { "id": "UUID", "name": "String", "slug": "String" },
  "status": "String",
  "startDate": "Date",
  "endDate": "Date",
  "duration": "Int",
  "autoRenew": "Boolean",
  "totalAmount": "Float",
  "paidAmount": "Float",
  "remainingAmount": "Float",
  "cycles": [
    { "cycleNumber": "Int", "startDate": "Date", "endDate": "Date", "status": "String" }
  ],
  "days": [
    {
      "dayNumber": "Int",
      "deliveryDate": "Date",
      "status": "String",
      "meals": [
        { "mealType": "String", "mealTime": "String", "food": { "name": "String", "thumbnail": "String" }, "status": "String", "deliveryStatus": "String", "feedback": { "rating": "Int" } }
      ]
    }
  ]
}
```

### `DELETE /subscriptions/:id`
Cancel subscription.

### --- Subscription Lifecycle ---

**Auth:** JWT (Customer)

### `POST /subscriptions/:id/pause`
**Request**
```json
{ "pauseStartDate": "*Date", "pauseEndDate": "*Date", "reason": "String" }
```

### `POST /subscriptions/:id/resume`
**Request**
```json
{ "resumeDate": "*Date" }
```

### `POST /subscriptions/:id/freeze`
**Request**
```json
{ "freezeStartDate": "*Date", "freezeEndDate": "*Date", "reason": "String" }
```

### `POST /subscriptions/:id/skip-meal`
**Request**
```json
{ "subscriptionMealId": "*UUID", "skipDate": "*Date", "reason": "String", "replacementMealId": "UUID" }
```

### `POST /subscriptions/:id/renew`
**Request**
```json
{ "paymentMethodId": "*UUID" }
```

### `POST /subscriptions/:id/upgrade`
**Request**
```json
{ "newPackageId": "*UUID", "paymentMethodId": "UUID (for price difference)" }
```

### `POST /subscriptions/:id/downgrade`
**Request**
```json
{ "newPackageId": "*UUID" }
```

### --- Subscription Admin ---

**Auth:** JWT (Admin)

### `GET /admin/subscriptions`
List all subscriptions — paginated, filterable by status, customer, package.

### `PATCH /subscription-days/:id/status`
Override a day's status.

### `PATCH /subscription-meals/:id/status`

### --- Meal Feedback & Issues ---

**Auth:** JWT (Customer)

### `POST /subscription-meals/:mealId/feedback`
```json
{ "rating": "*Int (1-5)", "review": "String", "image": "String (URL)" }
```

### `POST /subscription-meals/:mealId/issue`
```json
{ "issueType": "*String (quality|missing|late|wrong_item)", "description": "String", "attachment": "String (URL)" }
```

### `POST /subscription-meals/:mealId/replace`
```json
{ "newFoodId": "*UUID", "reason": "String" }
```

### --- Admin Issue Management ---

**Auth:** JWT (Admin)

### `GET /admin/meal-issues`
List all reported issues.

### `PATCH /meal-issues/:id/resolve`
```json
{ "resolution": "*String", "resolvedBy": "*UUID" }
```

### --- Invoices & History ---

### `GET /subscriptions/:id/history`
Action log.

### `GET /subscriptions/:id/status-history`
Status transitions.

### `GET /subscriptions/:id/invoices`
List subscription invoices.

**Response**
```json
{ "items": [ { "invoiceNumber": "String", "invoiceDate": "Date", "total": "Float", "pdfUrl": "String" } ] }
```

---

<a id="11-payments"></a>
## 11. Payments

🟢 **Built** — see [source](../../server/controllers/paymentController.ts)

### `GET /payment-methods`
List available methods. **Auth:** None

**Response**
```json
{ "items": [ { "id": "UUID", "name": "String (bKash|Visa|Cash)", "code": "String", "logo": "String", "type": "String", "isDefault": "Boolean" } ] }
```

### `POST /payments/initiate`
Start a payment.

**Auth:** JWT (Customer)  
**Request**
```json
{ "orderId": "*UUID", "paymentMethodId": "*UUID", "gatewayId": "*UUID", "amount": "*Float", "currency": "String" }
```

**Response `201`**
```json
{ "paymentId": "UUID", "gatewayUrl": "String", "transactionId": "String" }
```

### `POST /payments/confirm`
Gateway callback — update payment status.

**Auth:** None (called by payment gateway)
**Request**
```json
{ "transactionId": "*String", "gatewayTransactionId": "*String", "status": "*String (success|failed)", "gatewayResponse": "JSON" }
```

### `POST /payments/:id/retry`
Retry failed payment.

**Auth:** JWT (Customer)

### `POST /payments/:id/refund`
Process refund.

**Auth:** JWT (Admin)  
**Request**
```json
{ "amount": "*Float", "reason": "*String", "processedBy": "*UUID" }
```

### `POST /payments/:id/adjust`
Adjust payment amount.

**Auth:** JWT (Admin)  
**Request**
```json
{ "adjustmentType": "*String (correction|chargeback|bonus)", "amount": "*Float", "reason": "*String" }
```

### `GET /payments`
List payments. **Auth:** JWT (Admin, Customer)  
**Query:** `?page=1&limit=20&status=&customerId=&from=&to=`

### `GET /payments/:id`
Get payment details.

**Response**
```json
{
  "id": "UUID",
  "paymentNumber": "String",
  "orderId": "UUID",
  "orderNumber": "String",
  "customerName": "String",
  "paymentMethod": "String",
  "amount": "Float",
  "currency": "String",
  "status": "String",
  "paymentDate": "DateTime",
  "transactions": [ { "gatewayTransactionId": "String", "status": "String", "amount": "Float", "processedAt": "DateTime" } ],
  "refunds": [ { "refundAmount": "Float", "refundMethod": "String", "status": "String", "processedAt": "DateTime" } ],
  "adjustments": [ { "adjustmentType": "String", "amount": "Float", "reason": "String" } ]
}
```

---

<a id="12-customer-wallet"></a>
## 12. Customer Wallet

⚪ **Planned** — not started.

### `GET /wallet`
Get current customer's wallet.

**Auth:** JWT (Customer)  
**Response**
```json
{ "id": "UUID", "walletNumber": "String", "balance": "Float", "holdBalance": "Float", "currency": "String", "status": "String" }
```

### `GET /wallet/transactions`
List wallet transactions.

**Query:** `?page=1&limit=20&type=credit|debit`  
**Response**
```json
{
  "items": [
    { "id": "UUID", "transactionType": "Enum (CREDIT|DEBIT)", "amount": "Float", "balanceBefore": "Float", "balanceAfter": "Float", "referenceType": "String (order|topup|cashback|refund)", "referenceId": "UUID", "remarks": "String", "createdAt": "DateTime" }
  ],
  "pagination": {}
}
```

### `POST /wallet/topup`
Add funds via payment gateway.

**Auth:** JWT (Customer)  
**Request**
```json
{ "amount": "*Float", "paymentMethodId": "*UUID" }
```

**Response**
```json
{ "paymentId": "UUID", "gatewayUrl": "String" }
```

### `POST /wallet/withdraw`
Request withdrawal.

**Auth:** JWT (Customer)  
**Request**
```json
{ "amount": "*Float", "withdrawMethod": "*String (bank|mobile_banking)", "accountNumber": "*String" }
```

### `PATCH /wallet/withdraw/:id/approve`
Approve withdrawal. **Auth:** JWT (Admin)

---

<a id="13-vendor-settlements"></a>
## 13. Vendor Settlements

⚪ **Planned** — not started.

### `GET /vendors/:vendorId/wallet`
Get vendor wallet.

**Auth:** JWT (Vendor, Admin)  
**Response**
```json
{ "balance": "Float", "holdBalance": "Float", "currency": "String", "status": "String" }
```

### `GET /vendors/:vendorId/wallet/transactions`

### `GET /vendors/:vendorId/settlements`
List settlements. **Response**
```json
{
  "items": [
    { "id": "UUID", "settlementNumber": "String", "settlementPeriodStart": "Date", "settlementPeriodEnd": "Date", "totalOrders": "Int", "grossAmount": "Float", "commissionAmount": "Float", "adjustmentAmount": "Float", "netAmount": "Float", "paymentStatus": "String", "paymentDate": "DateTime" }
  ]
}
```

### `GET /settlements/:id`
Get settlement with order breakdown.

### `POST /admin/settlements`
Create settlement batch. **Auth:** JWT (Admin)

**Request**
```json
{ "vendorId": "*UUID", "settlementPeriodStart": "*Date", "settlementPeriodEnd": "*Date" }
```

### `POST /settlements/:id/process`
Mark settlement as paid. **Auth:** JWT (Admin)

**Request**
```json
{ "transactionId": "String", "paymentMethod": "String", "processedAt": "DateTime" }
```

### `GET /platform/revenue`
Platform revenue summary. **Auth:** JWT (Admin)

**Response**
```json
{ "totalRevenue": "Float", "commissionRevenue": "Float", "deliveryRevenue": "Float", "subscriptionRevenue": "Float", "period": { "from": "Date", "to": "Date" } }
```

---

<a id="14-riders"></a>
## 14. Riders

⚪ **Planned** — not started.

### Rider CRUD (Admin)

### `GET /riders`
List riders. **Auth:** JWT (Admin, Vendor)  
**Query:** `?page=1&limit=20&status=&isOnline=`

**Response**
```json
{
  "items": [
    {
      "id": "UUID",
      "riderCode": "String",
      "fullName": "String",
      "phone": "String",
      "email": "String",
      "profileImage": "String",
      "status": "String",
      "isOnline": "Boolean",
      "isAvailable": "Boolean",
      "employmentType": "String",
      "vehicleType": "String",
      "totalDeliveries": "Int",
      "averageRating": "Float",
      "averageDeliveryTime": "Float",
      "earnings": "Float"
    }
  ],
  "pagination": {}
}
```

### `POST /riders`
**Auth:** JWT (Admin, Vendor)  
**Request**
```json
{ "userId": "*UUID", "vendorId": "UUID", "branchId": "UUID", "fullName": "*String", "phone": "*String", "email": "String", "nidNumber": "*String", "licenseNumber": "*String", "licenseExpiryDate": "Date", "joiningDate": "Date", "employmentType": "String (fulltime|parttime|contract)" }
```

### `GET /riders/:id`
**GET /riders/:id** returns full rider profile.

### `PATCH /riders/:id`
### `DELETE /riders/:id`
Soft-delete.

### `PATCH /riders/:id/online`
Toggle online. **Auth:** JWT (Rider)

### `PATCH /riders/:id/status`
Change status. **Auth:** JWT (Admin)

### --- Documents & Vehicle ---

### `GET /riders/:riderId/documents`
### `POST /riders/:riderId/documents`
```json
{ "documentType": "*String (NID|Driving License)", "documentNumber": "*String", "documentUrl": "*String (URL)", "expiryDate": "Date" }
```

### `PATCH /rider-documents/:id/verify`
**Auth:** JWT (Admin)
```json
{ "verificationStatus": "*String (verified|rejected)" }
```

### `GET /riders/:riderId/vehicle`
### `POST /riders/:riderId/vehicle`
```json
{ "vehicleType": "*String (bike|scooter|car)", "brand": "String", "model": "String", "registrationNumber": "*String", "color": "String", "insuranceNumber": "String", "insuranceExpiryDate": "Date" }
```

### `PATCH /rider-vehicle/:id`

### --- Performance & Ratings ---

### `GET /riders/:riderId/performance`
**Response**
```json
{ "totalDeliveries": "Int", "completedDeliveries": "Int", "cancelledDeliveries": "Int", "averageDeliveryTime": "Float", "averageRating": "Float", "acceptanceRate": "Float", "completionRate": "Float" }
```

### `GET /riders/:riderId/ratings`
**Response**
```json
{ "items": [ { "customerName": "String", "rating": "Int", "review": "String", "createdAt": "DateTime" } ] }
```

### --- Rider Wallet ---

### `GET /riders/:riderId/wallet`
### `GET /riders/:riderId/wallet/transactions`
### `POST /rider-wallet/withdraw`
**Request**
```json
{ "amount": "*Float", "withdrawMethod": "*String", "accountNumber": "*String" }
```

### --- Availability & Shift ---

### `GET /riders/:riderId/availability`
### `POST /riders/:riderId/availability`
```json
{ "dayOfWeek": "*String (Monday|...|Sunday)", "startTime": "*String (HH:mm)", "endTime": "*String (HH:mm)", "isAvailable": "Boolean" }
```

### `POST /riders/:riderId/shifts`
```json
{ "shiftName": "*String", "startTime": "*String (HH:mm)", "endTime": "*String (HH:mm)", "status": "String" }
```

### `POST /riders/:riderId/attendance`
```json
{ "checkIn": "*DateTime", "checkOut": "DateTime", "workingHours": "Float", "attendanceStatus": "String (present|absent|late)" }
```

---

<a id="15-deliveries--live-tracking"></a>
## 15. Deliveries & Live Tracking

⚪ **Planned** — not started.

### `POST /orders/:orderId/delivery`
Create delivery for an order.

**Auth:** JWT (Admin)  
**Request**
```json
{ "deliveryType": "String (standard|express|scheduled)", "priority": "Int" }
```

**Response `201`**
```json
{ "id": "UUID", "deliveryCode": "String", "deliveryStatus": "PENDING" }
```

### `PATCH /deliveries/:id/assign-rider`
**Auth:** JWT (Admin, Vendor)  
**Request**
```json
{ "riderId": "*UUID" }
```

### `PATCH /deliveries/:id/status`
Update delivery status.

**Auth:** JWT (Rider, Admin)  
**Request**
```json
{ "status": "*String (picked_up|on_the_way|delivered|failed)", "remarks": "String", "location": { "latitude": "Float", "longitude": "Float" } }
```

### `POST /deliveries/:id/proof`
Upload delivery proof.

**Auth:** JWT (Rider)  
**Request**
```json
{ "proofType": "*String (photo|signature|otp)", "image": "String (URL)", "signature": "String (URL)", "otp": "String" }
```

### `POST /deliveries/:id/attempt`
Log failed delivery attempt.

**Auth:** JWT (Rider)  
**Request**
```json
{ "reason": "*String" }
```

### `GET /deliveries`
List deliveries. **Auth:** JWT (Admin, Vendor, Rider)  
**Query:** `?page=1&limit=20&status=&riderId=&from=&to=`

### `GET /deliveries/:id`
Get delivery details with tracking info.

### --- Routes ---

### `POST /routes/optimize`
Generate optimized delivery route.

**Auth:** JWT (Admin)  
**Request**
```json
{ "riderId": "*UUID", "deliveryIds": "*[UUID]" }
```

**Response**
```json
{ "id": "UUID", "routeCode": "String", "totalDistance": "Float", "estimatedDuration": "Int", "stops": [ { "stopNumber": "Int", "deliveryId": "UUID", "customerAddress": "String", "latitude": "Float", "longitude": "Float", "estimatedArrivalTime": "DateTime" } ] }
```

### `GET /routes/:id`
Get route with stops.

### `PATCH /routes/:id/assign-rider`
**Request**
```json
{ "riderId": "*UUID" }
```

### --- Live Tracking ---

### `POST /tracking/session`
Start tracking. **Auth:** JWT (Rider)

**Request**
```json
{ "deliveryId": "*UUID" }
```

**Response**
```json
{ "id": "UUID", "trackingCode": "String", "sessionId": "String" }
```

### `PATCH /tracking/session/:id/end`
End tracking.

### `POST /tracking/location`
Update rider location. **Auth:** JWT (Rider)

**Request**
```json
{ "sessionId": "*String", "latitude": "*Float", "longitude": "*Float", "speed": "Float", "heading": "Float", "accuracy": "Float", "batteryLevel": "Float" }
```

### `GET /deliveries/:deliveryId/tracking`
Get tracking info (customer-facing). **Auth:** JWT (Customer, Admin)

**Response**
```json
{
  "deliveryStatus": "String",
  "riderName": "String",
  "riderPhone": "String",
  "riderPhoto": "String",
  "riderLatitude": "Float",
  "riderLongitude": "Float",
  "estimatedArrivalTime": "DateTime",
  "remainingDistance": "Float",
  "remainingDuration": "Int",
  "events": [ { "event": "String (picked_up|nearby|arrived|delivered)", "description": "String", "createdAt": "DateTime" } ]
}
```

### `GET /tracking/eta/:deliveryId`
Get ETA only. **Auth:** JWT (Customer)

---

<a id="16-notifications"></a>
## 16. Notifications

⚪ **Planned** — not started.

### `GET /notifications`
List current user's notifications.

**Auth:** JWT (All)  
**Query:** `?page=1&limit=20&type=order|payment|promotion|system`  
**Response**
```json
{
  "items": [
    { "id": "UUID", "title": "String", "message": "String", "type": "String", "referenceType": "String", "referenceId": "UUID", "isRead": "Boolean", "createdAt": "DateTime" }
  ],
  "pagination": {},
  "unreadCount": "Int"
}
```

### `PATCH /notifications/:id/read`
Mark one as read.

### `POST /notifications/read-all`
Mark all as read.

### `GET /notifications/unread-count`
**Response**
```json
{ "unreadCount": "Int" }
```

### --- Admin: Broadcast & Announcements ---

### `POST /admin/broadcast`
Send push/email/SMS to targeted users.

**Auth:** JWT (Admin)  
**Request**
```json
{ "title": "*String", "message": "*String", "targetType": "*String (all|customers|vendors|riders|custom_segment)", "segmentId": "UUID", "channels": ["push", "email", "sms"], "scheduledAt": "DateTime" }
```

### `GET /admin/announcements`
List announcements.

### `POST /admin/announcements`
**Request**
```json
{ "title": "*String", "description": "Text", "image": "String (URL)", "startDate": "Date", "endDate": "Date" }
```

### `PATCH /admin/announcements/:id`

### --- FAQ ---

### `GET /faq/categories`
Public.

### `GET /faq/categories/:categoryId/faqs`
Public.

### `POST /admin/faq/categories`
**Auth:** JWT (Admin)
```json
{ "name": "*String", "icon": "String" }
```

### `POST /admin/faq`
```json
{ "categoryId": "*UUID", "question": "*String", "answer": "*Text", "sortOrder": "Int" }
```

### `PATCH /admin/faq/:id`
### `DELETE /admin/faq/:id`

---

<a id="17-support-tickets"></a>
## 17. Support Tickets

⚪ **Planned** — not started.

### `POST /support/tickets`
Create ticket.

**Auth:** JWT (Customer)  
**Request**
```json
{ "orderId": "UUID", "categoryId": "*UUID", "subject": "*String", "description": "*String", "priority": "String (low|medium|high|urgent)" }
```

**Response `201`**
```json
{ "id": "UUID", "ticketNumber": "String", "status": "OPEN" }
```

### `GET /support/tickets`
List user's tickets. **Auth:** JWT (Customer, SupportAgent)

### `GET /support/tickets/:id`
Get ticket with replies.

### `PATCH /support/tickets/:id`
Update. **Auth:** JWT (SupportAgent)

**Request**
```json
{ "status": "String (OPEN|IN_PROGRESS|WAITING|RESOLVED|CLOSED)", "assignedTo": "UUID", "priority": "String" }
```

### `POST /support/tickets/:id/replies`
Add reply. **Auth:** JWT (Owner, SupportAgent)

**Request**
```json
{ "message": "*String", "attachment": "String (URL)", "isInternal": "Boolean (for agent notes)" }
```

### `GET /support/tickets/:id/replies`

### --- Admin: Ticket Management ---

### `GET /admin/support/tickets`
List all tickets. **Auth:** JWT (SupportAgent)

**Query:** `?page=1&limit=20&status=&priority=&assignedTo=`

### `GET /admin/support/categories`
### `POST /admin/support/categories`
```json
{ "name": "*String", "description": "String" }
```

---

<a id="18-cms"></a>
## 18. CMS

⚪ **Planned** — not started.

### `GET /cms/banners`
List active banners. **Auth:** None  
**Response**
```json
{ "items": [ { "id": "UUID", "title": "String", "subtitle": "String", "image": "String (URL)", "redirectType": "String (food|package|category|url)", "redirectId": "String", "displayOrder": "Int" } ] }
```

### `POST /cms/banners`
**Auth:** JWT (Admin)
```json
{ "title": "*String", "subtitle": "String", "image": "*String (URL)", "redirectType": "String", "redirectId": "String", "displayOrder": "Int", "startDate": "Date", "endDate": "Date" }
```

### `PATCH /cms/banners/:id`
### `DELETE /cms/banners/:id`

### `GET /cms/sliders`
### `POST /cms/sliders`
```json
{ "title": "*String", "description": "String", "image": "*String (URL)", "buttonText": "String", "buttonUrl": "String", "displayOrder": "Int" }
```

### `PATCH /cms/sliders/:id`
### `DELETE /cms/sliders/:id`

### `GET /cms/blogs`
Public, paginated.

### `GET /cms/blogs/:slug`
### `POST /cms/blogs`
**Auth:** JWT (Admin)
```json
{ "title": "*String", "slug": "*String", "thumbnail": "String (URL)", "content": "*Text", "categoryId": "UUID" }
```

### `PATCH /cms/blogs/:id`
### `DELETE /cms/blogs/:id`

### `GET /cms/pages/:slug`
Get static page (About, Privacy, Terms, etc.).

---

<a id="19-reports--analytics"></a>
## 19. Reports & Analytics

⚪ **Planned** — not started.

### `GET /analytics/dashboard`
Dashboard overview metrics.

**Auth:** JWT (Admin)  
**Response**
```json
{
  "totalUsers": "Int",
  "totalCustomers": "Int",
  "totalVendors": "Int",
  "totalRiders": "Int",
  "totalOrders": "Int",
  "completedOrders": "Int",
  "cancelledOrders": "Int",
  "totalRevenue": "Float",
  "todaySales": "Float",
  "todayOrders": "Int",
  "activeSubscriptions": "Int",
  "pendingVendors": "Int"
}
```

### `GET /analytics/sales`
Sales analytics. **Query:** `?from=Date&to=Date&period=daily|weekly|monthly`

**Response**
```json
{ "data": [ { "date": "Date", "totalSales": "Float", "grossRevenue": "Float", "netRevenue": "Float", "commission": "Float", "refundAmount": "Float", "deliveryCharge": "Float" } ], "summary": { "total": "Float", "average": "Float", "growth": "Float" } }
```

### `GET /analytics/revenue`
Revenue breakdown.

### `GET /analytics/customer/:customerId`
Per-customer analytics.

### `GET /analytics/vendor/:vendorId`
Per-vendor performance.

### `GET /analytics/rider/:riderId`
Per-rider metrics.

### `GET /analytics/package/:packageId`
Per-package performance.

### --- Reports ---

### `POST /reports/generate`
Generate a report.

**Auth:** JWT (Admin)  
**Request**
```json
{ "reportType": "*String (sales|revenue|finance|subscription|customer|vendor|rider|delivery|payment|tax|inventory|marketing|coupon|refund|audit)", "startDate": "*Date", "endDate": "*Date", "filters": "JSON", "exportType": "String (pdf|csv|xlsx)" }
```

### `GET /reports`
List generated reports.

### `GET /reports/:id`
Get report detail + download URL.

### `POST /reports/schedules`
Schedule recurring report.

**Request**
```json
{ "reportTemplateId": "*UUID", "frequency": "*String (daily|weekly|monthly)", "nextRun": "*Date", "emailTo": "*[String]" }
```

### `GET /reports/templates`
List report templates.

### `POST /reports/templates`
**Request**
```json
{ "name": "*String", "reportType": "*String", "description": "String", "filters": "JSON", "columns": "[String]", "chartType": "String" }
```

### --- KPIs ---

### `GET /analytics/kpis`
**Response**
```json
{ "items": [ { "name": "String", "code": "String", "value": "Float", "target": "Float", "percentage": "Float", "reportDate": "Date" } ] }
```

### --- Dashboard Configuration ---

### `GET /analytics/dashboard/widgets`
### `POST /analytics/dashboard/widgets`
```json
{ "name": "*String", "widgetType": "*String (chart|table|metric|list)", "position": "Int", "configuration": "JSON" }
```

### `PATCH /analytics/dashboard/widgets/:id`
### `DELETE /analytics/dashboard/widgets/:id`

### `GET /analytics/dashboard/layout`
Get user's dashboard layout.

### `PATCH /analytics/dashboard/layout`
```json
{ "layout": "JSON", "theme": "String" }
```

---

<a id="20-roles--permissions"></a>
## 20. Roles & Permissions

⚪ **Planned** — not started.

### `GET /roles`
List all roles.

**Auth:** JWT (SuperAdmin, Admin)  
**Response**
```json
{ "items": [ { "id": "UUID", "name": "String", "slug": "String", "description": "String", "isDefault": "Boolean", "status": "String" } ] }
```

### `POST /roles`
**Auth:** JWT (SuperAdmin)

**Request**
```json
{ "name": "*String", "slug": "*String", "description": "String", "isDefault": "Boolean", "status": "String" }
```

### `PATCH /roles/:id`
### `DELETE /roles/:id`

### `GET /permissions`
List all permissions.

**Auth:** JWT (SuperAdmin, Admin)

### `POST /permissions`
**Auth:** JWT (SuperAdmin)
```json
{ "module": "*String", "name": "*String", "slug": "*String", "description": "String" }
```

### `PATCH /permissions/:id`
### `DELETE /permissions/:id`

### `GET /roles/:roleId/permissions`
Get permissions assigned to a role.

### `POST /roles/:roleId/permissions`
Assign permissions.

**Request**
```json
{ "permissionIds": "*[UUID]" }
```

### `DELETE /roles/:roleId/permissions/:permissionId`
Remove permission from role.

### `GET /users/:userId/roles`
Get user's roles.

### `POST /users/:userId/roles`
Assign role to user.

**Auth:** JWT (SuperAdmin)  
**Request**
```json
{ "roleId": "*UUID", "expiresAt": "DateTime" }
```

### `DELETE /users/:userId/roles/:userRoleId`
Remove role from user.

---

<a id="21-system-settings"></a>
## 21. System Settings

⚪ **Planned** — not started.

### `GET /admin/settings`
Get all settings (key-value list).

**Auth:** JWT (SuperAdmin)

### `PATCH /admin/settings/:key`
Update a specific setting.

**Request**
```json
{ "settingValue": "*String" }
```

### `GET /admin/settings/general`
**Response**
```json
{ "appName": "String", "appLogo": "String (URL)", "supportEmail": "String", "supportPhone": "String", "currency": "String", "timezone": "String", "language": "String", "maintenanceMode": "Boolean" }
```

### `PATCH /admin/settings/general`
```json
{ "appName": "String", "appLogo": "String", "supportEmail": "String", "supportPhone": "String", "currency": "String", "timezone": "String", "language": "String" }
```

### `PATCH /admin/settings/payment`
```json
{ "gatewayName": "String", "isSandbox": "Boolean", "merchantId": "String", "storeId": "String", "apiKey": "String" }
```

### `PATCH /admin/settings/delivery`
```json
{ "minimumDeliveryTime": "Int", "maximumDeliveryDistance": "Float", "defaultDeliveryCharge": "Float", "freeDeliveryAmount": "Float" }
```

### `PATCH /admin/settings/packages`
```json
{ "minimumOrderDays": "Int", "maximumOrderDays": "Int", "allowCustomization": "Boolean", "allowPause": "Boolean", "allowSkipMeal": "Boolean" }
```

### `PATCH /admin/settings/commission`
```json
{ "defaultCommissionType": "String", "defaultCommissionRate": "Float", "minimumCommission": "Float", "maximumCommission": "Float" }
```

### `PATCH /admin/settings/notifications`
```json
{ "pushEnabled": "Boolean", "smsEnabled": "Boolean", "emailEnabled": "Boolean", "marketingEnabled": "Boolean" }
```

### `GET /admin/feature-flags`
List all feature toggles.

**Auth:** JWT (Admin)  
**Response**
```json
{ "items": [ { "featureName": "String", "isEnabled": "Boolean", "description": "String" } ] }
```

### `PATCH /admin/feature-flags/:name`
Toggle feature.

**Auth:** JWT (SuperAdmin)  
**Request**
```json
{ "isEnabled": "*Boolean" }
```

### `GET /admin/maintenance`
Check maintenance mode.

### `POST /admin/maintenance`
Enable/disable.

**Auth:** JWT (SuperAdmin)  
**Request**
```json
{ "enabled": "*Boolean", "message": "String", "startTime": "DateTime", "endTime": "DateTime" }
```

### `GET /health`
Basic health check. **Auth:** None

**Response**
```json
{ "status": "ok", "timestamp": "DateTime", "uptime": "Int" }
```

---

> **Document version:** 3.0.0  
> **Field reference:** See `docs/FONDO – Complete System Workflow.md` Modules 1–15 for all model field definitions  
> **Last updated:** 2026-07-16
