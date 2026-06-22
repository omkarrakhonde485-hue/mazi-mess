# MAZI MESS - PAYMENT VERIFICATION SYSTEM V2

Version: 2.0

Status: Approved

---

# PURPOSE

Mazi Mess does not use a traditional payment gateway.

Customers pay mess owners directly using UPI.

Payments are verified automatically using:

* UPI Deep Links
* Unique Verification Amounts
* Paytm Business Notification Emails
* Make.com Automation
* Gemini Extraction

Only verified payments activate subscriptions.

---

# HIGH LEVEL FLOW

Customer
↓
Select Plan
↓
Create Payment Order
↓
Assign Unique Verification Amount
↓
Generate UPI Deep Link
↓
Customer Pays Using UPI
↓
Customer Returns To Mazi Mess
↓
Customer Taps "I Have Paid"
↓
Verification Screen
↓
Backend Waits 10 Seconds
↓
Backend Calls Owner Webhook
↓
Make.com Verification
↓
Payment Verified
↓
Subscription Activated

---

# SYSTEM COMPONENTS

## Component 1

Customer Mobile App

Purpose:

* Display payment page
* Launch UPI app
* Allow customer confirmation
* Display verification status

---

## Component 2

Paytm Business

Purpose:

* Receive customer payment
* Send payment notification email

---

## Component 3

Verification Gmail

Purpose:

Receive Paytm Business payment notifications.

Rules:

* Dedicated Gmail account created by Admin.
* Gmail account configured inside Make.com.
* Owner must add this Gmail address to Paytm Business notification settings.
* Owners cannot modify verification Gmail configuration from the app.

---

## Component 4

Make.com

Purpose:

* Receive webhook request
* Search recent Paytm emails
* Send email to Gemini
* Compare payment amount
* Return verification result

---

## Make.com Email Extraction Module

Purpose:

Extract payment amount from Paytm email.

Returns structured data.

---

## Component 6

Backend Verification Service

Purpose:

* Create payment order
* Generate verification amount
* Call Make.com webhook
* Activate subscription
* Store audit logs

---

# OWNER-SPECIFIC VERIFICATION CONFIGURATION

Every mess owner shall have:

* UPI ID
* Verification Gmail
* Make.com Webhook
* Verification Status

Rules:

* Admin creates Gmail account.
* Admin imports and configures Make.com scenario.
* Admin stores webhook URL.
* Owners cannot view webhook URLs.
* Owners cannot edit webhook URLs.
* Owners cannot regenerate webhook URLs.

Owner only sees:

Payment Verification Status

Active / Inactive

---

# UNIQUE VERIFICATION AMOUNT SYSTEM

Each payment order receives a unique verification amount.

Example:

Base Subscription Amount:

₹3000

Generated Verification Amounts:

₹3000.01
₹3000.02
₹3000.03
...
₹3000.99

The verification amount acts as the payment identifier.

After ₹3000.99:

Allocation continues from:

₹3000.01

Rules:

* Verification amount is stored against the order.
* Verification amount is embedded into the UPI link.
* Verification amount is sent to Make.com.
* Verification amount is used for verification.

System does not depend on:

* UTR Number
* Transaction ID
* Screenshots
* Customer-entered references

---

# PAYMENT ORDER CREATION

Before payment:

Create Order.

Fields:

* orderId
* customerId
* messId
* planId
* baseAmount
* verificationAmount
* paymentStatus
* createdAt

Status:

pending

Rules:

* Order must exist before payment.
* Verification amount assigned during order creation.

---

# UPI PAYMENT LINK

Format:

upi://pay?pa={upiId}&am={verificationAmount}&cu=INR&tn=Verified

Example:

upi://pay?pa=saimess@paytm&am=3000.03&cu=INR&tn=Verified%20Merchant%20Account

Note:

The transaction note uses:

Verified Merchant Account

to maintain consistency with Paytm Business payment links.

The transaction note is not used for payment verification.

Payment verification is performed solely using the unique verification amount assigned to the order.

Paytm Business notification emails do not reliably expose the transaction note field.

Rules:

* Generated dynamically.
* Opens installed UPI application.
* Amount is prefilled.
* Customer cannot edit amount.

---

# PAYMENT SCREEN

Displays:

* Mess Name
* Plan Name
* Verification Amount
* Pay Using UPI Button
* I Have Paid Button

Customer Instruction:

After completing the payment, return to Mazi Mess and tap the button below to verify your payment.

Buttons:

1. Pay Using UPI
2. I Have Paid

---

# CUSTOMER PAYMENT CONFIRMATION

Customer completes payment externally.

Customer returns to app.

Customer taps:

I Have Paid

System Status:

verification_pending

Verification begins only after customer confirmation.

---

# VERIFICATION FLOW

Customer presses:

I Have Paid

↓

UI shows:

Verifying your payment...

↓

Backend waits 10 seconds

↓

Backend calls owner's webhook

↓

Make.com scenario starts

↓

Search recent Paytm Business emails

↓

Gemini extracts payment amount

↓

Compare extracted amount with verification amount

↓

Webhook Response Returned

Possible Responses:

Payment recieved
not recieved

---

# PAYTM EMAIL PROCESSING

Source:

Paytm Business Payment Received Email

Required Data:

* Amount
* Timestamp
* Sender Information (if available)

Transaction ID is not required.

Order ID from Paytm is ignored.

Only recent payment emails are checked.

---

# PAYMENT MATCHING LOGIC

Backend sends:

Implementation Note:

The current Make.com integration expects:

{
  "value": verificationAmount
}

and returns:

Payment recieved

or

not recieved

(This may change in future versions without affecting business rules.)

Example:

{
  "value": 3000.03
}

Make.com searches recent emails.

Gemini extracts amount.

Verification succeeds when:

Extracted Amount == Verification Amount

No other matching is required.

---

# MATCH SUCCESS

Make.com returns:

Payment recieved

Payment Status == verified

Actions:

* Activate Subscription
* Notify Customer
* Notify Owner
* Create Audit Log

---

# MATCH FAILURE

Make.com returns:

not recieved

Payment Status == verification_failed

Customer Message:

Payment could not be verified automatically.

If payment was completed successfully, please contact the mess owner.

Actions:

* Owner may manually verify payment.
* Owner may manually activate customer subscription.
* Audit log created.

---

# SUBSCRIPTION ACTIVATION

Allowed Only When:

* Payment Verified
  OR
* Owner Manual Approval

Actions:

* Create Subscription
* Set Status = Active
* Notify Customer
* Notify Owner
* Store Audit Log

---

# SECURITY RULES

Customers Cannot:

* Verify payments
* Modify payment status

Owners Cannot:

* View webhook URLs
* Modify webhook URLs
* Modify verification Gmail

Only Admin May:

* Configure Gmail
* Configure Make.com
* Configure Webhooks
* Override verification status

All actions must generate audit logs.

---

# RETENTION

Store Forever:

* Orders
* Payment Logs
* Verification Logs
* Audit Logs
* Subscription Activation Logs

---

# FUTURE MIGRATION PLAN

Version 2+

Possible Migration:

* Razorpay
* Cashfree
* PhonePe PG
* Other Payment Gateways

Existing payment records must remain accessible.

No data loss allowed.

---

# SUCCESS CRITERIA

A payment is successful when:

1. Order exists.
2. Verification amount assigned.
3. Customer completes payment.
4. Customer taps "I Have Paid".
5. Make.com finds matching amount.
6. Payment marked verified.
7. Subscription activated.
8. Audit log created.
