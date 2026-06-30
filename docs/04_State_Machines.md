# MAZI MESS - STATE MACHINES

Version: 2.1

Status: Production Ready

## Purpose

This document defines every valid state transition within the Mazi Mess platform.

Only transitions defined in this document are considered valid.

Any undefined transition must be rejected by backend validation.

This document serves as the foundation for:

- Backend Business Logic
- Firestore State Validation
- API Validation
- Automation Workflows
- Payment Processing
- Attendance Processing
- Platform Operations

---

# OWNER VERIFICATION STATE MACHINE

States:

pending

verification_requested

approved

rejected

suspended

Transitions:

pending → verification_requested

verification_requested → pending

pending → approved

pending → rejected

rejected → pending

approved → suspended

suspended → approved

---

## Transition Rules

• Every newly registered owner begins in **pending**.

• Admin may request additional documents.

• Requested documents return the owner to **pending** after resubmission.

• Only Admin may approve owners.

• Only Admin may reject owners.

• Suspended owners cannot:

- Access Owner Dashboard
- Manage Customers
- Create Plans
- Record Attendance
- Manage Payments

---

# MESS STATUS STATE MACHINE

States:

pending_approval

active

frozen

delisted

deleted

Transitions:

pending_approval → active

pending_approval → deleted

active → frozen

active → delisted

frozen → active

delisted → active

pending_approval → deleted

active → deleted

frozen → deleted

delisted → deleted

---

## Transition Rules

• Newly created messes always begin in **pending_approval**.

• Only Admin may activate a mess.

• Frozen messes:

- Cannot accept new customers.
- Cannot accept new subscriptions.
- Existing customer data remains intact.

• Delisted messes:

- Hidden from Explore page.
- Hidden from Search.
- Existing customers continue accessing subscriptions.

• Deleted messes remain soft-deleted for audit purposes.

---

# JOIN REQUEST STATE MACHINE

States:

pending

approved

rejected

expired

cancelled_by_customer

Transitions:

pending → approved

pending → rejected

pending → cancelled_by_customer

approved → expired

---

## Transition Rules

• Customer may cancel only while request is pending.

• Owner may approve or reject.

• Approved requests expire if payment is not verified within the configured period.

• Expired requests require a completely new join request.

• Rejected customers observe the configured cooldown period before submitting another request.

• Approved requests immediately enter the Payment Verification State Machine.

---

# PAYMENT VERIFICATION STATE MACHINE

States:

payment_initiated

pending_verification

verified

manual_review

proof_requested

proof_submitted

approved

rejected

system_validation

subscription_activated

Transitions:

payment_initiated → pending_verification

pending_verification → verified

pending_verification → manual_review

verified → system_validation

manual_review → approved

manual_review → rejected

manual_review → proof_requested

proof_requested → proof_submitted

proof_submitted → approved

proof_submitted → rejected

approved → system_validation

system_validation → subscription_activated

---

## Transition Rules

Customer

↓

Pays via UPI

↓

Webhook Received

↓

Pending Verification

↓

Dedicated Gmail receives Paytm Business notification

↓

Gemini extracts:

- Amount
- Timestamp
- Sender
- Transaction Reference

↓

Matching Engine

↓

Automatic Verification

OR

Manual Review

↓

System Validation

↓

Subscription Activated

Validation performed during **system_validation**:

- Matching confidence threshold
- Duplicate payment detection
- Subscription availability
- Customer eligibility
- Existing active subscription validation

Only after successful validation may the subscription become active.

Manual Review is used only when automatic verification cannot confidently determine payment validity.

Owners never manually verify payments.

Only Admin may perform payment overrides.

---

# SUBSCRIPTION STATE MACHINE

States:

pending_payment

system_validation

active

expired

cancelled

suspended

renewal_pending

Transitions:

pending_payment → system_validation

system_validation → active

pending_payment → cancelled

active → renewal_pending

renewal_pending → expired

renewal_pending → active

active → suspended

suspended → active

---

## Transition Rules

Subscriptions become active only after:

- Successful payment verification
- Successful backend validation

Expired subscriptions never reactivate.

Renewal always creates a new subscription period.

Owner may extend expiry.

Owner may never shorten an active subscription.

Only Admin may suspend subscriptions.

Renewal Pending allows reminder notifications before expiry.

---

# PLAN STATE MACHINE

States:

draft

active

inactive

deleted

Transitions:

draft → active

active → inactive

inactive → active

inactive → deleted

---

## Transition Rules

Active Plans

- Accept new subscriptions.
- Accept renewals.

Inactive Plans

- Existing subscribers continue normally.
- No new subscriptions.
- No renewals.

Plans may be deleted only when:

Subscriber Count = 0

Deleted plans remain unavailable for future selection.

---

# OWNER SUBSCRIPTION STATE MACHINE

States:

trial

active

renewal_due

grace_period

expired

suspended

Transitions:

trial → active

active → renewal_due

renewal_due → active

renewal_due → grace_period

grace_period → active

grace_period → expired

expired → active

active → suspended

suspended → active

---

## Transition Rules

Newly onboarded Owners may begin with a Trial subscription.

As the subscription approaches expiry:

Active

↓

Renewal Due

↓

Grace Period

↓

Expired

Renewing during:

- Renewal Due
- Grace Period
- Expired

returns the subscription to Active.

Grace Period duration is configurable through Global Settings.

Expired subscriptions:

- Lose Owner dashboard access.
- Cannot manage customers.
- Cannot record attendance.
- Cannot create plans.
- Cannot manage subscriptions.

When an Owner Subscription expires:

- All owned messes become Frozen.
- Customer data remains intact.
- Reactivation restores normal operations.

Only Admin may suspend an Owner subscription manually.

---

# WEBHOOK INTEGRATION STATE MACHINE

States:

not_configured

configured

active

failed

disabled

Transitions:

not_configured → configured

configured → active

active → failed

failed → active

active → disabled

disabled → active

---

## Transition Rules

Every approved mess receives its own:

- Gmail Account
- Make Account
- Make Scenario
- Webhook URL

Only Admin may configure webhook infrastructure.

Owners never view:

- Gmail credentials
- Make credentials
- Webhook URLs

Failed integrations automatically generate:

- Admin Notification
- Audit Log

Disabled integrations stop automatic payment verification until reactivated.

---

# PAYMENT MONITORING STATE MACHINE

States:

verification_pending

verification_failed

retrying

verified

manual_override

closed

Transitions:

verification_pending → verified

verification_pending → verification_failed

verification_failed → retrying

retrying → verified

retrying → verification_failed

verification_failed → manual_override

manual_override → verified

verified → closed

---

## Transition Rules

Automatic verification is always attempted first.

Retry is used when:

- Gmail delay
- Webhook delay
- Temporary automation failure

Manual Override is allowed only after Administrator verification.

Every Manual Override generates:

- Audit Log
- Admin Notification

Closed records become read-only.

---

# NOTIFICATION STATE MACHINE

States:

unread

read

archived

deleted

Transitions:

unread → read

read → archived

archived → deleted

---

## Transition Rules

Notifications begin as Unread.

Reading changes the state to Read.

Old notifications may automatically become Archived.

Archived notifications may later be deleted by scheduled cleanup.

Deleted notifications cannot be restored.

Retention period is configurable.

---

# LEAVE REQUEST STATE MACHINE

States:

active

locked

cancelled

completed

Transitions:

active → locked

active → cancelled

locked → completed

---

## Transition Rules

Leave may be:

Created

Edited

Cancelled

until the configured lock period.

After locking:

Customer cannot modify.

Owner cannot modify.

Only Admin may override.

Completed leave records remain available for historical reporting.

---

# QR SESSION STATE MACHINE

States:

generated

validated

used

expired

Transitions:

generated → validated

validated → used

generated → expired

validated → expired

---

## Transition Rules

Customer generates QR.

↓

Owner scans QR.

↓

System validates:

- QR age
- Timestamp
- Subscription
- Current meal
- Duplicate usage
- Leave status

↓

Attendance proceeds only after successful validation.

QR codes:

- Refresh every minute.
- Are single-use.
- Cannot be reused.
- Cannot be manually generated for previous meals.
- Automatically expire outside the attendance window.

---

# ATTENDANCE STATE MACHINE

States:

not_marked

qr_attendance

manual_attendance_requested

customer_approval_pending

customer_approved

customer_rejected

system_validation

attendance_marked

Transitions:

not_marked → qr_attendance

not_marked → manual_attendance_requested

manual_attendance_requested → customer_approval_pending

customer_approval_pending → customer_approved

customer_approval_pending → customer_rejected

customer_approved → system_validation

qr_attendance → system_validation

system_validation → attendance_marked

---

## Transition Rules

QR Attendance remains the primary attendance mechanism.

Manual Attendance is used only when QR attendance cannot be completed.

Owner initiates:

Manual Attendance Request

↓

Customer receives approval notification

↓

Customer approves or rejects

↓

Backend validates attendance

↓

Attendance recorded

---

### Backend Validation

Before attendance is marked, the system validates:

- Customer has an active subscription.
- Current meal exists in customer's subscribed plan.
- Attendance has not already been recorded.
- Customer is not on approved leave.
- Attendance window is still open.
- Selected mess matches customer's subscription.
- Meal belongs to the current attendance session.

Only after successful validation:

system_validation

↓

attendance_marked

---

### Automatic Meal Detection

Manual Attendance automatically selects:

- Breakfast
- Lunch
- Dinner

using:

- Current system time
- Customer's active subscription
- Meals included in the selected plan

Owner may manually change the detected meal only for genuine correction scenarios.

If the selected meal is not included in the customer's plan:

Request is rejected.

---

### Manual Attendance Reasons

Owner must select one reason:

- QR Failed
- Phone Camera Issue
- Network Issue
- Owner Verified In Person
- Other

Reason becomes part of the attendance audit history.

---

### Attendance Rules

Attendance records are immutable.

Owners cannot edit historical attendance.

Only Admin may perform attendance override.

Every override creates an Audit Log.

---

# REVIEW STATE MACHINE

States:

draft

active

edited

reported

removed

Transitions:

draft → active

active → edited

active → reported

edited → reported

reported → active

reported → removed

---

## Transition Rules

Customer submits review.

↓

Review becomes Active.

Customer may edit only during the configured edit window.

After edit window expires:

Review becomes read-only.

Owners may reply.

Owner replies follow the same edit window.

Only Admin may permanently remove reviews.

Removed reviews cannot be restored.

---

# PRIVATE FEEDBACK STATE MACHINE

States:

submitted

owner_replied

reported

removed

Transitions:

submitted → owner_replied

submitted → reported

owner_replied → reported

reported → removed

reported → submitted

---

## Transition Rules

Private Feedback is visible only to:

- Customer
- Owner
- Admin

Owner may reply.

Feedback never becomes public.

Only Admin may permanently remove feedback.

Reported feedback remains hidden until reviewed.

---

# BLACKLIST STATE MACHINE

States:

active

removed

Transitions:

active → removed

removed → active

---

## Transition Rules

Blacklist applies across all messes owned by the same Owner.

While Active:

Customer:

- Cannot submit join requests.
- Cannot join newly created messes owned by that Owner.

Existing subscriptions continue until expiry unless manually suspended by Admin.

Removing a customer from the blacklist immediately restores join eligibility.

Customer is never explicitly informed that blacklist status caused request rejection.

---

# REGISTRATION CONTROL STATE MACHINE

States:

enabled

disabled

Transitions:

enabled → disabled

disabled → enabled

---

## Transition Rules

Customer Registration

Owner Registration

are controlled independently.

Disabling registration affects only new registrations.

Existing users continue using the platform normally.

Only Admin may change registration state.

Every change generates an Audit Log.

---

# MAINTENANCE MODE STATE MACHINE

States:

off

on

Transitions:

off → on

on → off

---

## Transition Rules

Only Admin may enable Maintenance Mode.

When enabled:

Customer

- Login Blocked
- Registration Blocked
- Explore Blocked
- Payments Blocked
- Attendance Blocked

Owner

- Dashboard Available
- Attendance Available
- Payments Available
- Customer Management Available

Admin

- Full Platform Access

System

Background services continue:

- Payment Verification
- Notifications
- Scheduled Tasks
- Audit Logging
- Automation Workflows

Customers see the dedicated Maintenance Screen until Maintenance Mode is disabled.

---

# BUSINESS ANALYTICS STATE MACHINE

States:

idle

loading

ready

refreshing

error

Transitions:

idle → loading

loading → ready

loading → error

ready → refreshing

refreshing → ready

refreshing → error

error → loading

---

## Transition Rules

Business Analytics loads only for Administrators.

Analytics data is read-only.

Refreshing updates:

- Monthly Revenue
- Yearly Revenue
- Monthly Recurring Revenue (MRR)
- Annual Recurring Revenue (ARR)
- Average Revenue Per Owner (ARPO)
- Active Owner Subscriptions
- Expiring Owner Subscriptions
- Expired Owner Subscriptions

Analytics never modifies operational data.

Errors should display the last successfully loaded analytics whenever possible.

---

# GLOBAL SETTINGS STATE MACHINE

States:

draft

published

Transitions:

draft → published

published → draft

draft → published

---

## Transition Rules

Global Settings are editable only by Administrators.

Every successful save creates a new published configuration.

Configuration changes immediately affect platform behavior where applicable.

Examples:

- Registration Control
- Grace Period
- Review Eligibility
- Attendance Approval Window
- Verification Timeout
- Maintenance Mode
- Notification Settings

Every published configuration generates an Audit Log.

---

# AUDIT LOG STATE MACHINE

States:

created

stored

archived

Transitions:

created → stored

stored → archived

---

## Transition Rules

Audit Logs are generated automatically.

Audit Logs cannot be modified.

Audit Logs cannot be deleted.

Archived logs remain searchable by Administrators.

Audit Logs are generated for:

- Owner Approval
- Owner Suspension
- Mess Approval
- Payment Override
- Attendance Override
- Global Settings Changes
- Registration Changes
- Maintenance Mode
- Webhook Configuration
- Payment Verification Retry

---

# STATE MACHINE DESIGN PRINCIPLES

Every state machine in Mazi Mess follows these principles.

---

## 1. Explicit Transitions

Only documented transitions are valid.

Any undefined transition must be rejected.

---

## 2. Immutable History

Historical records are never modified.

Examples:

- Attendance
- Payments
- Audit Logs

Corrections create new records instead of overwriting history whenever possible.

---

## 3. Backend Validation

The backend validates every transition.

The client application must never directly change state.

---

## 4. Ownership Validation

Before allowing any transition, the backend validates:

- User Role
- Mess Ownership
- Subscription Ownership
- Resource Ownership

---

## 5. Business Rule Validation

State transitions may additionally require:

- Active Subscription
- Valid Payment
- Meal Eligibility
- Attendance Window
- Review Eligibility
- Registration Enabled
- Maintenance Status

---

## 6. Automation First

Whenever possible, transitions are executed automatically by the System.

Examples:

- Subscription Activation
- Payment Verification
- Notification Delivery
- Leave Locking
- QR Expiry
- Audit Log Creation

Manual intervention is reserved for exceptional cases.

---

# BACKEND ENFORCEMENT PRINCIPLES

The backend must ensure:

✓ No invalid transition occurs.

✓ Every transition is authenticated.

✓ Every transition is authorized.

✓ Every transition is auditable.

✓ Historical records remain immutable.

✓ Client applications cannot bypass validation.

State validation should occur before every Firestore write.

---

# VERSION HISTORY

| Version | Status | Description |
|----------|--------|-------------|
| 2.0 | Draft Approved | Initial workflow definitions |
| 2.1 | Production Ready | Enhanced after Frontend MVP completion with webhook lifecycle, payment monitoring, manual attendance approval, owner SaaS lifecycle, maintenance mode, registration control, analytics lifecycle, backend validation, and audit logging |

---

# RELATED DOCUMENTS

This document should be read together with:

- 01_Firestore_Schema.md
- 02_Product_Spec.md
- 03_Permission_Matrix.md
- 05_Screen_Specification.md
- 06_Payment_Verification.md

Together these documents define the complete business behavior of the Mazi Mess platform.

---

# DOCUMENT STATUS

Document Name:

State Machines

Version:

2.1

Status:

Production Ready

Maintained By:

Mazi Mess Development Team

This document defines the only valid state transitions within the Mazi Mess platform.

Backend implementations must enforce these transitions exactly.

---

END OF DOCUMENT