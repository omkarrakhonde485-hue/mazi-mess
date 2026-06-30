# MAZI MESS - PAYMENT VERIFICATION SYSTEM

Version: 2.1

Status: Production Ready

---

# PURPOSE

Mazi Mess does not use a traditional Payment Gateway in Version 1.

Customers pay Mess Owners directly using UPI.

Payments are verified automatically through a dedicated automation pipeline.

Only successfully verified payments activate customer subscriptions.

The platform never stores or processes customer funds.

---

# PAYMENT ARCHITECTURE

Every approved mess receives its own completely independent payment verification infrastructure.

Each mess has:

- One Paytm Business Account
- One Verification Gmail
- One Make.com Account
- One Make Scenario
- One Webhook URL

Example

Sai Mess

↓

Paytm Business

↓

saimess@gmail.com

↓

Make Account A

↓

Webhook A

------------------------------------

Annapurna Mess

↓

Paytm Business

↓

annapurnamess@gmail.com

↓

Make Account B

↓

Webhook B

Every mess operates independently.

Infrastructure is never shared between different messes.

---

# HIGH LEVEL FLOW

Customer

↓

Select Subscription Plan

↓

Payment Intent Created

↓

Unique Verification Amount Generated

↓

UPI Deep Link Generated

↓

Customer Pays Using UPI

↓

Customer Returns To App

↓

Customer taps

"I Have Paid"

↓

Backend waits 10 seconds

↓

Backend calls that mess's dedicated Webhook

↓

Make.com

↓

Gemini AI

↓

Webhook Response

↓

Backend Validation

↓

Firestore Update

↓

Subscription Activated

↓

Notifications

---

# SYSTEM COMPONENTS

## Flutter Application

Responsibilities

- Display payment screen
- Launch UPI application
- Create payment intent
- Allow customer confirmation
- Display verification status

Flutter never verifies payments.

---

## Paytm Business

Responsibilities

- Receive customer payment
- Generate payment notification email

Paytm Business remains outside the application.

---

## Verification Gmail

One Gmail account exists for every approved mess.

Responsibilities

- Receive Paytm Business emails
- Forward email to Make.com

Configured only by Admin.

Owners cannot:

- View Gmail
- Edit Gmail
- Replace Gmail

---

## Make.com

One Make account exists for every approved mess.

Responsibilities

- Receive webhook
- Search Gmail
- Send email to Gemini
- Format response
- Return verification result

Make never updates Firestore directly.

---

## Gemini AI

Purpose

Extract structured payment information.

Extracts

- Amount
- Timestamp
- Sender
- Transaction Reference (when available)

Gemini never:

- Verifies payments
- Activates subscriptions
- Updates Firestore

Gemini performs extraction only.

---

## Backend Verification Service

Responsibilities

- Create Payment Intent
- Generate Verification Amount
- Call Webhook
- Validate Webhook Response
- Activate Subscription
- Generate Notifications
- Generate Audit Logs

Backend remains the final authority.

---

# ADMIN INFRASTRUCTURE

Only Administrators configure payment infrastructure.

For every approved mess Admin configures:

- Verification Gmail
- Make Account Email
- Make Account Password
- Make Scenario
- Webhook URL

Admin may also:

- Test Integration
- Activate Integration
- Disable Integration
- Retry Verification
- Manual Override

Owners never access this information.

---

# INTEGRATION LIFECYCLE

States

not_configured

↓

configured

↓

active

↓

failed

↓

disabled

Rules

Only Admin changes integration state.

Failed integrations generate:

- Admin Notification
- Audit Log

Disabled integrations stop automatic verification.

---

# UNIQUE VERIFICATION AMOUNT

Every Payment Intent receives a unique amount.

Example

Base Price

₹3000

Generated Values

₹3000.01

₹3000.02

₹3000.03

...

₹3000.99

Verification Amount uniquely identifies the payment.

Verification depends only on this amount.

The system does not depend on:

- UTR Number
- Transaction ID
- Customer Screenshots
- Transaction Note

---

# PAYMENT INTENT

Before payment begins:

Create Payment Intent.

Stores:

- Customer
- Mess
- Plan
- Amount
- Verification Amount
- Expiry Time
- Status

Status

pending

↓

under_verification

↓

verified

OR

manual_review

OR

failed

---

# UPI DEEP LINK

Generated dynamically.

Example

upi://pay?pa=saimess@paytm&am=3000.03&cu=INR

Rules

- Amount prefilled
- Customer cannot edit amount
- Opens installed UPI application

---

# CUSTOMER PAYMENT

Customer

↓

Pays through preferred UPI app

↓

Returns to Mazi Mess

↓

Presses

"I Have Paid"

Verification begins only after customer confirmation.

---

# AUTOMATIC VERIFICATION FLOW

Customer presses

"I Have Paid"

↓

10 Second Delay

↓

Backend calls dedicated webhook

↓

Make searches Gmail

↓

Gemini extracts payment

↓

Webhook returns structured response

↓

Backend validates

↓

Payment Verified

↓

Subscription Activated

↓

Notifications Generated

---

# BACKEND VALIDATION

Even after successful Make response, backend validates:

- Payment Intent exists
- Matching verification amount
- Payment not already verified
- Subscription still valid
- Join Request approved
- Duplicate payment check

Only after validation:

Subscription becomes Active.

---

# PAYMENT MONITORING

Every verification enters monitoring.

States

Verification Pending

↓

Verified

↓

Closed

OR

Verification Failed

↓

Retry

↓

Verified

OR

Manual Override

↓

Closed

Every transition is logged.

---

# RETRY STRATEGY

Automatic retries occur for temporary failures.

Examples

- Gmail delay
- Webhook timeout
- Make execution delay

Retry Frequency

Hourly

Maximum retries are configurable.

After retry limit:

Manual Review required.

---

# MANUAL REVIEW

Automatic verification may fail.

Example

- Delayed email
- Ambiguous extraction
- Temporary automation failure

Admin reviews:

- Payment Proof
- Verification Logs
- Payment Details

Possible Actions

Approve

Reject

Retry

Only Admin performs manual review.

---

# MANUAL OVERRIDE

Manual Override is Admin-only.

Allowed when:

- Valid payment confirmed
- Automatic verification failed

Actions

- Verify payment
- Activate subscription
- Notify customer
- Notify owner
- Generate audit log

Owners never perform overrides through the application.

---

# OWNER EXPERIENCE

Owners see:

Customer Name

Plan

Verification Amount

Payment Status

Verification Time

Possible Status

Pending

Verified

Failed

Owners never see:

- Webhook URL
- Gmail
- Make Account
- Make Password
- Gemini Response

---

# CUSTOMER EXPERIENCE

Customer sees:

Payment Pending

↓

Verifying

↓

Verified

OR

Verification Failed

If verification fails:

Customer contacts the Mess Owner directly.

Payment disputes are resolved outside the application.

---

# ADMIN DASHBOARD

Payment Monitoring displays:

- Integration Status
- Verification Queue
- Failed Payments
- Retry Verification
- Manual Override
- Verification Logs
- Webhook Health
- Gmail Status

---

# VERIFICATION LOGS

Every verification attempt stores:

- Payment Intent
- Webhook Request
- Gmail Message ID
- Gemini Result
- Confidence Score
- Verification Method
- Retry Count
- Failure Reason
- Administrator Actions

Logs remain immutable.

---

# SECURITY

Customers cannot:

- Verify payments
- Modify payment status
- Retry verification

Owners cannot:

- Access Gmail
- Access Make Account
- Access Webhook
- Override verification
- Activate subscriptions manually

Only Admin may:

- Configure infrastructure
- Retry verification
- Manual override
- Disable integrations
- Enable integrations

Backend only:

- Activates subscriptions automatically
- Updates payment status
- Generates audit logs

---

# DATA RETENTION

Stored Forever

- Payment Intents
- Verified Payments
- Verification Logs
- Audit Logs
- Subscription Activation History

Notifications follow the platform retention policy.

---

# FUTURE MIGRATION

Future versions may replace Make.com with:

- Firebase Cloud Functions
- Razorpay
- Cashfree
- PhonePe Payment Gateway
- Other Payment Providers

Business rules remain unchanged.

Only the verification implementation changes.

---

# SUCCESS CRITERIA

A payment is considered successful when:

1. Payment Intent exists.
2. Verification Amount assigned.
3. Customer completes UPI payment.
4. Customer confirms payment.
5. Make.com processes Gmail.
6. Gemini extracts payment details.
7. Backend validation succeeds.
8. Payment marked Verified.
9. Subscription Activated.
10. Customer notified.
11. Owner notified.
12. Audit Log generated.

---

# RELATED DOCUMENTS

This document should be read together with:

- 01_Firestore_Schema.md
- 02_Product_Spec.md
- 03_Permission_Matrix.md
- 04_State_Machines.md
- 05_Screen_Specification.md
- 07_Backend_Architecture.md

---

# DOCUMENT STATUS

Document Name

Payment Verification

Version

2.1

Status

Production Ready

Automation

Make.com

Payment Method

Direct UPI

AI Extraction

Gemini AI

Backend

Firebase

Maintained By

Mazi Mess Development Team

This document defines the complete payment verification architecture for Version 1 of the Mazi Mess platform.

---

END OF DOCUMENT