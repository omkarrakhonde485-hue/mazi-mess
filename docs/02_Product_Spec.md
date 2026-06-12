# 02_Product_Spec.md

# MAZI MESS - PRODUCT SPECIFICATION V1

Version: 1.0

Status: Draft Approved

Launch Region:
Chhatrapati Sambhajinagar, Maharashtra, India

Platform:
Android

Languages:
English
Marathi
Hindi

---

# 1. PRODUCT OVERVIEW

Mazi Mess is a mess discovery and management platform designed to connect customers looking for mess services with mess owners who want better customer management and customer acquisition.

The platform solves two major problems:

For Customers:

* Difficulty finding nearby messes.
* Lack of reliable reviews.
* No standardized way to compare plans.
* Difficulty discovering verified messes.

For Mess Owners:

* Difficulty acquiring new customers.
* Poor customer record management.
* Manual attendance tracking.
* Manual subscription tracking.
* No centralized customer management system.

Mazi Mess acts as a platform between customers and mess owners.

Customer payments go directly to the mess owner's account.

Mazi Mess does not hold customer funds.

---

# 2. PRODUCT VISION

Create the largest mess discovery and management platform in Maharashtra.

Initial focus:

* Chhatrapati Sambhajinagar

Future expansion:

* Nagpur
* Pune
* Nashik
* Mumbai
* Entire Maharashtra

---

# 3. USER TYPES

The platform supports three user roles.

## Customer

A person looking for mess services.

Can:

* Discover messes
* Compare plans
* Join messes
* Manage subscriptions
* Mark leave dates
* Generate attendance QR
* Review messes
* Submit feedback

---

## Owner

A person operating one or more messes.

Can:

* Register messes
* Create plans
* Approve customers
* Manage subscriptions
* Track attendance
* Create notices
* Manage customer records
* View analytics

---

## Admin

Platform administrator.

Can:

* Approve owners
* Approve messes
* Suspend users
* Moderate reviews
* Monitor payments
* Manage platform settings

---

# 4. CORE FEATURES

## Mess Discovery

Customers can:

* Search messes
* View ratings
* Compare plans
* View location
* View reviews
* View photos

Default sorting:

Distance

Supported filters:

* Veg
* Non-Veg
* Both
* Rating

---

## Join Requests

Customers may join a mess by:

* Searching the mess
* Entering Mess ID
* Scanning Join QR

Join requests require owner approval.

---

## Subscription Management

Owners create subscription plans.

Customers subscribe to plans.

Each subscription is independent.

A customer may hold multiple subscriptions simultaneously.

Example:

Lunch Plan

Dinner Plan

Subscriptions can be renewed.

Renewals create new subscriptions.

---

## Attendance Tracking

Attendance is meal-based.

Supported meals:

* Breakfast
* Lunch
* Dinner

Attendance uses QR verification.

Customer generates QR.

Owner scans QR.

Single-use QR only.

QR refreshes every minute.

---

## Leave Management

Customers may mark future leave dates.

Rules:

* Must be submitted at least 2 days in advance.
* Locked 2 days before leave date.
* Stored per subscription.
* Leave disables attendance QR generation.

Purpose:

Improve expected meal calculations.

Reduce food waste.

---

## Reviews & Feedback

Public Reviews:

* Rating
* Public Comment

Private Feedback:

* Visible only to owner and admin

Review eligibility:

* Minimum 30 subscription days
* Minimum 20 attendance records

Owners may reply.

---

## Notices

Owners may create notices.

Categories:

* General
* Holiday
* Menu Change
* Payment Reminder
* Emergency

Only active customers receive notices.

---

# 5. MULTI-MESS OWNERSHIP

Owners may manage multiple messes using a single account.

Example:

Owner Account

* Sai Mess
* Annapurna Mess
* Shree Mess

Each mess maintains independent:

* Customers
* Plans
* Reviews
* Attendance
* Analytics

---

# 6. PAYMENT MODEL

Customer payments go directly to the owner.

Supported method:

UPI

No payment gateway in V1.

Payment verification is performed through:

Paytm Business Email
→ Gmail
→ Make.com
→ Webhook
→ Backend Verification

Subscription activation occurs only after payment verification.

---

# 7. ATTENDANCE MODEL

Attendance is recorded per subscription.

Attendance statuses:

* Present
* Leave

Absent is calculated.

It is not stored.

Attendance records are immutable.

Only admins may perform corrections.

---

# 8. REVIEW MODEL

One review per customer per mess.

Reviews display:

* Rating
* Review Text
* Owner Reply

Reviewer Identity:

First Name + Initial

Example:

Omkar R.

Private feedback remains hidden from other customers.

---

# 9. OWNER OPERATIONS

Owners can:

* Manage plans
* Approve customers
* Reject customers
* Extend subscriptions
* Blacklist customers
* Add private notes
* Manage notices
* View analytics

Owners cannot:

* Modify attendance
* Verify payments
* Delete audit logs

---

# 10. ADMIN OPERATIONS

Admins can:

* Approve owners
* Approve messes
* Suspend users
* Override attendance
* Verify payments
* Remove reviews
* Remove feedback
* Manage featured listings
* Access audit logs

---

# 11. NOTIFICATIONS

Customers receive:

* Join Approval
* Join Rejection
* Subscription Expiry Reminder
* Subscription Activation
* Payment Verification
* New Notice
* Review Reply
* Feedback Reply

Owners receive:

* New Join Request
* New Review
* New Feedback
* New Leave Request
* Owner Subscription Expiry

---

# 12. LOCALIZATION

Supported Languages:

* English
* Marathi
* Hindi

Language preference stored per user.

---

# 13. THEME

Supported Themes:

* Light
* Dark
* System

Design Style:

* Material 3
* Utility Focused
* Simple Navigation
* No Glassmorphism
* No Heavy Animations

---

# 14. OFFLINE SUPPORT

Cached:

* Mess Listings
* Notices
* User Profile

Not Cached:

* Payments
* QR Codes
* Attendance Actions

---

# 15. NON-GOALS (V1)

The following are intentionally excluded from Version 1:

* Payment Gateway Integration
* Wallet System
* Refund System
* Customer-to-Customer Messaging
* Meal Ordering Marketplace
* Staff Accounts
* Web Application
* AI Recommendations
* Automated Owner Verification

---

# 16. LAUNCH TARGET

Phase 1 Pilot:

5 Mess Owners

100 Existing Customers

Launch City:

Chhatrapati Sambhajinagar

Success Criteria:

* Working discovery system
* Working subscriptions
* Working attendance
* Working payment verification
* Successful pilot onboarding

---

# 17. PRODUCT PRINCIPLES

1. Simplicity over complexity.
2. Utility over visual effects.
3. Owners are primary paying customers.
4. Customer trust is critical.
5. Payments must be verifiable.
6. Attendance must be reliable.
7. Every important action must be auditable.
8. The platform must remain scalable across Maharashtra.
