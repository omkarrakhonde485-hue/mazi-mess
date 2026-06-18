# 06\_Payment\_Verification.md

# MAZI MESS - PAYMENT VERIFICATION SYSTEM V1

Version: 1.0

Status: Approved

\---

# PURPOSE

Mazi Mess does not use a traditional payment gateway in Version 1.

Customers pay mess owners directly through UPI.

The platform verifies payments using Paytm Business payment notification emails.

Only verified payments activate subscriptions.

\---

# HIGH LEVEL FLOW

Customer
↓
Select Plan
↓
Create Payment Intent
↓
Generate Payment QR
↓
Customer Pays Owner
↓
Paytm Business Sends Email
↓
Dedicated Gmail Receives Email
↓
Make.com Trigger
↓
Gemini Extraction
↓
Backend Webhook
↓
Payment Verification
↓
Subscription Activation

\---

# SYSTEM COMPONENTS

Component 1

Customer Mobile App

Purpose:

Initiates payment.

\---

Component 2

Paytm Business

Purpose:

Receives payment.

Sends notification email.

\---

Component 3

Dedicated Gmail

Purpose:

Receives payment emails.

Requirements:

One dedicated email per owner.

Owner must add email in Paytm Business notification settings.

Recommended:

Owner creates email solely for Mazi Mess.

Example:

[saimess.payments@gmail.com](mailto:saimess.payments@gmail.com)

\---

Component 4

Make.com

Purpose:

Monitor Gmail.

Parse payment notifications.

Forward extracted data to backend.

\---

Component 5

Gemini

Purpose:

Extract payment details from email.

Returns structured JSON.

\---

Component 6

Backend Verification Service

Purpose:

Validate payment.

Match against payment intent.

Activate subscription.

\---

# PAYMENT INTENT CREATION

Before showing payment QR:

Create payment\_intent.

Fields:

paymentIntentId

customerId

messId

planId

subscriptionId

amount

status

createdAt

expiresAt

\---

Status:

pending

\---

Rules:

Payment intent must exist before payment.

Only one active payment intent per subscription.

Creating a new intent automatically invalidates older pending intents.

\---

# PAYMENT SCREEN

Displays:

Mess Name

Plan Name

Amount

UPI ID

Payment QR

Buttons:

Open UPI App

I Have Paid

\---

Customer Action:

Complete payment externally.

\---

After Payment:

Customer taps:

I Have Paid

\---

Payment Intent Status:

under\_verification

\---

# PAYTM EMAIL REQUIREMENTS

Email Source:

Paytm Business

Email Must Contain:

Amount

Transaction Time

UPI Transaction Reference

Receiver Information

Payer Information (if available)

\---

Only payment received emails are processed.

Other Paytm emails ignored.

\---

# GMAIL MONITORING

Trigger:

New Email

Conditions:

Sender matches Paytm Business

Email category = Payments

Unread email

\---

Actions:

Retrieve email content

Forward to Gemini

\---

After processing:

Mark email as processed

Store processing reference

\---

# GEMINI EXTRACTION

Input:

Raw email body

\---

Expected Output:

{
"amount": 2500,
"transactionReference": "123456789",
"paymentTimestamp": "2026-01-01T10:00:00Z",
"receiver": "Sai Mess",
"payer": "Customer Name"
}

\---

Extraction Rules:

Ignore formatting differences.

Handle minor email template changes.

Return structured JSON only.

\---

# MAKE.COM WEBHOOK

Webhook Destination:

Backend Payment Endpoint

Method:

POST

Payload:

{
"webhookId": "make\_123",
"amount": 2500,
"transactionReference": "123456789",
"paymentTimestamp": "...",
"receiver": "...",
"payer": "..."
}

\---

Webhook Retries:

3 retries

Exponential backoff

\---

# PAYMENT MATCHING LOGIC

Backend receives webhook.

Find payment intent where:

status = under\_verification

AND

amount matches

AND

mess matches

AND

verification window valid

\---

Verification Window:

10 minutes

Reason:

Allow email delivery time.

Prevent duplicate matches.

\---

# MATCH SUCCESS

If valid match found:

Payment Status:

verified

\---

Create Payment Record

\---

Activate Subscription

\---

Send Customer Notification

Subscription Activated

\---

Send Owner Notification

Payment Verified

\---

# MATCH FAILURE

Possible Reasons:

Wrong Amount

Expired Intent

No Matching Intent

Duplicate Payment

Webhook Corruption

\---

Payment Status:

failed

\---

Admin Notification Generated

\---

# DUPLICATE PAYMENT HANDLING

Scenario:

Customer pays twice.

\---

Detection:

Transaction Reference already exists.

\---

Action:

Flag For Review

Notify Admin

Do Not Auto Activate Second Subscription

\---

Admin decides:

Refund

Extend Subscription

Manual Adjustment

\---

# SUBSCRIPTION ACTIVATION

Allowed Only When:

Payment Verified

\---

Activation Steps:

Create Subscription

Set Status = Active

Generate Notifications

Update Analytics

Write Audit Log

\---

Client applications cannot activate subscriptions.

\---

# ADMIN OVERRIDE

Admin Permissions:

Verify Payment

Fail Payment

Refund Status

Activate Subscription

Suspend Subscription

\---

All overrides must create audit logs.

\---

# WEBHOOK FAILURE HANDLING

Possible Failures:

Make.com unavailable

Backend unavailable

Gemini extraction failure

Invalid payload

\---

Actions:

Store failure log

Retry processing

Notify admin

\---

After 12 hours unresolved:

Critical Alert

\---

# EMAIL PROCESSING RULES

Each email processed once.

Store:

emailMessageId

webhookId

processingTimestamp

processingStatus

\---

Duplicate emails ignored.

\---

# SECURITY RULES

Customers cannot verify payments.

Owners cannot verify payments.

Only backend verifies payments.

Only admin may override verification.

All payment actions generate audit logs.

\---

# RETENTION

Payment Records:

Forever

Payment Intents:

Forever

Webhook Logs:

Forever

Verification Logs:

Forever

Audit Logs:

Forever

\---

# FUTURE MIGRATION PLAN

Version 2

Possible Migration To:

Razorpay

Cashfree

PhonePe Payment Gateway

Amazon Pay

\---

Migration Requirement:

Existing payment records must remain accessible.

No data loss allowed.

Payment abstraction layer should be maintained to allow gateway replacement without redesigning subscriptions.

\---

# SUCCESS CRITERIA

A payment is considered successful only when:

1. Payment intent exists.
2. Matching Paytm email received.
3. Gemini extraction successful.
4. Backend verification successful.
5. Payment marked verified.
6. Subscription activated.
7. Audit log created.

Failure of any step prevents activation.

Owner-Specific Payment Verification
REQ-PAY-07: Owner Verification Configuration
Each mess owner shall have a dedicated payment verification configuration.
The configuration shall contain:
UPI ID
Make.com Webhook URL
Verification Status (Active/Inactive)
REQ-PAY-08: Owner-Specific Webhook Routing
Every owner shall be mapped to a unique Make.com webhook.
Payment verification requests shall be routed only to the webhook assigned to the owner receiving the payment.
Different owners may use different Gmail accounts and Make.com scenarios.
REQ-PAY-09: Hidden Verification Infrastructure
Verification webhooks are internal system configuration.
Owners shall not be able to:
View webhook URLs
Edit webhook URLs
Copy webhook URLs
Delete webhook URLs
Only Admin and Super Admin may manage verification webhooks.
REQ-PAY-10: Automatic Verification Flow

System shall:

Generate UPI payment link:
upi://pay?pa={upiId}\&am={amount}\&cu=INR\&tn=Verified
Launch installed UPI application.
Send verification request to owner's assigned Make.com webhook.
Receive verification result from Make.com.
Automatically activate subscription on successful verification.
REQ-PAY-11: Verification Email Source
Each owner shall provide a Paytm Business account.
Admin shall configure a dedicated Gmail address for payment verification.
Payment notification emails shall be used as the source of truth for payment verification.
REQ-PAY-12: Payment Audit Trail

System shall store:

Order ID
Owner ID
Amount
UPI ID
Verification Status
Verification Timestamp
Verification Source
Make.com Response

