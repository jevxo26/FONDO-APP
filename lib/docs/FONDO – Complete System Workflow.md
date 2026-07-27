# **FONDO – Smart Subscription Food Delivery Platform**

## **Project Vision & Complete System Workflow**

---

<div style="display: flex; gap: 40px;">
<div>

### Business & Workflow

| # | Section |
|---|---|
| 1 | [Project Vision](#1-project-vision) |
| 2 | [Business Model](#2-business-model) |
| 3 | [System Actors](#3-system-actors) |
| 4 | [Complete Business Workflow](#4-complete-business-workflow) |
| 5 | [Customer Journey](#5-customer-journey) |
| 6 | [Subscription Lifecycle](#6-subscription-lifecycle) |
| 7 | [Daily Meal Generation](#7-daily-meal-generation) |
| 8 | [Vendor Workflow](#8-vendor-workflow) |
| 9 | [Kitchen Workflow](#9-kitchen-workflow) |
| 10 | [Rider Workflow](#10-rider-workflow) |
| 11 | [Customer Tracking](#11-customer-tracking) |
| 12 | [Admin Management](#12-admin-management) |
| 13 | [Hidden Vendor Architecture](#13-hidden-vendor-architecture) |
| 14 | [Subscription Lifecycle](#14-subscription-lifecycle) |
| 15 | [Live Delivery Tracking](#15-live-delivery-tracking) |
| 16 | [Notification System](#16-notification-system) |
| 17 | [Marketing System](#17-marketing-system) |
| 18 | [Analytics Dashboard](#18-analytics-dashboard) |
| 19 | [Recommended Technology Stack](#19-recommended-technology-stack) |
| 20 | [High-Level System Architecture](#20-high-level-system-architecture) |
| 21 | [Enterprise Modules](#21-enterprise-modules) |

</div>
<div>

### Data Models

| # | Module |
|---|---|
| 1 | [Authentication Module](#authentication-module) |
| 2 | [Role & Permission Module](#role--permission-module) |
| 3 | [Vendor Module](#vendor-module) |
| 4 | [Food Catalog Module](#food-catalog-module) |
| 5 | [Hidden Vendor Mapping Module](#hidden-vendor-mapping-module) |
| 6 | [Meal Plan & Package Module](#meal-plan--package-module) |
| 7 | [Cart & Order Module](#cart--order-module) |
| 8 | [Payment, Wallet & Settlement Module](#payment-wallet--settlement-module) |
| 9 | [Rider, Delivery, Route & Live Tracking Module](#rider-delivery-route--live-tracking-module) |
| 10 | [Chat, Notification & Support Module](#chat-notification--support-module) |
| 11 | [CMS, Analytics, Inventory, Audit & System Settings](#cms-analytics-inventory-audit--system-settings) |
| 12 | [Subscription & Meal Lifecycle Module](#subscription--meal-lifecycle-module) |
| 13 | [Marketing, Campaign, Referral & Loyalty Module](#marketing-campaign-referral--loyalty-module) |
| 14 | [Reports, Business Intelligence & Data Warehouse](#reports-business-intelligence--data-warehouse) |
| 15 | [Infrastructure, DevOps & System Operations Module](#infrastructure-devops--system-operations-module) |

</div>
</div>

---

# **1\. Project Vision**

**FONDO** is a modern **Subscription-Based Food Delivery Platform** designed to provide healthy, scheduled, and customizable meal delivery services.

Unlike traditional food delivery platforms, customers do **not** place individual food orders every day. Instead, they subscribe to meal plans, customize their meals, pay in advance, and receive meals automatically according to their delivery schedule.

The platform supports multiple vendors, kitchens, riders, subscriptions, meal customization, live delivery tracking, and enterprise-level business management.

---

# **2\. Business Model**

The platform operates as a centralized marketplace.

Customers never know which vendor prepares their food.

The platform manages vendors internally while presenting a single unified food catalog to customers.

Example:

Customer sees:

* Chicken Rice  
* Beef Curry  
* Healthy Salad

Customer never sees:

* Vendor A  
* Vendor B  
* Kitchen XYZ

The system automatically assigns food preparation to the appropriate vendor based on business rules.

---

# **3\. System Actors**

* Super Admin  
* Admin  
* Vendor  
* Vendor Staff  
* Kitchen Staff  
* Rider  
* Customer  
* Support Agent

---

# **4\. Complete Business Workflow**

Admin  
    │  
    ▼  
Register Vendor  
    │  
    ▼  
Vendor Adds Foods  
    │  
    ▼  
Admin Reviews & Approves Foods  
    │  
    ▼  
Customer Opens Mobile App  
    │  
    ▼  
Browse Packages  
    │  
    ▼  
Customize Meals  
    │  
    ▼  
Checkout  
    │  
    ▼  
Advance Payment  
    │  
    ▼  
Subscription Created  
    │  
    ▼  
Daily Orders Generated Automatically  
    │  
    ▼  
Vendor Kitchen  
    │  
    ▼  
Food Preparation  
    │  
    ▼  
Assign Rider  
    │  
    ▼  
Delivery  
    │  
    ▼  
Customer Rating & Feedback

---

# **5\. Customer Journey**

## **Step 1 – Registration**

Register

↓

Verify OTP

↓

Complete Profile

↓

Add Delivery Address

↓

Ready

---

## **Step 2 – Home Screen**

Customers can browse:

* Promotional Banners  
* Meal Packages  
* Healthy Meals  
* Categories  
* Popular Meals  
* Today's Menu  
* Recommended Meals  
* Offers & Discounts  
* Custom Meal Plans

---

## **Step 3 – Select a Meal Package**

Available packages:

* 7-Day Package  
* 10-Day Package  
* 15-Day Package  
* Monthly Package

Or

Create a completely custom meal plan.

---

## **Step 4 – Customize Meals**

Customers can customize meals for every delivery.

Example:

Monday

Breakfast  
    Bread \+ Egg

Lunch  
    Chicken Rice

Dinner  
    Fish \+ Vegetables

Tuesday

Breakfast  
    Oatmeal

Lunch  
    Beef Curry

Dinner  
    Salad

Customers can also:

* Replace meals  
* Remove meals  
* Add extra protein  
* Add beverages  
* Add snacks

---

## **Step 5 – Cart**

The cart calculates:

Package Price

\+

Meal Customization

\+

Add-ons

\+

Delivery Charge

\-

Coupon Discount

\=

Grand Total

---

## **Step 6 – Payment**

Supported payment methods:

* bKash  
* Nagad  
* SSLCommerz  
* Visa  
* MasterCard  
* Wallet

Advance payment is mandatory.

If payment fails:

* Subscription is not created.  
* Order is not confirmed.

---

# **6\. Subscription Lifecycle**

Payment Successful

↓

Subscription Created

↓

Generate Meal Schedule

↓

Generate Delivery Schedule

↓

Subscription Activated

---

# **7\. Daily Meal Generation**

Every day the system automatically creates today's meals.

Subscription

↓

Today's Meal Plan

↓

Today's Order

↓

Kitchen Queue

↓

Delivery Queue

Customers do not need to place daily orders.

Everything is generated automatically.

---

# **8\. Vendor Workflow**

Vendor Dashboard

↓

Manage Foods

↓

Manage Inventory

↓

Manage Kitchen

↓

Manage Riders

↓

Receive Daily Orders

↓

Prepare Meals

↓

Mark Ready

↓

Assign Rider

↓

Delivery

---

# **9\. Kitchen Workflow**

Kitchen Dashboard

Today's Orders

↓

Today's Meals

↓

Cooking

↓

Packing

↓

Ready for Pickup

---

# **10\. Rider Workflow**

Vendor Assigns Rider

↓

Pickup Meals

↓

Start GPS Tracking

↓

Navigate Optimized Route

↓

Customer OTP Verification

↓

Successful Delivery

↓

Complete

---

# **11\. Customer Tracking**

Customers can monitor the entire delivery process.

Preparing

↓

Packed

↓

Rider Assigned

↓

On The Way

↓

Live GPS Tracking

↓

Delivered

---

# **12\. Admin Management**

The Admin controls the entire ecosystem.

## **Vendor Management**

* Register Vendors  
* Approve Vendors  
* Suspend Vendors  
* Vendor Settlement  
* Vendor Performance

---

## **Customer Management**

* Customer Profiles  
* Orders  
* Subscriptions  
* Payments  
* Wallets

---

## **Food Management**

* Food Approval  
* Categories  
* Nutrition  
* Availability  
* Pricing

---

## **Package Management**

* Create Packages  
* Edit Packages  
* Delete Packages  
* Manage Meal Plans

---

## **Order Management**

* Pending Orders  
* Confirmed Orders  
* Kitchen Queue  
* Delivery Queue  
* Completed Orders  
* Cancelled Orders

---

## **Payment Management**

* Transactions  
* Refunds  
* Wallet  
* Coupons  
* Settlements

---

## **Rider Management**

* Live Location  
* Performance  
* Ratings  
* Attendance  
* Earnings

---

## **Reports**

* Sales Reports  
* Revenue Reports  
* Vendor Reports  
* Rider Reports  
* Customer Reports  
* Subscription Reports  
* Inventory Reports

---

# **13\. Hidden Vendor Architecture**

Customers never know which vendor prepares the meal.

Customer View

Chicken Rice

৳350

Backend View

Chicken Rice

↓

Vendor A

↓

Kitchen 3

↓

Assigned Rider

The Admin can switch vendors at any time without affecting the customer experience.

---

# **14\. Subscription Lifecycle**

Purchase

↓

Active

↓

Pause

↓

Resume

↓

Skip Meal

↓

Meal Replacement

↓

Renew

↓

Complete

---

# **15\. Live Delivery Tracking**

Kitchen

↓

Packed

↓

Rider Pickup

↓

Live GPS Tracking

↓

ETA Updates

↓

Customer Delivery

---

# **16\. Notification System**

Automatic notifications include:

* Payment Confirmation  
* Order Confirmation  
* Meal Reminder  
* Delivery Reminder  
* Subscription Renewal Reminder  
* Promotional Offers  
* Coupons  
* Chat Messages

---

# **17\. Marketing System**

The platform supports:

* Coupons  
* Cashback  
* Referral Programs  
* Loyalty Points  
* Promotional Campaigns  
* Push Notifications  
* Email Marketing  
* SMS Marketing

---

# **18\. Analytics Dashboard**

The Admin dashboard displays:

* Today's Revenue  
* Today's Orders  
* Today's Deliveries  
* Active Subscriptions  
* Top Selling Foods  
* Top Vendors  
* Top Riders  
* Customer Retention Rate  
* Subscription Renewal Rate  
* Cancellation Rate  
* Profit & Loss  
* Business KPIs

---

# **19\. Recommended Technology Stack**

## **Backend**

* NestJS  
* TypeScript  
* Prisma ORM  
* PostgreSQL  
* Redis  
* BullMQ  
* Socket.IO  
* JWT Authentication  
* Refresh Token

---

## **Frontend (Web)**

* Next.js  
* React  
* TypeScript  
* Redux Toolkit  
* TanStack Query  
* Tailwind CSS  
* Shadcn/UI

---

## **Mobile Application**

* React Native (Expo)

---

## **Cloud & Infrastructure**

* Docker  
* Nginx  
* GitHub Actions  
* AWS S3 / MinIO  
* Redis  
* PostgreSQL  
* Cloudflare CDN

---

# **20\. High-Level System Architecture**

                   Customer Mobile App  
                           │  
                           ▼  
                 REST API / WebSocket  
                           │  
                           ▼  
                      API Gateway  
                           │  
                           ▼  
                Authentication Service  
                           │  
                           ▼  
                  Business Service Layer  
     ┌───────────────────────────────────────────┐  
     │ User Service                              │  
     │ Food Service                              │  
     │ Vendor Service                            │  
     │ Package Service                           │  
     │ Subscription Service                      │  
     │ Order Service                             │  
     │ Payment Service                           │  
     │ Rider Service                             │  
     │ Delivery Service                          │  
     │ Notification Service                      │  
     │ Chat Service                              │  
     │ Marketing Service                         │  
     │ Reporting Service                         │  
     └───────────────────────────────────────────┘  
                           │  
                           ▼  
               Background Workers (BullMQ)  
     ┌───────────────────────────────────────────┐  
     │ Daily Order Generation                    │  
     │ Payment Callback Processing               │  
     │ Notification Queue                        │  
     │ Route Optimization                        │  
     │ Settlement Processing                     │  
     │ Report Generation                         │  
     │ Subscription Scheduler                    │  
     └───────────────────────────────────────────┘  
                           │  
                           ▼  
            PostgreSQL \+ Redis \+ Object Storage

---

# **21\. Enterprise Modules**

The complete system consists of the following enterprise modules:

1. Authentication & User Management  
2. Role & Permission Management  
3. Food & Menu Management  
4. Vendor & Kitchen Management  
5. Package & Meal Planning  
6. Cart & Order Management  
7. Payment & Settlement  
8. Rider & Delivery Management  
9. Chat, Notification & Customer Support  
10. CMS, Inventory & System Settings  
11. Subscription & Meal Lifecycle  
12. Marketing, Referral & Loyalty  
13. Reports & Business Intelligence  
14. Infrastructure, DevOps & System Operations

---

# **Conclusion**

FONDO is designed as a scalable, enterprise-grade subscription meal delivery platform that combines meal subscriptions, hidden multi-vendor management, intelligent kitchen operations, automated daily order generation, real-time rider tracking, advanced payment processing, customer engagement, analytics, and cloud-native infrastructure into a single unified ecosystem.

The architecture is modular, highly scalable, and suitable for future expansion into a multi-city or nationwide food delivery platform.

# Authentication Module

# **Authentication Module**

## **User**

id  
uuid  
fullName  
firstName  
lastName  
phone  
email  
password  
avatar  
gender  
dateOfBirth  
status  
isPhoneVerified  
isEmailVerified  
lastLoginAt  
createdAt  
updatedAt  
deletedAt  
---

## **UserProfile**

id  
userId  
profession  
occupation  
company  
bio  
preferredLanguage  
timezone  
profileCompletionPercentage  
createdAt  
updatedAt  
---

## **UserAddress**

id  
userId  
label  
receiverName  
receiverPhone  
country  
division  
district  
upazila  
area  
road  
house  
floor  
apartment  
landmark  
postalCode  
latitude  
longitude  
deliveryInstruction  
isDefault  
createdAt  
updatedAt  
deletedAt  
---

## **UserDevice**

id  
userId  
deviceId  
deviceName  
deviceType  
operatingSystem  
osVersion  
appVersion  
browser  
pushToken  
ipAddress  
lastActiveAt  
createdAt  
updatedAt  
---

## **UserSession**

id  
userId  
deviceId  
accessToken  
refreshToken  
ipAddress  
loginAt  
expiresAt  
logoutAt  
status  
createdAt  
updatedAt  
---

## **UserOTP**

id  
userId  
phone  
email  
otp  
purpose  
expiresAt  
verifiedAt  
attemptCount  
status  
createdAt  
updatedAt

**purpose**

* LOGIN  
* REGISTER  
* FORGOT\_PASSWORD  
* PHONE\_VERIFY  
* EMAIL\_VERIFY

---

## **UserToken**

id  
userId  
token  
type  
expiresAt  
revokedAt  
createdAt  
updatedAt

**type**

* ACCESS  
* REFRESH  
* RESET\_PASSWORD  
* VERIFY\_EMAIL

---

## **UserLoginHistory**

id  
userId  
deviceId  
ipAddress  
browser  
platform  
country  
city  
loginMethod  
loginStatus  
loggedInAt  
loggedOutAt  
createdAt  
---

## **UserSecurity**

id  
userId  
passwordChangedAt  
failedLoginCount  
lastFailedLoginAt  
twoFactorEnabled  
accountLocked  
accountLockedUntil  
securityQuestion  
securityAnswer  
createdAt  
updatedAt  
---

## **UserNotificationSetting**

id  
userId  
pushNotification  
emailNotification  
smsNotification  
orderNotification  
paymentNotification  
promotionNotification  
chatNotification  
marketingNotification  
systemNotification  
createdAt  
updatedAt  
---

# **Role & Permission Module**

## **Role**

id  
name  
slug  
description  
isDefault  
status  
createdAt  
updatedAt

### **Example Roles**

SUPER\_ADMIN  
ADMIN  
CUSTOMER  
VENDOR  
VENDOR\_MANAGER  
VENDOR\_STAFF  
RIDER  
SUPPORT\_AGENT  
ACCOUNTANT  
---

## **Permission**

id  
module  
name  
slug  
description  
createdAt  
updatedAt

### **Example Permissions**

USER\_CREATE  
USER\_UPDATE  
USER\_DELETE  
USER\_VIEW

ORDER\_CREATE  
ORDER\_UPDATE  
ORDER\_CANCEL  
ORDER\_VIEW

VENDOR\_CREATE  
VENDOR\_UPDATE  
VENDOR\_DELETE  
VENDOR\_VIEW

PACKAGE\_CREATE  
PACKAGE\_UPDATE  
PACKAGE\_DELETE

PAYMENT\_VIEW  
PAYMENT\_REFUND

RIDER\_ASSIGN  
ROUTE\_MANAGE  
CHAT\_MANAGE  
REPORT\_VIEW  
---

## **RolePermission**

id  
roleId  
permissionId  
createdAt  
---

## **UserRole**

id  
userId  
roleId  
assignedBy  
assignedAt  
expiresAt  
status  
createdAt  
updatedAt  
---

# **Relationships**

User (1)  
│  
├── UserProfile (1:1)  
├── UserAddress (1:N)  
├── UserDevice (1:N)  
├── UserSession (1:N)  
├── UserOTP (1:N)  
├── UserToken (1:N)  
├── UserLoginHistory (1:N)  
├── UserSecurity (1:1)  
├── UserNotificationSetting (1:1)  
└── UserRole (1:N)

Role (1)  
│  
└── RolePermission (1:N)

Permission (1)  
│  
└── RolePermission (1:N)

# Vendor Module

# **Vendor**

id  
userId  
vendorCode  
businessName  
ownerName  
phone  
email  
tradeLicenseNumber  
tinNumber  
binNumber  
logo  
coverImage  
description  
status  
verificationStatus  
isActive  
isOnline  
commissionType  
commissionValue  
openingTime  
closingTime  
createdAt  
updatedAt  
deletedAt  
---

# **VendorProfile**

id  
vendorId  
businessType  
businessCategory  
foundedYear  
employeeCount  
website  
facebook  
instagram  
youtube  
description  
mission  
createdAt  
updatedAt  
---

# **VendorBranch**

id  
vendorId  
branchName  
branchCode  
phone  
email  
country  
division  
district  
upazila  
area  
road  
house  
postalCode  
latitude  
longitude  
isMainBranch  
status  
createdAt  
updatedAt  
---

# **VendorKitchen**

id  
vendorId  
branchId  
kitchenName  
kitchenCode  
capacity  
preparationTime  
status  
createdAt  
updatedAt  
---

# **VendorStaff**

id  
vendorId  
branchId  
userId  
fullName  
phone  
email  
designation  
joiningDate  
salary  
status  
createdAt  
updatedAt  
---

# **VendorStaffRole**

id  
staffId  
role  
permissions  
createdAt  
updatedAt

### **Example Roles**

Kitchen Manager  
Chef  
Cook  
Packing Staff  
Delivery Manager  
Branch Manager  
---

# **VendorDocument**

id  
vendorId  
documentType  
documentNumber  
documentFile  
issueDate  
expiryDate  
verificationStatus  
verifiedBy  
verifiedAt  
createdAt  
updatedAt

### **documentType**

Trade License  
BIN  
TIN  
NID  
Food License  
Fire Safety  
---

# **VendorBankAccount**

id  
vendorId  
bankName  
branchName  
accountName  
accountNumber  
routingNumber  
mobileBankingType  
mobileBankingNumber  
isPrimary  
createdAt  
updatedAt  
---

# **VendorPaymentInfo**

id  
vendorId  
paymentMethod  
accountName  
accountNumber  
walletNumber  
status  
createdAt  
updatedAt  
---

# **VendorOperatingHour**

id  
vendorId  
day  
openingTime  
closingTime  
isClosed  
createdAt  
updatedAt  
---

# **VendorHoliday**

id  
vendorId  
holidayName  
holidayDate  
description  
createdAt  
updatedAt  
---

# **VendorServiceArea**

id  
vendorId  
division  
district  
upazila  
area  
deliveryCharge  
minimumOrderAmount  
estimatedDeliveryTime  
createdAt  
updatedAt  
---

# **VendorZone**

id  
vendorId  
zoneName  
zoneCode  
description  
status  
createdAt  
updatedAt  
---

# **VendorSubscription**

id  
vendorId  
planId  
startDate  
endDate  
amount  
paymentStatus  
status  
createdAt  
updatedAt  
---

# **VendorSubscriptionHistory**

id  
vendorSubscriptionId  
oldPlan  
newPlan  
amount  
changedBy  
changedAt  
createdAt  
---

# **VendorCommission**

id  
vendorId  
commissionType  
commissionPercentage  
flatAmount  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt  
---

# **VendorSettlement**

id  
vendorId  
settlementNumber  
totalOrderAmount  
totalCommission  
totalPayable  
settlementDate  
paymentStatus  
transactionId  
createdAt  
updatedAt  
---

# **VendorWallet**

id  
vendorId  
balance  
holdBalance  
currency  
status  
createdAt  
updatedAt  
---

# **VendorWalletTransaction**

id  
walletId  
transactionType  
amount  
balanceBefore  
balanceAfter  
referenceId  
remarks  
createdAt

### **transactionType**

Credit  
Debit  
Settlement  
Refund  
Adjustment  
---

# **VendorRating**

id  
vendorId  
averageRating  
totalRating  
fiveStar  
fourStar  
threeStar  
twoStar  
oneStar  
updatedAt  
---

# **VendorReview**

id  
vendorId  
customerId  
rating  
review  
status  
createdAt  
updatedAt

**Note:** Customer vendor-এর নাম দেখবে না। এই review internal quality monitoring-এর জন্য।

---

# **VendorNotification**

id  
vendorId  
title  
message  
type  
isRead  
createdAt  
---

# **VendorSettings**

id  
vendorId  
autoAcceptOrder  
autoAssignRider  
allowCustomMeal  
allowPackage  
notificationEnabled  
smsEnabled  
emailEnabled  
status  
createdAt  
updatedAt  
---

# **VendorActivityLog**

id  
vendorId  
staffId  
activity  
module  
ipAddress  
device  
createdAt  
---

# **Relationship**

Vendor  
│  
├── VendorProfile (1:1)  
├── VendorBranch (1:N)  
│      └── VendorKitchen (1:N)  
│  
├── VendorStaff (1:N)  
│      └── VendorStaffRole (1:1)  
│  
├── VendorDocument (1:N)  
├── VendorBankAccount (1:N)  
├── VendorPaymentInfo (1:N)  
├── VendorOperatingHour (1:N)  
├── VendorHoliday (1:N)  
├── VendorServiceArea (1:N)  
├── VendorZone (1:N)  
├── VendorSubscription (1:N)  
├── VendorCommission (1:N)  
├── VendorSettlement (1:N)  
├── VendorWallet (1:1)  
│      └── VendorWalletTransaction (1:N)  
├── VendorRating (1:1)  
├── VendorReview (1:N)  
├── VendorNotification (1:N)  
├── VendorSettings (1:1)  
└── VendorActivityLog (1:N)

# Food Catalog Module

# **Category**

id  
name  
slug  
description  
icon  
image  
sortOrder  
status  
createdAt  
updatedAt  
deletedAt  
---

# **SubCategory**

id  
categoryId  
name  
slug  
description  
icon  
image  
sortOrder  
status  
createdAt  
updatedAt  
deletedAt  
---

# **Food**

id  
categoryId  
subCategoryId  
foodCode  
name  
slug  
shortDescription  
description  
thumbnail  
coverImage  
preparationTime  
calories  
protein  
fat  
carbohydrate  
servingSize  
foodType  
spiceLevel  
isFeatured  
isPopular  
isRecommended  
status  
createdAt  
updatedAt  
deletedAt

### **foodType**

VEG  
NON\_VEG  
VEGAN  
SEAFOOD  
---

# **FoodGallery**

id  
foodId  
image  
sortOrder  
createdAt  
updatedAt  
---

# **FoodVariant**

id  
foodId  
name  
description  
price  
discountPrice  
weight  
servingSize  
status  
createdAt  
updatedAt

### **Example**

Small  
Medium  
Large  
---

# **FoodAddon**

id  
foodId  
name  
isRequired  
maxSelection  
status  
createdAt  
updatedAt  
---

# **FoodAddonItem**

id  
addonId  
name  
price  
image  
status  
createdAt  
updatedAt

### **Example**

Extra Egg

Extra Rice

Extra Chicken

Extra Salad  
---

# **FoodIngredient**

id  
foodId  
ingredientName  
quantity  
unit  
isOptional  
createdAt  
updatedAt  
---

# **FoodNutrition**

id  
foodId  
calories  
protein  
fat  
carbohydrate  
fiber  
sugar  
sodium  
cholesterol  
servingSize  
createdAt  
updatedAt  
---

# **FoodAllergen**

id  
foodId  
allergen  
description  
createdAt  
updatedAt

### **Example**

Milk  
Egg  
Peanut  
Soy  
Fish  
Gluten  
---

# **FoodPreparation**

id  
foodId  
preparationTime  
cookTime  
packingTime  
estimatedReadyTime  
createdAt  
updatedAt  
---

# **FoodAvailability**

id  
foodId  
availableFrom  
availableTo  
isAvailable  
availableDays  
createdAt  
updatedAt  
---

# **FoodSchedule**

id  
foodId  
mealType  
startTime  
endTime  
status  
createdAt  
updatedAt

### **mealType**

Breakfast  
Lunch  
Dinner  
Snacks  
---

# **FoodPrice**

id  
foodId  
basePrice  
salePrice  
currency  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt  
---

# **FoodDiscount**

id  
foodId  
discountType  
discountValue  
startDate  
endDate  
status  
createdAt  
updatedAt

### **discountType**

PERCENTAGE  
FLAT  
---

# **FoodTag**

id  
name  
slug  
createdAt  
updatedAt  
---

# **FoodTagMapping**

id  
foodId  
tagId  
createdAt

### **Example Tags**

Healthy

High Protein

Low Carb

Keto

Popular

Chef Special

New  
---

# **FoodLabel**

id  
foodId  
label  
color  
createdAt  
updatedAt

### **Example**

Best Seller

Trending

New

Recommended  
---

# **FoodReview**

id  
foodId  
customerId  
orderId  
rating  
review  
status  
createdAt  
updatedAt  
---

# **FoodRating**

id  
foodId  
averageRating  
totalReview  
fiveStar  
fourStar  
threeStar  
twoStar  
oneStar  
updatedAt  
---

# **FoodFavorite**

id  
userId  
foodId  
createdAt  
---

# **FoodVisibility**

id  
foodId  
isVisible  
isFeatured  
isRecommended  
displayOrder  
createdAt  
updatedAt  
---

# **FoodDiet**

id  
foodId  
dietType  
createdAt  
updatedAt

### **Example**

Diabetic

Weight Loss

Weight Gain

Keto

High Protein

Low Sodium

Vegetarian  
---

# **FoodRelationship**

Category  
│  
├── SubCategory (1:N)  
│  
└── Food (1:N)  
     │  
     ├── FoodGallery (1:N)  
     ├── FoodVariant (1:N)  
     ├── FoodAddon (1:N)  
     │      └── FoodAddonItem (1:N)  
     ├── FoodIngredient (1:N)  
     ├── FoodNutrition (1:1)  
     ├── FoodAllergen (1:N)  
     ├── FoodPreparation (1:1)  
     ├── FoodAvailability (1:N)  
     ├── FoodSchedule (1:N)  
     ├── FoodPrice (1:N)  
     ├── FoodDiscount (1:N)  
     ├── FoodTagMapping (1:N)  
     ├── FoodLabel (1:N)  
     ├── FoodReview (1:N)  
     ├── FoodRating (1:1)  
     ├── FoodFavorite (1:N)  
     ├── FoodVisibility (1:1)  
     └── FoodDiet (1:N)  
---

# Hidden Vendor Mapping Module

# **VendorFood**

id  
vendorId  
foodId  
vendorFoodCode  
vendorSku  
kitchenId  
branchId  
priority  
status  
isAvailable  
isPrimary  
createdAt  
updatedAt  
deletedAt  
---

# **VendorFoodPrice**

id  
vendorFoodId  
costPrice  
sellingPrice  
discountPrice  
currency  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt  
---

# **VendorFoodStock**

id  
vendorFoodId  
availableQuantity  
reservedQuantity  
minimumStock  
maximumStock  
stockStatus  
lastUpdatedAt  
createdAt  
updatedAt

### **stockStatus**

IN\_STOCK  
LOW\_STOCK  
OUT\_OF\_STOCK  
---

# **VendorFoodAvailability**

id  
vendorFoodId  
dayOfWeek  
startTime  
endTime  
isAvailable  
createdAt  
updatedAt  
---

# **VendorFoodPreparationTime**

id  
vendorFoodId  
averagePreparationTime  
minimumPreparationTime  
maximumPreparationTime  
packingTime  
createdAt  
updatedAt  
---

# **VendorFoodRecipe**

id  
vendorFoodId  
recipeName  
recipeVersion  
description  
yieldQuantity  
createdAt  
updatedAt  
---

# **VendorFoodRecipeItem**

id  
recipeId  
ingredientName  
quantity  
unit  
isOptional  
createdAt  
updatedAt  
---

# **VendorFoodCost**

id  
vendorFoodId  
ingredientCost  
packagingCost  
labourCost  
overheadCost  
totalCost  
profitMargin  
createdAt  
updatedAt  
---

# **VendorFoodPackaging**

id  
vendorFoodId  
packageType  
packageSize  
packageCost  
isEcoFriendly  
createdAt  
updatedAt  
---

# **VendorFoodImage**

id  
vendorFoodId  
image  
imageType  
sortOrder  
createdAt  
updatedAt  
---

# **VendorFoodQuality**

id  
vendorFoodId  
qualityScore  
lastInspectionDate  
inspectionStatus  
remarks  
createdAt  
updatedAt  
---

# **VendorFoodStatusHistory**

id  
vendorFoodId  
oldStatus  
newStatus  
changedBy  
reason  
createdAt  
---

# **VendorFoodAssignment**

id  
foodId  
vendorId  
priority  
allocationPercentage  
isDefault  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt

**Example**

Chicken Rice

* Vendor A → 60%  
* Vendor B → 40%

Admin পরে সহজেই Vendor switch করতে পারবে।

---

# **VendorFoodZone**

id  
vendorFoodId  
zoneId  
deliveryRadius  
estimatedDeliveryTime  
createdAt  
updatedAt  
---

# **VendorFoodSchedule**

id  
vendorFoodId  
mealType  
dayOfWeek  
productionLimit  
availableQuantity  
createdAt  
updatedAt  
---

# **VendorFoodInventory**

id  
vendorFoodId  
inventoryId  
requiredQuantity  
unit  
createdAt  
updatedAt  
---

# **VendorFoodPerformance**

id  
vendorFoodId  
totalOrders  
completedOrders  
cancelledOrders  
averagePreparationTime  
averageDeliveryTime  
customerRating  
lastCalculatedAt  
---

# **VendorFoodRelationship**

Vendor  
│  
├── VendorFood (1:N)  
│      │  
│      ├── VendorFoodPrice (1:N)  
│      ├── VendorFoodStock (1:1)  
│      ├── VendorFoodAvailability (1:N)  
│      ├── VendorFoodPreparationTime (1:1)  
│      ├── VendorFoodRecipe (1:N)  
│      │      └── VendorFoodRecipeItem (1:N)  
│      ├── VendorFoodCost (1:1)  
│      ├── VendorFoodPackaging (1:1)  
│      ├── VendorFoodImage (1:N)  
│      ├── VendorFoodQuality (1:1)  
│      ├── VendorFoodStatusHistory (1:N)  
│      ├── VendorFoodZone (1:N)  
│      ├── VendorFoodSchedule (1:N)  
│      ├── VendorFoodInventory (1:N)  
│      └── VendorFoodPerformance (1:1)  
│  
Food  
│  
└── VendorFoodAssignment (1:N)  
---

# **Order Allocation Flow**

Customer  
    │  
    ▼  
Food (Chicken Rice)  
    │  
    ▼  
VendorFoodAssignment  
    │  
    ├── Vendor A (Priority 1\)  
    ├── Vendor B (Priority 2\)  
    └── Vendor C (Backup)  
    │  
    ▼  
VendorFood  
    │  
    ▼  
Kitchen  
    │  
    ▼  
Rider  
    │  
    ▼  
Customer  
---

# Meal Plan & Package Module

# **Package**

id  
packageCode  
name  
slug  
description  
thumbnail  
coverImage  
packageType  
durationDays  
totalMeals  
price  
discountPrice  
currency  
isCustomizable  
status  
createdAt  
updatedAt  
deletedAt  
---

# **PackageCategory**

id  
name  
slug  
description  
icon  
status  
createdAt  
updatedAt

### **Example**

Weight Loss

Weight Gain

Regular

Diabetic

High Protein

Office Meal  
---

# **PackageDay**

id  
packageId  
dayNumber  
title  
description  
status  
createdAt  
updatedAt  
---

# **PackageMeal**

id  
packageDayId  
mealType  
mealTime  
calories  
status  
createdAt  
updatedAt

### **mealType**

Breakfast

Lunch

Dinner

Snacks  
---

# **PackageMealFood**

id  
packageMealId  
foodId  
quantity  
isOptional  
sortOrder  
createdAt  
updatedAt  
---

# **PackagePrice**

id  
packageId  
basePrice  
discountPrice  
vat  
deliveryCharge  
totalPrice  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt  
---

# **PackageRule**

id  
packageId  
minimumOrderDays  
maximumOrderDays  
minimumMealsPerDay  
maximumMealsPerDay  
advancePaymentRequired  
allowPause  
allowResume  
allowSkipMeal  
allowCancellation  
status  
createdAt  
updatedAt  
---

# **PackageBenefit**

id  
packageId  
title  
description  
icon  
sortOrder  
createdAt  
updatedAt  
---

# **PackageNutrition**

id  
packageId  
dailyCalories  
dailyProtein  
dailyCarbohydrate  
dailyFat  
dailyFiber  
dailySugar  
dailySodium  
createdAt  
updatedAt  
---

# **PackageSchedule**

id  
packageId  
deliveryDays  
deliveryTimeStart  
deliveryTimeEnd  
mealCutoffTime  
status  
createdAt  
updatedAt  
---

# **PackageImage**

id  
packageId  
image  
sortOrder  
createdAt  
updatedAt  
---

# **PackageTag**

id  
packageId  
tag  
createdAt  
updatedAt

### **Example**

Best Seller

Healthy

Recommended

Popular

Premium  
---

# **PackageReview**

id  
packageId  
customerId  
orderId  
rating  
review  
status  
createdAt  
updatedAt  
---

# **PackageRating**

id  
packageId  
averageRating  
totalReview  
fiveStar  
fourStar  
threeStar  
twoStar  
oneStar  
updatedAt  
---

# **PackageCustomization**

id  
packageId  
allowFoodReplace  
allowMealSkip  
allowExtraMeal  
allowExtraProtein  
allowExtraRice  
allowDrink  
allowAddon  
createdAt  
updatedAt  
---

# **CustomMealPlan**

id  
customerId  
packageId  
name  
totalDays  
status  
createdAt  
updatedAt  
---

# **CustomMealDay**

id  
customMealPlanId  
dayNumber  
createdAt  
updatedAt  
---

# **CustomMeal**

id  
customMealDayId  
mealType  
mealTime  
createdAt  
updatedAt  
---

# **CustomMealFood**

id  
customMealId  
foodId  
quantity  
isExtra  
createdAt  
updatedAt  
---

# **MealPreference**

id  
customerId  
mealType  
preferredCuisine  
spiceLevel  
preferredCalories  
preferredProtein  
createdAt  
updatedAt  
---

# **DietaryRestriction**

id  
customerId  
restrictionType  
description  
createdAt  
updatedAt

### **Example**

No Beef

No Pork

No Sugar

Low Salt

Vegetarian

Vegan  
---

# **PackageAvailability**

id  
packageId  
availableFrom  
availableTo  
availableDays  
status  
createdAt  
updatedAt  
---

# **PackageRelationship**

Package  
│  
├── PackageCategory (N:1)  
├── PackageDay (1:N)  
│      │  
│      └── PackageMeal (1:N)  
│              │  
│              └── PackageMealFood (1:N)  
│  
├── PackagePrice (1:N)  
├── PackageRule (1:1)  
├── PackageBenefit (1:N)  
├── PackageNutrition (1:1)  
├── PackageSchedule (1:1)  
├── PackageImage (1:N)  
├── PackageTag (1:N)  
├── PackageReview (1:N)  
├── PackageRating (1:1)  
├── PackageCustomization (1:1)  
├── PackageAvailability (1:1)  
│  
└── CustomMealPlan (1:N)  
       │  
       ├── CustomMealDay (1:N)  
       │      └── CustomMeal (1:N)  
       │              └── CustomMealFood (1:N)  
       │  
       ├── MealPreference (1:N)  
       └── DietaryRestriction (1:N)  
---

# **Booking Flow**

Customer  
   │  
   ▼  
Select Package  
   │  
   ▼  
Select 5–7 Days  
   │  
   ▼  
Customize Meals  
   │  
   ▼  
Calculate Price  
   │  
   ▼  
Advance Payment  
   │  
   ▼  
Generate Order  
   │  
   ▼  
Delivery Schedule

# Cart & Order Module

# **Cart**

id  
customerId  
packageId  
customMealPlanId  
couponId  
subtotal  
discount  
deliveryCharge  
vat  
totalAmount  
expiresAt  
status  
createdAt  
updatedAt  
---

# **CartItem**

id  
cartId  
foodId  
packageMealId  
quantity  
unitPrice  
totalPrice  
isCustomized  
createdAt  
updatedAt  
---

# **CartMeal**

id  
cartId  
dayNumber  
mealType  
mealTime  
createdAt  
updatedAt  
---

# **CartMealFood**

id  
cartMealId  
foodId  
quantity  
isReplacement  
createdAt  
updatedAt  
---

# **CartAddon**

id  
cartItemId  
addonItemId  
quantity  
price  
createdAt  
updatedAt  
---

# **CartSummary**

id  
cartId  
itemCount  
mealCount  
subtotal  
discount  
deliveryCharge  
vat  
grandTotal  
createdAt  
updatedAt  
---

# **CartHistory**

id  
cartId  
action  
performedBy  
remarks  
createdAt  
---

# **Order**

id  
orderNumber  
customerId  
vendorId  
packageId  
customMealPlanId  
addressId  
paymentId  
couponId  
subtotal  
discount  
deliveryCharge  
vat  
totalAmount  
paymentStatus  
orderStatus  
deliveryStatus  
orderSource  
notes  
placedAt  
confirmedAt  
completedAt  
cancelledAt  
createdAt  
updatedAt  
deletedAt  
---

# **OrderItem**

id  
orderId  
foodId  
vendorFoodId  
quantity  
unitPrice  
discount  
totalPrice  
status  
createdAt  
updatedAt  
---

# **OrderMeal**

id  
orderId  
dayNumber  
deliveryDate  
mealType  
mealTime  
status  
createdAt  
updatedAt  
---

# **OrderMealFood**

id  
orderMealId  
foodId  
vendorFoodId  
quantity  
status  
createdAt  
updatedAt  
---

# **OrderCustomization**

id  
orderMealFoodId  
replacementFoodId  
extraProtein  
extraRice  
extraDrink  
specialInstruction  
additionalCost  
createdAt  
updatedAt  
---

# **OrderSchedule**

id  
orderId  
deliveryDate  
deliverySlot  
estimatedDeliveryTime  
status  
createdAt  
updatedAt  
---

# **OrderStatusHistory**

id  
orderId  
previousStatus  
currentStatus  
changedBy  
remarks  
createdAt

### **Order Status**

PENDING

PAYMENT\_PENDING

CONFIRMED

PREPARING

READY\_FOR\_PICKUP

PICKED\_UP

ON\_THE\_WAY

DELIVERED

COMPLETED

CANCELLED

REFUNDED  
---

# **OrderTimeline**

id  
orderId  
title  
description  
status  
createdAt  
---

# **OrderInvoice**

id  
orderId  
invoiceNumber  
invoiceDate  
subtotal  
discount  
vat  
deliveryCharge  
grandTotal  
pdfUrl  
createdAt  
updatedAt  
---

# **OrderCancellation**

id  
orderId  
cancelledBy  
reason  
refundAmount  
refundStatus  
cancelledAt  
createdAt  
---

# **OrderRefund**

id  
orderId  
paymentId  
refundAmount  
refundMethod  
refundStatus  
processedBy  
processedAt  
createdAt  
---

# **OrderFeedback**

id  
orderId  
customerId  
rating  
review  
createdAt  
updatedAt  
---

# **OrderRelationship**

Customer  
│  
├── Cart (1:N)  
│      ├── CartItem (1:N)  
│      ├── CartMeal (1:N)  
│      │      └── CartMealFood (1:N)  
│      ├── CartAddon (1:N)  
│      ├── CartSummary (1:1)  
│      └── CartHistory (1:N)  
│  
└── Order (1:N)  
      │  
      ├── OrderItem (1:N)  
      ├── OrderMeal (1:N)  
      │      └── OrderMealFood (1:N)  
      │              └── OrderCustomization (1:1)  
      │  
      ├── OrderSchedule (1:N)  
      ├── OrderStatusHistory (1:N)  
      ├── OrderTimeline (1:N)  
      ├── OrderInvoice (1:1)  
      ├── OrderCancellation (0..1)  
      ├── OrderRefund (0..N)  
      └── OrderFeedback (0..1)  
---

# **Complete Order Flow**

Customer  
   │  
   ▼  
Select Package  
   │  
   ▼  
Customize Meals  
   │  
   ▼  
Add To Cart  
   │  
   ▼  
Apply Coupon  
   │  
   ▼  
Checkout  
   │  
   ▼  
Advance Payment  
   │  
   ▼  
Order Created  
   │  
   ▼  
Vendor Assigned  
   │  
   ▼  
Kitchen Preparation  
   │  
   ▼  
Rider Assignment  
   │  
   ▼  
Live Tracking  
   │  
   ▼  
Delivered  
   │  
   ▼  
Review & Rating

# Payment, Wallet & Settlement Module

# **Payment**

id  
paymentNumber  
orderId  
customerId  
paymentMethodId  
gatewayId  
transactionId  
amount  
currency  
status  
paymentDate  
gatewayResponse  
failureReason  
createdAt  
updatedAt  
---

# **PaymentMethod**

id  
name  
code  
provider  
type  
logo  
isDefault  
isActive  
createdAt  
updatedAt

### **Example**

SSLCommerz  
bKash  
Nagad  
Rocket  
Visa  
MasterCard  
Amex  
---

# **PaymentGateway**

id  
name  
merchantId  
storeId  
apiKey  
secretKey  
sandboxMode  
callbackUrl  
refundUrl  
status  
createdAt  
updatedAt  
---

# **PaymentTransaction**

id  
paymentId  
gatewayTransactionId  
merchantTransactionId  
transactionType  
amount  
currency  
status  
responseCode  
responseMessage  
gatewayResponse  
processedAt  
createdAt  
updatedAt  
---

# **PaymentLog**

id  
paymentId  
requestBody  
responseBody  
status  
createdAt  
---

# **PaymentAttempt**

id  
paymentId  
attemptNumber  
paymentMethod  
status  
failureReason  
attemptAt  
createdAt  
---

# **PaymentRefund**

id  
paymentId  
orderId  
refundAmount  
refundMethod  
gatewayRefundId  
reason  
status  
processedBy  
processedAt  
createdAt  
updatedAt  
---

# **PaymentAdjustment**

id  
paymentId  
adjustmentType  
amount  
reason  
approvedBy  
createdAt  
updatedAt  
---

# **PaymentInvoice**

id  
paymentId  
invoiceNumber  
invoiceUrl  
invoiceDate  
subtotal  
discount  
vat  
deliveryCharge  
grandTotal  
createdAt  
updatedAt  
---

# **PaymentHistory**

id  
paymentId  
oldStatus  
newStatus  
remarks  
changedBy  
createdAt  
---

# **CustomerWallet**

id  
customerId  
walletNumber  
balance  
holdBalance  
currency  
status  
createdAt  
updatedAt  
---

# **CustomerWalletTransaction**

id  
walletId  
transactionType  
amount  
balanceBefore  
balanceAfter  
referenceType  
referenceId  
remarks  
createdAt

### **transactionType**

Credit  
Debit  
Refund  
Adjustment  
Topup  
Purchase  
---

# **WalletTopup**

id  
walletId  
paymentId  
amount  
status  
createdAt  
updatedAt  
---

# **WalletWithdraw**

id  
walletId  
amount  
withdrawMethod  
accountNumber  
status  
approvedBy  
processedAt  
createdAt  
updatedAt  
---

# **WalletHistory**

id  
walletId  
action  
referenceId  
description  
createdAt  
---

# **VendorSettlement**

id  
vendorId  
settlementNumber  
settlementPeriodStart  
settlementPeriodEnd  
totalOrders  
grossAmount  
commissionAmount  
vatAmount  
adjustmentAmount  
netAmount  
paymentStatus  
paymentDate  
createdAt  
updatedAt  
---

# **VendorSettlementItem**

id  
settlementId  
orderId  
orderAmount  
commission  
adjustment  
payableAmount  
createdAt  
---

# **VendorSettlementTransaction**

id  
settlementId  
transactionId  
bankAccountId  
amount  
paymentMethod  
status  
processedAt  
createdAt  
---

# **VendorCommission**

id  
vendorId  
commissionType  
commissionRate  
minimumCommission  
maximumCommission  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt

### **commissionType**

Percentage  
Flat  
Hybrid  
---

# **VendorEarning**

id  
vendorId  
orderId  
grossAmount  
commission  
netAmount  
settlementStatus  
createdAt  
updatedAt  
---

# **PlatformRevenue**

id  
orderId  
vendorId  
commissionAmount  
deliveryCharge  
serviceCharge  
vat  
netRevenue  
createdAt  
updatedAt  
---

# **Tax**

id  
taxName  
taxType  
taxPercentage  
effectiveFrom  
effectiveTo  
status  
createdAt  
updatedAt  
---

# **Coupon**

id  
couponCode  
title  
description  
discountType  
discountValue  
minimumOrderAmount  
maximumDiscount  
usageLimit  
perUserLimit  
startDate  
endDate  
status  
createdAt  
updatedAt  
---

# **CouponUsage**

id  
couponId  
customerId  
orderId  
discountAmount  
usedAt  
---

# **Referral**

id  
referrerId  
referredUserId  
referralCode  
rewardAmount  
status  
createdAt  
updatedAt  
---

# **LoyaltyPoint**

id  
customerId  
earnedPoint  
redeemedPoint  
balancePoint  
lastUpdatedAt  
createdAt  
updatedAt  
---

# **LoyaltyTransaction**

id  
loyaltyPointId  
transactionType  
points  
referenceType  
referenceId  
createdAt  
---

# **Relationship**

Payment  
│  
├── PaymentMethod (N:1)  
├── PaymentGateway (N:1)  
├── PaymentTransaction (1:N)  
├── PaymentAttempt (1:N)  
├── PaymentLog (1:N)  
├── PaymentRefund (1:N)  
├── PaymentAdjustment (1:N)  
├── PaymentInvoice (1:1)  
└── PaymentHistory (1:N)

Customer  
│  
└── CustomerWallet (1:1)  
      ├── CustomerWalletTransaction (1:N)  
      ├── WalletTopup (1:N)  
      ├── WalletWithdraw (1:N)  
      └── WalletHistory (1:N)

Vendor  
│  
├── VendorSettlement (1:N)  
│      ├── VendorSettlementItem (1:N)  
│      └── VendorSettlementTransaction (1:N)  
│  
├── VendorCommission (1:N)  
└── VendorEarning (1:N)

Coupon  
│  
└── CouponUsage (1:N)

Customer  
│  
├── Referral (1:N)  
└── LoyaltyPoint (1:1)  
      └── LoyaltyTransaction (1:N)  
---

# **Payment Flow**

Customer  
   │  
   ▼  
Checkout  
   │  
   ▼  
Select Payment Method  
   │  
   ▼  
Payment Gateway  
   │  
   ▼  
Payment Success  
   │  
   ▼  
Order Confirmed  
   │  
   ▼  
Vendor Earnings  
   │  
   ▼  
Platform Commission  
   │  
   ▼  
Vendor Settlement  
   │  
   ▼  
Settlement Paid

# Rider, Delivery, Route & Live Tracking Module

# **Rider**

id  
vendorId  
branchId  
userId  
riderCode  
fullName  
phone  
email  
profileImage  
dateOfBirth  
gender  
nidNumber  
licenseNumber  
licenseExpiryDate  
joiningDate  
employmentType  
status  
isOnline  
isAvailable  
lastActiveAt  
createdAt  
updatedAt  
deletedAt  
---

# **RiderProfile**

id  
riderId  
emergencyContactName  
emergencyContactPhone  
bloodGroup  
address  
city  
postalCode  
profileCompletion  
createdAt  
updatedAt  
---

# **RiderDocument**

id  
riderId  
documentType  
documentNumber  
documentUrl  
verificationStatus  
verifiedBy  
verifiedAt  
expiryDate  
createdAt  
updatedAt  
---

# **RiderVehicle**

id  
riderId  
vehicleType  
brand  
model  
registrationNumber  
color  
insuranceNumber  
insuranceExpiryDate  
status  
createdAt  
updatedAt  
---

# **RiderAvailability**

id  
riderId  
dayOfWeek  
startTime  
endTime  
isAvailable  
createdAt  
updatedAt  
---

# **RiderShift**

id  
riderId  
shiftName  
startTime  
endTime  
status  
createdAt  
updatedAt  
---

# **RiderAttendance**

id  
riderId  
checkIn  
checkOut  
workingHours  
attendanceStatus  
createdAt  
updatedAt  
---

# **RiderLocation**

id  
riderId  
latitude  
longitude  
heading  
speed  
accuracy  
batteryLevel  
locationTime  
createdAt  
---

# **RiderPerformance**

id  
riderId  
totalDeliveries  
completedDeliveries  
cancelledDeliveries  
averageDeliveryTime  
averageRating  
acceptanceRate  
completionRate  
updatedAt  
---

# **RiderRating**

id  
riderId  
customerId  
orderId  
rating  
review  
createdAt  
updatedAt  
---

# **RiderWallet**

id  
riderId  
balance  
holdBalance  
currency  
status  
createdAt  
updatedAt  
---

# **RiderWalletTransaction**

id  
walletId  
transactionType  
amount  
balanceBefore  
balanceAfter  
referenceType  
referenceId  
remarks  
createdAt  
---

# **Delivery**

id  
orderId  
vendorId  
riderId  
deliveryCode  
deliveryType  
deliveryStatus  
priority  
estimatedPickupTime  
estimatedDeliveryTime  
actualPickupTime  
actualDeliveryTime  
deliveryCharge  
createdAt  
updatedAt  
---

# **DeliveryItem**

id  
deliveryId  
orderMealId  
foodId  
quantity  
status  
createdAt  
updatedAt  
---

# **DeliverySchedule**

id  
deliveryId  
deliveryDate  
deliverySlot  
startTime  
endTime  
status  
createdAt  
updatedAt  
---

# **DeliveryStatusHistory**

id  
deliveryId  
previousStatus  
currentStatus  
remarks  
updatedBy  
createdAt

### **Delivery Status**

PENDING  
ASSIGNED  
ACCEPTED  
PICKED\_UP  
ON\_THE\_WAY  
ARRIVED  
DELIVERED  
FAILED  
CANCELLED  
---

# **DeliveryProof**

id  
deliveryId  
proofType  
image  
signature  
otp  
verifiedAt  
createdAt  
---

# **DeliveryAttempt**

id  
deliveryId  
attemptNumber  
reason  
status  
createdAt  
updatedAt  
---

# **Route**

id  
routeCode  
vendorId  
riderId  
routeName  
totalDistance  
estimatedDuration  
status  
createdAt  
updatedAt  
---

# **RouteStop**

id  
routeId  
deliveryId  
customerId  
addressId  
stopNumber  
arrivalTime  
departureTime  
status  
createdAt  
updatedAt  
---

# **RouteOptimization**

id  
routeId  
algorithm  
optimizationScore  
totalDistance  
totalTime  
fuelSaving  
createdAt  
updatedAt  
---

# **RouteTracking**

id  
routeId  
currentLatitude  
currentLongitude  
currentStop  
remainingDistance  
remainingTime  
updatedAt  
---

# **RouteHistory**

id  
routeId  
oldRoute  
newRoute  
changedBy  
reason  
createdAt  
---

# **TrackingSession**

id  
deliveryId  
riderId  
trackingCode  
startedAt  
endedAt  
status  
createdAt  
updatedAt  
---

# **TrackingLocation**

id  
trackingSessionId  
latitude  
longitude  
speed  
heading  
accuracy  
recordedAt  
---

# **TrackingEvent**

id  
trackingSessionId  
event  
description  
latitude  
longitude  
createdAt

### **Event**

STARTED  
PICKUP  
STOP  
BREAK  
RESUMED  
ARRIVED  
DELIVERED  
---

# **TrackingETA**

id  
trackingSessionId  
estimatedArrivalTime  
remainingDistance  
remainingDuration  
trafficStatus  
updatedAt  
---

# **GeoFence**

id  
name  
latitude  
longitude  
radius  
type  
status  
createdAt  
updatedAt  
---

# **RiderNotification**

id  
riderId  
title  
message  
type  
isRead  
createdAt  
---

# **RiderRelationship**

Vendor  
│  
├── Rider (1:N)  
│      │  
│      ├── RiderProfile (1:1)  
│      ├── RiderDocument (1:N)  
│      ├── RiderVehicle (1:1)  
│      ├── RiderAvailability (1:N)  
│      ├── RiderShift (1:N)  
│      ├── RiderAttendance (1:N)  
│      ├── RiderLocation (1:N)  
│      ├── RiderPerformance (1:1)  
│      ├── RiderRating (1:N)  
│      ├── RiderWallet (1:1)  
│      │      └── RiderWalletTransaction (1:N)  
│      └── RiderNotification (1:N)  
│  
├── Delivery (1:N)  
│      ├── DeliveryItem (1:N)  
│      ├── DeliverySchedule (1:N)  
│      ├── DeliveryStatusHistory (1:N)  
│      ├── DeliveryProof (1:1)  
│      └── DeliveryAttempt (1:N)  
│  
├── Route (1:N)  
│      ├── RouteStop (1:N)  
│      ├── RouteOptimization (1:1)  
│      ├── RouteTracking (1:N)  
│      └── RouteHistory (1:N)  
│  
└── TrackingSession (1:N)  
      ├── TrackingLocation (1:N)  
      ├── TrackingEvent (1:N)  
      └── TrackingETA (1:1)  
---

# **Delivery Flow**

Customer  
     │  
     ▼  
Order Confirmed  
     │  
     ▼  
Kitchen Preparing  
     │  
     ▼  
Assign Rider  
     │  
     ▼  
Pickup Food  
     │  
     ▼  
Route Optimization  
     │  
     ▼  
Live Tracking  
     │  
     ▼  
Customer OTP  
     │  
     ▼  
Delivery Completed  
     │  
     ▼  
Rate Rider

# Chat, Notification & Support Module (

# **Conversation**

id  
conversationCode  
conversationType  
title  
createdBy  
status  
lastMessageId  
lastMessageAt  
createdAt  
updatedAt  
deletedAt

### **conversationType**

DIRECT  
GROUP  
SUPPORT  
ORDER  
DELIVERY  
---

# **ConversationParticipant**

id  
conversationId  
userId  
userType  
role  
joinedAt  
leftAt  
isMuted  
isBlocked  
lastSeenMessageId  
createdAt  
updatedAt

### **userType**

Customer  
Support  
Vendor  
VendorStaff  
Rider  
Admin  
---

# **Message**

id  
conversationId  
senderId  
senderType  
messageType  
message  
replyMessageId  
forwardMessageId  
status  
sentAt  
editedAt  
deletedAt  
createdAt  
updatedAt

### **messageType**

TEXT  
IMAGE  
VIDEO  
AUDIO  
DOCUMENT  
LOCATION  
ORDER  
PAYMENT  
SYSTEM  
---

# **MessageAttachment**

id  
messageId  
fileName  
fileType  
fileUrl  
fileSize  
thumbnail  
duration  
createdAt  
updatedAt  
---

# **MessageReaction**

id  
messageId  
userId  
reaction  
createdAt

### **reaction**

LIKE  
LOVE  
HAHA  
WOW  
SAD  
ANGRY  
---

# **MessageRead**

id  
messageId  
userId  
readAt  
---

# **MessageDelete**

id  
messageId  
deletedBy  
deleteType  
deletedAt

### **deleteType**

DELETE\_FOR\_ME  
DELETE\_FOR\_EVERYONE  
---

# **SupportTicket**

id  
ticketNumber  
customerId  
orderId  
categoryId  
subject  
description  
priority  
status  
assignedTo  
closedAt  
createdAt  
updatedAt  
---

# **SupportCategory**

id  
name  
description  
status  
createdAt  
updatedAt

### **Example**

Order Issue  
Payment Issue  
Delivery Issue  
Refund  
Technical Problem  
Other  
---

# **SupportReply**

id  
ticketId  
userId  
message  
attachment  
isInternal  
createdAt  
updatedAt  
---

# **Notification**

id  
userId  
title  
message  
type  
referenceType  
referenceId  
isRead  
readAt  
createdAt  
updatedAt  
---

# **NotificationTemplate**

id  
name  
title  
message  
channel  
variables  
status  
createdAt  
updatedAt  
---

# **PushNotification**

id  
notificationId  
deviceId  
title  
message  
status  
sentAt  
createdAt  
---

# **EmailNotification**

id  
notificationId  
email  
subject  
body  
status  
sentAt  
createdAt  
---

# **SMSNotification**

id  
notificationId  
phone  
message  
provider  
status  
sentAt  
createdAt  
---

# **InAppNotification**

id  
notificationId  
icon  
action  
redirectUrl  
expiresAt  
createdAt  
updatedAt  
---

# **BroadcastNotification**

id  
title  
message  
targetType  
targetId  
scheduledAt  
sentAt  
status  
createdAt  
updatedAt  
---

# **Announcement**

id  
title  
description  
image  
startDate  
endDate  
status  
createdAt  
updatedAt  
---

# **FAQCategory**

id  
name  
icon  
status  
createdAt  
updatedAt  
---

# **FAQ**

id  
categoryId  
question  
answer  
sortOrder  
status  
createdAt  
updatedAt  
---

# **ContactMessage**

id  
name  
email  
phone  
subject  
message  
status  
repliedBy  
createdAt  
updatedAt  
---

# **Relationship**

Conversation  
│  
├── ConversationParticipant (1:N)  
├── Message (1:N)  
│      ├── MessageAttachment (1:N)  
│      ├── MessageReaction (1:N)  
│      ├── MessageRead (1:N)  
│      └── MessageDelete (1:N)  
│  
SupportTicket  
│  
├── SupportCategory (N:1)  
└── SupportReply (1:N)

Notification  
│  
├── NotificationTemplate  
├── PushNotification  
├── EmailNotification  
├── SMSNotification  
├── InAppNotification  
└── BroadcastNotification

FAQCategory  
│  
└── FAQ  
---

# **Chat Flow**

Customer  
     │  
     ▼  
Open Chat  
     │  
     ▼  
Conversation Created  
     │  
     ▼  
Send Message  
     │  
     ▼  
Attachment  
     │  
     ▼  
Read Receipt  
     │  
     ▼  
Support / Rider Reply  
     │  
     ▼  
Conversation Closed  
---

# **Notification Flow**

Order Placed  
     │  
     ▼  
Notification  
     │  
     ├── Push  
     ├── SMS  
     ├── Email  
     └── In-App

# CMS, Analytics, Inventory, Audit & System Settings

# **Banner**

id  
title  
subtitle  
image  
redirectType  
redirectId  
displayOrder  
startDate  
endDate  
status  
createdAt  
updatedAt  
---

# **Slider**

id  
title  
description  
image  
buttonText  
buttonUrl  
displayOrder  
status  
createdAt  
updatedAt  
---

# **Blog**

id  
title  
slug  
thumbnail  
content  
authorId  
categoryId  
status  
publishedAt  
createdAt  
updatedAt  
---

# **BlogCategory**

id  
name  
slug  
description  
status  
createdAt  
updatedAt  
---

# **StaticPage**

id  
title  
slug  
content  
metaTitle  
metaDescription  
status  
createdAt  
updatedAt

### **Example**

About Us

Privacy Policy

Terms & Conditions

Refund Policy

Contact Us  
---

# **Dashboard**

id  
date  
totalUsers  
totalCustomers  
totalVendors  
totalRiders  
totalOrders  
completedOrders  
cancelledOrders  
totalRevenue  
createdAt  
---

# **SalesAnalytics**

id  
date  
totalSales  
grossRevenue  
netRevenue  
commission  
refundAmount  
deliveryCharge  
createdAt  
---

# **CustomerAnalytics**

id  
customerId  
totalOrders  
totalSpent  
averageOrderValue  
lastOrderDate  
favoriteCategory  
favoritePackage  
createdAt  
updatedAt  
---

# **VendorAnalytics**

id  
vendorId  
totalOrders  
completedOrders  
cancelledOrders  
averagePreparationTime  
averageRating  
grossRevenue  
netRevenue  
updatedAt  
---

# **RiderAnalytics**

id  
riderId  
completedDeliveries  
cancelledDeliveries  
averageDeliveryTime  
averageRating  
earnings  
updatedAt  
---

# **PackageAnalytics**

id  
packageId  
totalOrders  
totalRevenue  
averageRating  
activeSubscribers  
updatedAt  
---

# **Inventory**

id  
vendorId  
ingredientName  
category  
unit  
minimumStock  
currentStock  
maximumStock  
status  
createdAt  
updatedAt  
---

# **InventoryTransaction**

id  
inventoryId  
transactionType  
quantity  
remainingQuantity  
referenceType  
referenceId  
remarks  
createdAt

### **transactionType**

IN

OUT

WASTE

ADJUSTMENT  
---

# **Supplier**

id  
vendorId  
companyName  
contactPerson  
phone  
email  
address  
status  
createdAt  
updatedAt  
---

# **Purchase**

id  
supplierId  
vendorId  
purchaseNumber  
purchaseDate  
subtotal  
vat  
discount  
grandTotal  
status  
createdAt  
updatedAt  
---

# **PurchaseItem**

id  
purchaseId  
inventoryId  
quantity  
unitPrice  
totalPrice  
createdAt  
updatedAt  
---

# **WasteLog**

id  
inventoryId  
quantity  
reason  
approvedBy  
createdAt  
---

# **ActivityLog**

id  
userId  
module  
action  
description  
ipAddress  
device  
browser  
createdAt  
---

# **AuditLog**

id  
tableName  
recordId  
oldValue  
newValue  
changedBy  
changedAt  
---

# **LoginLog**

id  
userId  
ipAddress  
device  
browser  
loginAt  
logoutAt  
status  
---

# **ApiLog**

id  
method  
endpoint  
requestBody  
responseBody  
statusCode  
responseTime  
createdAt  
---

# **ErrorLog**

id  
service  
errorCode  
message  
stackTrace  
resolved  
createdAt  
updatedAt  
---

# **SystemSetting**

id  
settingKey  
settingValue  
description  
createdAt  
updatedAt  
---

# **GeneralSetting**

id  
appName  
appLogo  
supportEmail  
supportPhone  
currency  
timezone  
language  
maintenanceMode  
createdAt  
updatedAt  
---

# **PaymentSetting**

id  
gatewayName  
isSandbox  
merchantId  
storeId  
apiKey  
secretKey  
status  
updatedAt  
---

# **DeliverySetting**

id  
minimumDeliveryTime  
maximumDeliveryDistance  
defaultDeliveryCharge  
freeDeliveryAmount  
deliveryRadius  
updatedAt  
---

# **PackageSetting**

id  
minimumOrderDays  
maximumOrderDays  
allowCustomization  
allowPause  
allowSkipMeal  
updatedAt  
---

# **CommissionSetting**

id  
defaultCommissionType  
defaultCommissionRate  
minimumCommission  
maximumCommission  
updatedAt  
---

# **NotificationSetting**

id  
pushEnabled  
smsEnabled  
emailEnabled  
marketingEnabled  
updatedAt  
---

# **FeatureFlag**

id  
featureName  
isEnabled  
description  
createdAt  
updatedAt

### **Example**

Live Tracking

Wallet

Referral

Loyalty

Subscription

AI Route Optimization

Chat  
---

# **Relationship**

CMS  
│  
├── Banner  
├── Slider  
├── BlogCategory  
│      └── Blog  
└── StaticPage

Analytics  
│  
├── Dashboard  
├── SalesAnalytics  
├── CustomerAnalytics  
├── VendorAnalytics  
├── RiderAnalytics  
└── PackageAnalytics

Inventory  
│  
├── Inventory  
├── InventoryTransaction  
├── Supplier  
├── Purchase  
│      └── PurchaseItem  
└── WasteLog

Audit  
│  
├── ActivityLog  
├── AuditLog  
├── LoginLog  
├── ApiLog  
└── ErrorLog

Settings  
│  
├── SystemSetting  
├── GeneralSetting  
├── PaymentSetting  
├── DeliverySetting  
├── PackageSetting  
├── CommissionSetting  
├── NotificationSetting  
└── FeatureFlag

# Subscription & Meal Lifecycle Module

# **Subscription**

id  
subscriptionNumber  
customerId  
packageId  
customMealPlanId  
orderId  
startDate  
endDate  
duration  
status  
autoRenew  
totalAmount  
paidAmount  
remainingAmount  
createdAt  
updatedAt  
---

# **SubscriptionCycle**

id  
subscriptionId  
cycleNumber  
startDate  
endDate  
status  
createdAt  
updatedAt  
---

# **SubscriptionDay**

id  
subscriptionId  
dayNumber  
deliveryDate  
status  
createdAt  
updatedAt  
---

# **SubscriptionMeal**

id  
subscriptionDayId  
mealType  
mealTime  
foodId  
vendorFoodId  
status  
createdAt  
updatedAt  
---

# **SubscriptionDelivery**

id  
subscriptionMealId  
deliveryId  
deliveryStatus  
deliveryDate  
deliverySlot  
createdAt  
updatedAt  
---

# **SubscriptionPause**

id  
subscriptionId  
pauseStartDate  
pauseEndDate  
reason  
approvedBy  
status  
createdAt  
updatedAt  
---

# **SubscriptionResume**

id  
subscriptionId  
resumeDate  
approvedBy  
status  
createdAt  
updatedAt  
---

# **SubscriptionSkipMeal**

id  
subscriptionMealId  
skipDate  
reason  
replacementMealId  
status  
createdAt  
updatedAt  
---

# **SubscriptionRenewal**

id  
subscriptionId  
oldEndDate  
newEndDate  
renewalAmount  
paymentId  
status  
createdAt  
updatedAt  
---

# **SubscriptionFreeze**

id  
subscriptionId  
freezeStartDate  
freezeEndDate  
reason  
status  
createdAt  
updatedAt  
---

# **SubscriptionUpgrade**

id  
subscriptionId  
oldPackageId  
newPackageId  
priceDifference  
paymentId  
status  
createdAt  
updatedAt  
---

# **SubscriptionDowngrade**

id  
subscriptionId  
oldPackageId  
newPackageId  
refundAmount  
status  
createdAt  
updatedAt  
---

# **SubscriptionHistory**

id  
subscriptionId  
action  
performedBy  
remarks  
createdAt  
---

# **SubscriptionStatusHistory**

id  
subscriptionId  
oldStatus  
newStatus  
changedBy  
createdAt  
---

### **Subscription Status**

PENDING

ACTIVE

PAUSED

FROZEN

COMPLETED

EXPIRED

CANCELLED  
---

# **MealReplacement**

id  
subscriptionMealId  
oldFoodId  
newFoodId  
reason  
additionalPrice  
approvedBy  
createdAt  
updatedAt  
---

# **MealFeedback**

id  
subscriptionMealId  
customerId  
rating  
review  
image  
createdAt  
updatedAt  
---

# **MealIssue**

id  
subscriptionMealId  
issueType  
description  
attachment  
status  
resolvedBy  
resolvedAt  
createdAt  
updatedAt

### **issueType**

Missing Item

Cold Food

Wrong Food

Late Delivery

Packaging Issue

Quality Issue  
---

# **SubscriptionInvoice**

id  
subscriptionId  
invoiceNumber  
paymentId  
invoiceDate  
subtotal  
discount  
vat  
total  
createdAt  
updatedAt  
---

# **SubscriptionReminder**

id  
subscriptionId  
type  
title  
message  
sendAt  
status  
createdAt  
updatedAt

### **Reminder Type**

Renewal

Delivery

Payment

Pause Ending

Subscription Ending  
---

# **Relationship**

Subscription  
│  
├── SubscriptionCycle (1:N)  
├── SubscriptionDay (1:N)  
│      │  
│      └── SubscriptionMeal (1:N)  
│              │  
│              ├── SubscriptionDelivery (1:1)  
│              ├── SubscriptionSkipMeal (0:N)  
│              ├── MealReplacement (0:N)  
│              ├── MealFeedback (0:1)  
│              └── MealIssue (0:N)  
│  
├── SubscriptionPause (1:N)  
├── SubscriptionResume (1:N)  
├── SubscriptionRenewal (1:N)  
├── SubscriptionFreeze (1:N)  
├── SubscriptionUpgrade (1:N)  
├── SubscriptionDowngrade (1:N)  
├── SubscriptionHistory (1:N)  
├── SubscriptionStatusHistory (1:N)  
├── SubscriptionInvoice (1:N)  
└── SubscriptionReminder (1:N)  
---

# **Subscription Flow**

Customer  
     │  
     ▼  
Purchase Package  
     │  
     ▼  
Subscription Created  
     │  
     ▼  
Generate Daily Meals  
     │  
     ▼  
Kitchen Preparation  
     │  
     ▼  
Delivery  
     │  
     ▼  
Pause / Skip / Replace  
     │  
     ▼  
Renew Subscription  
     │  
     ▼  
Complete

# Marketing, Campaign, Referral & Loyalty Module

# **Campaign**

id  
campaignCode  
name  
title  
description  
campaignType  
startDate  
endDate  
budget  
status  
createdBy  
createdAt  
updatedAt

### **campaignType**

DISCOUNT

REFERRAL

SEASONAL

FLASH\_SALE

FREE\_DELIVERY

CASHBACK  
---

# **CampaignTarget**

id  
campaignId  
targetType  
targetId  
createdAt  
updatedAt

### **targetType**

ALL\_USERS

NEW\_USERS

EXISTING\_USERS

PREMIUM\_USERS

SPECIFIC\_AREA

SPECIFIC\_PACKAGE  
---

# **CampaignBanner**

id  
campaignId  
title  
image  
redirectType  
redirectId  
displayOrder  
createdAt  
updatedAt  
---

# **PromoCode**

id  
campaignId  
code  
discountType  
discountValue  
minimumOrder  
maximumDiscount  
usageLimit  
perUserLimit  
startDate  
endDate  
status  
createdAt  
updatedAt  
---

# **PromoCodeUsage**

id  
promoCodeId  
customerId  
orderId  
discountAmount  
usedAt  
---

# **CashbackRule**

id  
campaignId  
minimumAmount  
cashbackType  
cashbackValue  
maximumCashback  
walletExpireDate  
createdAt  
updatedAt  
---

# **CashbackTransaction**

id  
customerId  
walletId  
campaignId  
orderId  
amount  
status  
creditedAt  
createdAt  
---

# **ReferralProgram**

id  
name  
referralBonus  
referrerBonus  
minimumOrder  
maximumReward  
status  
createdAt  
updatedAt  
---

# **Referral**

id  
programId  
referrerId  
referredUserId  
referralCode  
status  
completedAt  
createdAt  
updatedAt  
---

# **ReferralReward**

id  
referralId  
rewardType  
rewardAmount  
walletTransactionId  
status  
createdAt  
updatedAt  
---

# **LoyaltyProgram**

id  
name  
earnRate  
redeemRate  
minimumRedeemPoint  
maximumRedeemPoint  
status  
createdAt  
updatedAt  
---

# **LoyaltyPoint**

id  
customerId  
earnedPoint  
redeemedPoint  
expiredPoint  
availablePoint  
lastCalculatedAt  
createdAt  
updatedAt  
---

# **LoyaltyTransaction**

id  
loyaltyPointId  
transactionType  
points  
referenceType  
referenceId  
remarks  
createdAt  
---

# **LoyaltyReward**

id  
name  
requiredPoint  
rewardType  
rewardValue  
status  
createdAt  
updatedAt  
---

# **GiftVoucher**

id  
voucherCode  
title  
amount  
expiryDate  
status  
createdAt  
updatedAt  
---

# **GiftVoucherUsage**

id  
voucherId  
customerId  
orderId  
usedAmount  
usedAt  
---

# **PushCampaign**

id  
campaignId  
title  
message  
targetAudience  
scheduledAt  
sentAt  
status  
createdAt  
updatedAt  
---

# **EmailCampaign**

id  
campaignId  
subject  
body  
targetAudience  
scheduledAt  
sentAt  
status  
createdAt  
updatedAt  
---

# **SMSCampaign**

id  
campaignId  
message  
targetAudience  
scheduledAt  
sentAt  
status  
createdAt  
updatedAt  
---

# **InAppCampaign**

id  
campaignId  
title  
message  
image  
actionUrl  
scheduledAt  
expiresAt  
status  
createdAt  
updatedAt  
---

# **MarketingAnalytics**

id  
campaignId  
totalAudience  
totalSent  
totalOpened  
totalClicked  
totalConverted  
conversionRate  
revenueGenerated  
createdAt  
updatedAt  
---

# **CustomerSegment**

id  
name  
description  
conditions  
status  
createdAt  
updatedAt

### **Example**

New Customer

Active Customer

Inactive Customer

VIP Customer

Premium Customer

Office User

Gym User  
---

# **Relationship**

Campaign  
│  
├── CampaignTarget  
├── CampaignBanner  
├── PromoCode  
│      └── PromoCodeUsage  
├── CashbackRule  
│      └── CashbackTransaction  
├── PushCampaign  
├── EmailCampaign  
├── SMSCampaign  
├── InAppCampaign  
└── MarketingAnalytics

ReferralProgram  
│  
├── Referral  
│      └── ReferralReward

LoyaltyProgram  
│  
├── LoyaltyPoint  
│      ├── LoyaltyTransaction  
│      └── LoyaltyReward

GiftVoucher  
│  
└── GiftVoucherUsage

CustomerSegment  
---

# **Marketing Flow**

Admin  
     │  
     ▼  
Create Campaign  
     │  
     ▼  
Assign Customer Segment  
     │  
     ▼  
Generate Promo Code  
     │  
     ▼  
Push / Email / SMS  
     │  
     ▼  
Customer Uses Promotion  
     │  
     ▼  
Order Completed  
     │  
     ▼  
Cashback / Loyalty Earned  
     │  
     ▼  
Analytics Updated

# Reports, Business Intelligence (BI) & Data Wareh

# **Report**

id  
reportCode  
name  
reportType  
generatedBy  
generatedAt  
status  
fileUrl  
createdAt  
updatedAt  
---

# **ReportTemplate**

id  
name  
reportType  
description  
filters  
columns  
chartType  
status  
createdAt  
updatedAt  
---

# **ReportSchedule**

id  
reportTemplateId  
frequency  
nextRun  
lastRun  
emailTo  
status  
createdAt  
updatedAt  
---

# **ReportExport**

id  
reportId  
exportType  
fileName  
fileUrl  
generatedBy  
createdAt

### **exportType**

PDF

EXCEL

CSV

JSON  
---

# **SalesReport**

id  
reportDate  
totalOrders  
completedOrders  
cancelledOrders  
grossSales  
netSales  
discountAmount  
refundAmount  
deliveryCharge  
vat  
createdAt  
updatedAt  
---

# **RevenueReport**

id  
reportDate  
grossRevenue  
vendorRevenue  
platformRevenue  
commissionRevenue  
walletRevenue  
subscriptionRevenue  
createdAt  
updatedAt  
---

# **FinanceReport**

id  
reportDate  
income  
expense  
profit  
tax  
refund  
settlement  
netProfit  
createdAt  
updatedAt  
---

# **SubscriptionReport**

id  
reportDate  
newSubscriptions  
activeSubscriptions  
pausedSubscriptions  
expiredSubscriptions  
renewedSubscriptions  
cancelledSubscriptions  
createdAt  
updatedAt  
---

# **CustomerReport**

id  
customerId  
totalOrders  
totalSpent  
averageOrderValue  
subscriptionCount  
lastOrderDate  
lifetimeValue  
createdAt  
updatedAt  
---

# **VendorReport**

id  
vendorId  
totalOrders  
completedOrders  
cancelledOrders  
grossRevenue  
netRevenue  
commission  
settlementAmount  
averageRating  
createdAt  
updatedAt  
---

# **RiderReport**

id  
riderId  
totalDeliveries  
completedDeliveries  
failedDeliveries  
averageDeliveryTime  
averageRating  
earnings  
createdAt  
updatedAt  
---

# **DeliveryReport**

id  
reportDate  
totalDeliveries  
successfulDeliveries  
failedDeliveries  
averageDeliveryTime  
lateDeliveries  
createdAt  
updatedAt  
---

# **PaymentReport**

id  
reportDate  
totalPayments  
successfulPayments  
failedPayments  
refundPayments  
walletPayments  
gatewayPayments  
createdAt  
updatedAt  
---

# **TaxReport**

id  
reportDate  
taxCollected  
vatCollected  
serviceTax  
taxPaid  
createdAt  
updatedAt  
---

# **InventoryReport**

id  
vendorId  
totalItems  
lowStockItems  
outOfStockItems  
wasteAmount  
purchaseAmount  
createdAt  
updatedAt  
---

# **MarketingReport**

id  
campaignId  
impressions  
clicks  
conversions  
conversionRate  
revenue  
createdAt  
updatedAt  
---

# **CouponReport**

id  
couponId  
totalUsed  
discountAmount  
revenueGenerated  
createdAt  
updatedAt  
---

# **RefundReport**

id  
reportDate  
totalRefund  
refundCount  
refundReason  
createdAt  
updatedAt  
---

# **KPI**

id  
name  
code  
value  
target  
percentage  
reportDate  
createdAt  
updatedAt

### **Example KPI**

Daily Revenue

Monthly Revenue

Average Order Value

Customer Retention

Customer Lifetime Value

Delivery Success Rate

Vendor Performance

Rider Performance  
---

# **DashboardWidget**

id  
name  
widgetType  
position  
configuration  
status  
createdAt  
updatedAt  
---

# **DashboardLayout**

id  
userId  
layout  
theme  
createdAt  
updatedAt  
---

# **DataWarehouseJob**

id  
jobName  
source  
destination  
status  
startedAt  
completedAt  
createdAt  
updatedAt  
---

# **ETLLog**

id  
jobId  
recordsProcessed  
successCount  
failedCount  
duration  
status  
createdAt  
---

# **DataSnapshot**

id  
snapshotDate  
tableName  
recordCount  
storageSize  
createdAt  
---

# **AuditReport**

id  
generatedBy  
startDate  
endDate  
activityCount  
createdAt  
---

# **Relationship**

Report  
│  
├── ReportTemplate  
├── ReportSchedule  
├── ReportExport  
│  
├── SalesReport  
├── RevenueReport  
├── FinanceReport  
├── SubscriptionReport  
├── CustomerReport  
├── VendorReport  
├── RiderReport  
├── DeliveryReport  
├── PaymentReport  
├── TaxReport  
├── InventoryReport  
├── MarketingReport  
├── CouponReport  
├── RefundReport  
├── KPI  
├── DashboardWidget  
├── DashboardLayout  
├── DataWarehouseJob  
├── ETLLog  
├── DataSnapshot  
└── AuditReport  
---

# **BI Reporting Flow**

Database  
     │  
     ▼  
ETL Process  
     │  
     ▼  
Data Warehouse  
     │  
     ▼  
Analytics Engine  
     │  
     ▼  
Dashboard  
     │  
     ▼  
Reports  
     │  
     ├── PDF  
     ├── Excel  
     ├── CSV  
     └── JSON

# Infrastructure, DevOps & System Operations Module

# **ApiClient**

id  
clientName  
clientId  
clientSecret  
clientType  
redirectUrl  
allowedOrigin  
status  
createdAt  
updatedAt  
---

# **ApiKey**

id  
clientId  
apiKey  
secretKey  
expiresAt  
lastUsedAt  
status  
createdAt  
updatedAt  
---

# **ApiToken**

id  
userId  
clientId  
accessToken  
refreshToken  
expiresAt  
revokedAt  
createdAt  
updatedAt  
---

# **ApiRateLimit**

id  
clientId  
requestsPerMinute  
requestsPerHour  
requestsPerDay  
blockedUntil  
createdAt  
updatedAt  
---

# **Webhook**

id  
name  
event  
url  
secret  
httpMethod  
status  
createdAt  
updatedAt  
---

# **WebhookDelivery**

id  
webhookId  
payload  
response  
status  
attemptCount  
lastAttemptAt  
createdAt  
updatedAt  
---

# **Queue**

id  
queueName  
queueType  
status  
createdAt  
updatedAt  
---

# **QueueJob**

id  
queueId  
jobName  
payload  
priority  
status  
attempts  
startedAt  
completedAt  
failedReason  
createdAt  
updatedAt  
---

# **ScheduledJob**

id  
jobName  
cronExpression  
nextRun  
lastRun  
status  
createdAt  
updatedAt  
---

# **BackgroundTask**

id  
taskName  
referenceType  
referenceId  
status  
startedAt  
completedAt  
createdAt  
updatedAt  
---

# **Cache**

id  
cacheKey  
cacheGroup  
expiresAt  
createdAt  
updatedAt  
---

# **FileStorage**

id  
storageProvider  
bucketName  
region  
baseUrl  
status  
createdAt  
updatedAt  
---

# **Media**

id  
fileName  
originalName  
mimeType  
extension  
size  
path  
url  
uploadedBy  
storageId  
createdAt  
updatedAt  
---

# **MediaFolder**

id  
name  
parentId  
createdBy  
createdAt  
updatedAt  
---

# **MediaVersion**

id  
mediaId  
version  
path  
size  
createdAt  
---

# **Device**

id  
userId  
deviceId  
deviceName  
deviceType  
platform  
osVersion  
appVersion  
pushToken  
lastLogin  
status  
createdAt  
updatedAt  
---

# **Session**

id  
userId  
deviceId  
ipAddress  
browser  
location  
loginAt  
logoutAt  
status  
createdAt  
updatedAt  
---

# **Environment**

id  
environment  
key  
value  
description  
createdAt  
updatedAt  
---

# **ServiceHealth**

id  
serviceName  
status  
cpuUsage  
memoryUsage  
diskUsage  
uptime  
checkedAt  
---

# **MonitoringMetric**

id  
serviceName  
metricName  
metricValue  
unit  
recordedAt  
---

# **AlertRule**

id  
serviceName  
metric  
condition  
threshold  
severity  
status  
createdAt  
updatedAt  
---

# **Alert**

id  
alertRuleId  
title  
description  
severity  
resolved  
resolvedAt  
createdAt  
---

# **Deployment**

id  
version  
environment  
branch  
commitHash  
deployedBy  
startedAt  
completedAt  
status  
---

# **DatabaseMigration**

id  
version  
migrationName  
executedAt  
status  
---

# **Backup**

id  
backupType  
storageLocation  
fileSize  
status  
startedAt  
completedAt  
createdAt  
---

# **Restore**

id  
backupId  
restoredBy  
status  
startedAt  
completedAt  
createdAt  
---

# **FeatureToggle**

id  
featureName  
description  
enabled  
environment  
createdAt  
updatedAt  
---

# **MaintenanceMode**

id  
enabled  
message  
startTime  
endTime  
enabledBy  
createdAt  
updatedAt  
---

# **SecurityAudit**

id  
event  
userId  
ipAddress  
device  
riskLevel  
description  
createdAt  
---

# **Relationship**

Infrastructure  
│  
├── ApiClient  
│      ├── ApiKey  
│      ├── ApiToken  
│      └── ApiRateLimit  
│  
├── Webhook  
│      └── WebhookDelivery  
│  
├── Queue  
│      └── QueueJob  
│  
├── ScheduledJob  
├── BackgroundTask  
│  
├── FileStorage  
│      ├── Media  
│      │      └── MediaVersion  
│      └── MediaFolder  
│  
├── Device  
│      └── Session  
│  
├── Environment  
│  
├── ServiceHealth  
├── MonitoringMetric  
├── AlertRule  
│      └── Alert  
│  
├── Deployment  
├── DatabaseMigration  
├── Backup  
├── Restore  
├── FeatureToggle  
├── MaintenanceMode  
└── SecurityAudit  
---

# **DevOps Flow**

Developer  
     │  
     ▼  
Git Push  
     │  
     ▼  
CI/CD Pipeline  
     │  
     ▼  
Run Tests  
     │  
     ▼  
Database Migration  
     │  
     ▼  
Deploy Application  
     │  
     ▼  
Health Check  
     │  
     ▼  
Monitoring  
     │  
     ▼  
Alert  
     │  
     ▼  
Backup  
