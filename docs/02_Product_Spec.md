# MAZI MESS - PRODUCT SPECIFICATION

Version: 1.1

Status: Production Ready

Launch Region:
Chhatrapati Sambhajinagar, Maharashtra, India

Platform:
Android

Supported Languages:
- English
- Marathi
- Hindi

---

# 1. PRODUCT OVERVIEW

Mazi Mess is a mess discovery and management platform designed to connect customers searching for reliable mess services with mess owners who require a modern customer management system.

The platform solves two major problems.

## For Customers

- Discover nearby verified messes.
- Compare subscription plans.
- View authentic customer reviews.
- Join messes digitally.
- Manage subscriptions.
- Track attendance.
- Receive important notices.
- Mark planned leaves.
- Pay mess owners directly.

## For Mess Owners

- Acquire new customers.
- Manage multiple messes from one account.
- Digitally manage customers.
- Create subscription plans.
- Track attendance.
- Manage notices.
- View business analytics.
- Reduce manual record keeping.

Mazi Mess acts only as a technology platform connecting customers and mess owners.

Customer payments are made directly to the respective mess owner's account.

Mazi Mess never holds customer funds.

---

# 2. PRODUCT VISION

To become Maharashtra's largest and most trusted mess discovery and management platform.

Initial Launch City:

- Chhatrapati Sambhajinagar

Future Expansion:

- Nagpur
- Pune
- Nashik
- Mumbai
- Entire Maharashtra

---

# 3. USER ROLES

The platform supports three primary user roles.

## Customer

A customer searching for mess services.

Customers can:

- Discover nearby messes
- Search by Mess ID
- Join messes
- Compare subscription plans
- Manage active subscriptions
- Generate attendance QR codes
- Mark leave dates
- Review messes
- Submit private feedback
- Receive notices
- Track payment status
- View attendance history

---

## Owner

A mess owner operating one or more messes.

Owners can:

- Register new messes
- Create subscription plans
- Approve join requests
- Manage customers
- Track attendance
- Manage leave requests
- Create notices
- View analytics
- Manage subscriptions
- Blacklist customers
- Maintain private customer notes

Owners cannot:

- View webhook URLs
- View Make.com credentials
- View verification Gmail accounts
- Change payment verification infrastructure
- Override payment verification
- Modify historical attendance records

---

## Admin

Platform administrator.

Admins have complete platform access.

Admins can:

- Approve owners
- Approve messes
- Suspend owners
- Suspend messes
- Monitor payment verification
- Configure webhook integrations
- Configure platform settings
- Manage business analytics
- Override payment verification
- Retry payment verification
- Access audit logs
- Moderate reviews
- Remove feedback
- Manage featured listings
- Configure maintenance mode

---

# 4. CORE FEATURES

## 4.1 Mess Discovery

Customers can discover messes through:

- Search
- Filters
- Nearby listings
- Featured listings
- Mess ID
- Join QR

Each listing displays:

- Mess Name
- Rating
- Distance
- Location
- Meal Type
- Photos
- Capacity
- Available Plans

Supported Filters:

- Veg
- Non-Veg
- Both
- Rating

Default Sorting:

Distance

---

## 4.2 Join Requests

Customers may join a mess using:

- Search
- Mess ID
- Join QR

Every join request requires owner approval.

Possible request states:

- Pending
- Approved
- Rejected

Only approved customers may purchase subscriptions.

---

## 4.3 Subscription Management

Owners create subscription plans.

Customers subscribe to plans.

Each subscription is completely independent.

A customer may hold multiple active subscriptions simultaneously.

Example:

Breakfast Plan

Lunch Plan

Dinner Plan

or

Full-Day Plan

Renewals create new subscription periods.

Subscription activation occurs only after successful payment verification.

Subscriptions maintain independent:

- Attendance
- Leave records
- Expiry dates
- Payment history

---

## 4.4 Plan Management

Every mess may create multiple subscription plans.

Each plan contains:

- Plan Name
- Price
- Duration
- Included Meals
- Custom Notes
- Status

Plan Status:

- Active
- Inactive

Inactive plans:

- Cannot accept new subscribers.
- Existing subscribers continue until expiry.
- Cannot be renewed by existing customers.

Meal combinations are fully configurable.

Examples:

- Breakfast Only
- Lunch Only
- Dinner Only
- Breakfast + Lunch
- Lunch + Dinner
- Breakfast + Dinner
- Full Day

Owners may configure any valid meal combination.

Subscriber count is shown only for active plans.

---

# 5. MULTI-MESS OWNERSHIP

A single Owner account may manage one or more messes.

Example:

Owner Account

├── Annapurna Mess
├── Sai Mess
└── Shree Mess

Each mess operates independently.

Each mess maintains its own:

- Customers
- Subscription Plans
- Attendance Records
- Leave Records
- Reviews
- Notices
- Analytics
- Payment Verification Infrastructure

Customers subscribe to a specific mess.

Customer data is never shared between different messes.

This architecture enables owners to expand their business while maintaining complete separation between individual mess operations.

---

# 6. PAYMENT MODEL

## Customer Payments

Customers pay subscription fees directly to the respective Mess Owner.

Supported payment method in Version 1:

- UPI

Mazi Mess does not collect, hold, process or settle customer payments.

There is no payment gateway in Version 1.

---

## Payment Verification Architecture

Payment verification is automated.

Every approved mess receives its own dedicated payment verification infrastructure.

Per Mess:

Dedicated Paytm Business Account

↓

Dedicated Gmail Account

↓

Dedicated Make.com Account

↓

Dedicated Make Scenario

↓

Dedicated Webhook

↓

Backend Verification

↓

Subscription Activation

Each mess has:

- One dedicated verification Gmail
- One dedicated Make account
- One dedicated Make scenario
- One dedicated Webhook URL

This infrastructure is completely isolated from every other mess.

---

## Administration

Only Admins may:

- Configure verification Gmail
- Configure Make account
- Configure Make password
- Configure Webhook URL
- Activate integrations
- Deactivate integrations
- Retry failed verification
- Perform manual payment verification
- Override payment verification status

Owners never have access to:

- Verification Gmail credentials
- Make account credentials
- Webhook URLs

Owners only see the final payment verification result.

---

## Subscription Activation

Subscription activation occurs only after successful payment verification.

Possible verification states:

- Pending
- Verified
- Failed
- Manual Override
- Retry Required

Failed verification never activates a subscription automatically.

---

# 7. ATTENDANCE MODEL

Attendance is recorded separately for every subscription.

Attendance is meal-based.

Supported meals:

- Breakfast
- Lunch
- Dinner

Attendance records are immutable.

Historical attendance cannot be edited by owners.

Only Admins may perform attendance corrections.

---

## QR Attendance

Primary attendance flow:

Customer

↓

Generate Dynamic QR

↓

Owner Scans QR

↓

Attendance Recorded

QR Rules:

- Single-use QR
- Automatically expires
- Refreshes every minute
- Valid only for active subscriptions
- Valid only for the current meal
- Cannot be reused

---

## Manual Attendance

If QR attendance cannot be completed:

Owner

↓

Manual Attendance Request

↓

Customer Approval Request

↓

Customer Approves

↓

Attendance Recorded

Manual attendance requires customer approval.

This prevents attendance from being marked without the customer actually being served.

---

## Automatic Meal Detection

During manual attendance:

The system automatically detects the current meal based on:

- Current time
- Customer's active subscription
- Meals included in the subscribed plan

Example:

Customer has:

Breakfast + Dinner Plan

Current time:

8:15 PM

Automatically selected meal:

Dinner

The Owner may change the selected meal only when required.

---

## Attendance States

Attendance may be:

- Present
- Leave

Absent is never stored.

Absence is calculated automatically.

---

# 8. LEAVE MANAGEMENT

Customers may mark future leave dates.

Rules:

- Leave must be submitted at least 2 days in advance.
- Leave becomes locked 2 days before the selected date.
- Leave is recorded separately for each subscription.
- Leave disables QR generation for the selected meal.
- Leave is considered during expected meal calculation.

Example:

Customer has:

Lunch Plan

Dinner Plan

Customer may mark leave only for Lunch while continuing Dinner attendance.

Purpose:

- Improve meal forecasting
- Reduce food waste
- Improve owner planning

---

# 9. REVIEWS & FEEDBACK

Every customer may submit one public review per mess.

Review contains:

- Rating
- Public Review
- Owner Reply

Reviewer identity is partially hidden.

Example:

Omkar R.

---

## Review Eligibility

Customer must satisfy all conditions:

- Minimum 30 subscription days
- Minimum 20 attendance records

Only eligible customers may submit reviews.

---

## Private Feedback

Customers may submit private feedback.

Private feedback is visible only to:

- Owner
- Admin

Private feedback never appears publicly.

Owners may respond privately.

---

# 10. NOTICES

Owners may publish notices.

Categories:

- General
- Holiday
- Menu Change
- Payment Reminder
- Emergency

Only active customers receive notices.

Expired customers do not receive new notices.

Notice delivery generates customer notifications.

Future versions may support scheduled notices.

---

# 11. OWNER OPERATIONS

Owners manage the day-to-day operations of their mess.

Owners can:

- Register new messes
- Edit mess information
- Create subscription plans
- Activate or deactivate plans
- Approve join requests
- Reject join requests
- Manage customers
- Extend subscriptions
- Record attendance
- Initiate manual attendance requests
- Manage leave records
- Create notices
- Reply to reviews
- Reply to private feedback
- Blacklist customers
- Add private customer notes
- View payment verification status
- View business analytics
- Manage their own owner profile

---

## Owner Restrictions

Owners cannot:

- Access webhook URLs
- Access verification Gmail accounts
- Access Make account credentials
- Modify payment verification settings
- Manually verify payments
- Override failed payments
- Modify historical attendance
- Delete audit logs
- Access platform settings
- Approve owners
- Approve messes
- Moderate platform-wide reviews

---

# 12. ADMIN OPERATIONS

Admins manage the complete Mazi Mess platform.

Admins can:

- Approve owners
- Reject owners
- Suspend owners
- Reactivate owners

- Approve messes
- Reject messes
- Suspend messes
- Reactivate messes

- Configure webhook integrations

- Configure verification Gmail accounts

- Configure Make accounts

- Configure Make account passwords

- Configure Webhook URLs

- Activate integrations

- Deactivate integrations

- Monitor payment verification

- Retry payment verification

- Perform manual payment verification

- Override payment status

- Access payment audit logs

- View Business Analytics

- Configure Global Settings

- Manage featured listings

- Moderate public reviews

- Remove reviews

- Remove private feedback

- Override attendance

- Access audit logs

- Enable Maintenance Mode

Admins have unrestricted platform access.

---

# 13. NOTIFICATIONS

Notifications are role-based.

---

## Customer Notifications

Customers receive notifications for:

- Join Request Approved
- Join Request Rejected
- Subscription Activated
- Subscription Expiring Soon
- Subscription Expired
- Payment Verified
- Payment Failed
- Manual Attendance Approval Request
- Attendance Approved
- Attendance Rejected
- New Notice
- Review Reply
- Feedback Reply
- Platform Announcements

---

## Owner Notifications

Owners receive notifications for:

- New Join Request
- New Subscription
- Payment Verification Completed
- Payment Verification Failed
- Customer Leave Submitted
- Attendance Approval Response
- New Review
- New Private Feedback
- Owner Subscription Expiry Reminder
- Owner Subscription Expired
- Platform Announcements

---

## Admin Notifications

Admins receive notifications for:

- New Owner Registration
- New Mess Registration
- Payment Verification Failure
- Webhook Failure
- Integration Error
- Owner Subscription Expiry
- Platform Alerts
- Maintenance Alerts

---

# 14. LOCALIZATION

Supported Languages:

- English
- Marathi
- Hindi

Language preference is stored per user.

All user-facing text should support localization.

Future language additions should not require application redesign.

---

# 15. THEME

Supported Themes:

- Light
- Dark
- System

Design Principles:

- Material 3
- Utility-focused
- Clean interface
- Simple navigation
- Responsive layouts
- Minimal animations
- Accessibility-first

The application must provide a consistent experience across:

- Android Phones
- Android Tablets
- Flutter Web (Admin)

---

# 16. OFFLINE SUPPORT

The application supports limited offline functionality.

Cached Data:

- Mess Listings
- User Profile
- Notices
- Subscription Details
- Previously Loaded Reviews

Not Cached:

- Payment Verification
- Attendance Submission
- Attendance Approval
- QR Codes
- Join Requests
- Plan Changes
- Global Settings
- Webhook Management

Whenever network connectivity is restored, cached information should synchronize automatically where applicable.

Critical operations always require an active internet connection.

---

# 17. AUDIT LOGGING

The platform maintains audit logs for important administrative actions.

Examples include:

- Owner Approval
- Owner Suspension
- Mess Approval
- Mess Suspension
- Payment Override
- Payment Retry
- Attendance Override
- Webhook Configuration
- Global Settings Changes

Audit entries should record:

- Action
- Timestamp
- Administrator
- Previous Value (where applicable)
- New Value (where applicable)

Audit logs cannot be modified by Owners.

Only Admins may access audit history.

---

# 18. PLATFORM REVENUE MODEL

Mazi Mess follows a Software-as-a-Service (SaaS) business model.

The platform generates revenue through subscriptions purchased by Mess Owners.

Customers never pay Mazi Mess.

Customers always pay Mess Owners directly.

---

## Customer Payments

Customers pay:

↓

Mess Owner

No customer funds pass through Mazi Mess.

Version 1 does not include:

- Payment Gateway
- Wallet
- Escrow
- Settlement System

---

## Owner Subscription

Mess Owners purchase subscriptions to continue using the platform.

Subscription plans may include:

- Monthly
- Yearly

Owner subscriptions are completely independent from customer subscriptions.

---

## Owner Subscription Status

Possible states:

- Active
- Expiring Soon
- Expired

Only active owner subscriptions have full platform access.

Platform rules such as grace periods and automatic suspension are configurable through Global Settings.

---

## Business Analytics

Platform administrators can monitor:

- Monthly Revenue
- Yearly Revenue
- Monthly Recurring Revenue (MRR)
- Annual Recurring Revenue (ARR)
- Average Revenue Per Owner (ARPO)
- Active Owner Subscriptions
- Expiring Subscriptions
- Expired Subscriptions

Business Analytics provides operational insights only.

It does not affect subscription logic.

---

# 19. PLATFORM SETTINGS

Platform-wide configuration is managed only by Admins.

Global Settings include:

Platform

- Platform Name
- Support Email
- Support Phone
- Current Version

Registration

- Allow New Owner Registrations
- Allow New Customer Registrations

Owner Subscription

- Default Monthly Price
- Default Yearly Price
- Grace Period
- Reminder Before Expiry
- Auto Suspend Expired Owners

Customer Rules

- Review Eligibility
- Attendance Approval Window
- Maximum Leave Days
- Review Edit Window

Payment Verification

- Unique Amount Offset
- Verification Timeout
- Retry Attempts
- Allowed Verification Window

Notifications

- Push Notifications
- Email Notifications
- Owner Alerts
- Admin Alerts
- Maintenance Broadcast

Security

- Session Timeout
- Minimum Supported Version
- Force Logout
- Emergency Platform Lock

Platform Policies

- Privacy Policy
- Terms & Conditions
- Refund Policy
- About Mazi Mess

---

# 20. MAINTENANCE MODE

Maintenance Mode is controlled only by Admins.

When Maintenance Mode is enabled:

Customers

- Cannot log in
- Cannot browse messes
- Cannot make payments
- Cannot generate attendance QR
- Cannot access subscriptions

Customers are shown a maintenance screen containing:

- Maintenance message
- Support Email
- Support Phone

---

Owners

Owners continue normal operations.

Owners may continue:

- Attendance
- Customer Management
- Payment Monitoring
- Plan Management
- Notifications
- Dashboard Operations

Mess operations are intentionally not interrupted.

---

Admins

Admins retain unrestricted platform access.

This allows maintenance while continuing operational monitoring.

---

# 21. NON-GOALS (VERSION 1)

The following features are intentionally excluded from Version 1.

Payments

- Payment Gateway Integration
- Wallet
- Escrow
- Refund Processing

Communication

- Customer-to-Customer Messaging
- Owner Chat
- Voice Calling

Business

- Staff Accounts
- Franchise Management
- Multi-Branch Reporting

Technology

- Web Application
- iOS Application
- AI Recommendations
- Automated Owner Verification
- Dynamic Pricing

Marketplace

- Meal Ordering
- Grocery Marketplace
- Food Delivery

These features remain future roadmap items.

---

# 22. LAUNCH TARGET

Pilot Launch

City:

Chhatrapati Sambhajinagar

Pilot Scale

- 5 Mess Owners
- 100 Existing Customers

Objectives

- Validate discovery experience
- Validate owner onboarding
- Validate subscription management
- Validate attendance workflow
- Validate payment verification
- Validate owner SaaS subscriptions

Success Criteria

- Stable owner onboarding
- Successful mess approvals
- Successful customer onboarding
- Reliable payment verification
- Stable attendance tracking
- Successful pilot deployment
- Positive customer feedback
- Positive owner feedback

The pilot will be used to validate operational workflows before expanding to additional cities.

---

# 23. FUTURE SCALABILITY

The platform architecture is designed for long-term scalability.

Future expansion should support:

- Multiple cities
- Thousands of messes
- Hundreds of thousands of customers
- Multiple administrators
- Multi-region deployment
- Additional payment providers
- Automated analytics
- AI-assisted moderation

The architecture intentionally separates:

- Customer data
- Owner data
- Mess data
- Platform configuration
- Payment verification
- Business analytics

This separation enables future growth without requiring major architectural changes.

---

# 24. PRODUCT PRINCIPLES

The following principles guide every product and engineering decision made for Mazi Mess.

## 1. Simplicity First

The application should remain easy to understand for both customers and mess owners.

Complex workflows should always be hidden behind simple user interfaces.

---

## 2. Utility Over Decoration

Every screen must provide clear value.

Visual effects should never reduce usability or performance.

Material 3 should remain the primary design language.

---

## 3. Owners Are Primary Customers

Mess Owners are the paying customers of the platform.

Product decisions should prioritize helping owners efficiently manage and grow their businesses while maintaining an excellent customer experience.

---

## 4. Customer Trust Is Critical

Customers should always know:

- What they are paying for.
- Which mess they are subscribed to.
- Their attendance history.
- Their payment status.

Platform transparency is essential.

---

## 5. Payment Verification Must Be Reliable

Customer subscriptions should never activate without successful verification.

Verification should remain:

- Auditable
- Reliable
- Recoverable

Manual override exists only for exceptional situations.

---

## 6. Attendance Must Be Accurate

Attendance should always represent meals actually served.

Whenever QR attendance is unavailable, customer approval is required before manual attendance is recorded.

Attendance records should remain trustworthy.

---

## 7. Security Before Convenience

Sensitive platform infrastructure such as:

- Verification Gmail Accounts
- Make Account Credentials
- Webhook URLs

must remain accessible only to Administrators.

Owners never require direct access to these systems.

---

## 8. Every Important Action Must Be Auditable

Critical operations should always leave an audit trail.

Examples:

- Payment Override
- Attendance Override
- Owner Approval
- Mess Approval
- Webhook Changes
- Global Settings Changes

Audit history improves accountability and simplifies troubleshooting.

---

## 9. Platform Scalability

Every new feature should support future expansion across Maharashtra without requiring major architectural redesign.

Scalability should always be considered before implementation.

---

## 10. Configurability

Business rules that may change over time should be configurable through Global Settings whenever practical.

Examples include:

- Review eligibility
- Verification timeout
- Reminder periods
- Grace periods
- Registration controls

---

# 25. TECHNICAL PRINCIPLES

The platform follows these engineering principles.

- Modular architecture
- Feature-based folder structure
- Material 3 design system
- Responsive layouts
- Mobile-first development
- Production-ready code
- Reusable widgets
- Mock-first development followed by backend integration
- Separation of UI, business logic, and data layers

The system should remain maintainable as the codebase grows.

---

# 26. SECURITY PRINCIPLES

The platform must protect sensitive information.

Rules include:

- Customer payments are never stored by Mazi Mess.
- Verification credentials are Admin-only.
- Passwords should never be stored in plain text in production.
- Platform settings are accessible only to Administrators.
- Audit logs cannot be modified by Owners.
- Customer data must remain isolated between messes.
- Every mess maintains independent payment verification infrastructure.

Future backend implementations should enforce these rules through authentication, authorization, and database security rules.

---

# 27. VERSION HISTORY

| Version | Status | Description |
|----------|--------|-------------|
| 1.0 | Draft Approved | Initial product specification |
| 1.1 | Production Ready | Updated after Frontend MVP completion with finalized business rules, payment architecture, admin modules, SaaS model, maintenance mode, and platform configuration |

---

# 28. RELATED DOCUMENTS

This Product Specification should be read together with:

- 01_Firestore_Schema.md
- 03_Permission_Matrix.md
- 04_State_Machines.md
- 05_Screen_Specification.md
- 06_Payment_Verification.md

Together these documents define the complete Mazi Mess platform.

---

# 29. DOCUMENT STATUS

Document Name:

Product Specification

Version:

1.1

Status:

Production Ready

Maintained By:

Mazi Mess Development Team

This document serves as the primary functional specification for the platform and should be updated whenever significant business rules or platform capabilities change.

---

END OF DOCUMENT