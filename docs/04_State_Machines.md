# MAZI MESS - STATE MACHINES V2

## Purpose

This document defines all allowed state transitions in the system.

Only transitions defined here are valid.

Any other transition must be rejected by backend validation.

---

# OWNER VERIFICATION STATE MACHINE

States:

pending
approved
rejected
suspended

Transitions:

pending → approved
pending → rejected

rejected → pending

approved → suspended

suspended → approved

Rules:

* New owners always start as pending.
* Rejected owners may resubmit information.
* Suspended owners cannot access owner features.
* Only admin may change owner verification status.

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

Any Status → deleted

Rules:

* Only admin may activate a mess.
* Delisting requires admin approval.
* Frozen messes cannot accept customers.
* Deleted messes are permanently hidden.

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

Rules:

* Payment not received within 5 days:
  approved → expired
* Rejected customers receive 5-day cooldown.
* Customer may cancel before approval.
* Expired requests require a new request.
* Approved join requests move to Payment Verification Flow.

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
subscription_activated

Transitions:

payment_initiated → pending_verification

pending_verification → verified
pending_verification → manual_review

verified → subscription_activated

manual_review → approved
manual_review → rejected
manual_review → proof_requested

proof_requested → proof_submitted

proof_submitted → approved
proof_submitted → rejected

approved → subscription_activated

Rules:

* Customer pays via UPI.
* Payment webhook creates pending verification record.
* Gmail node receives Paytm Business notification email.
* Gemini extracts amount, UPI ID and timestamp.
* Matching engine compares webhook and email data.
* High-confidence matches become verified automatically.
* Low-confidence matches enter manual_review.
* Owner may request payment proof.
* Approved payments activate subscription.
* Rejected payments do not activate subscription.

---

# SUBSCRIPTION STATE MACHINE

States:

pending_payment
active
expired
cancelled
suspended

Transitions:

pending_payment → active
pending_payment → cancelled

active → expired
active → suspended

suspended → active

Rules:

* Payment verification activates subscription.
* Expired subscriptions never become active again.
* Renewal creates a NEW subscription.
* Owner may extend end date but cannot reduce it.
* Admin may suspend subscriptions.

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

Rules:

* Active plans allow new subscriptions and renewals.
* Inactive plans allow existing subscribers to continue until expiry.
* Inactive plans do not allow new subscriptions.
* Inactive plans do not allow renewals.
* Plan deletion is allowed only when subscriber_count = 0.
* Deleted plans are permanently hidden.

---

# OWNER SUBSCRIPTION STATE MACHINE

States:

trial
active
grace_period
expired
suspended

Transitions:

trial → active

active → grace_period

grace_period → active
grace_period → expired

expired → active

active → suspended
suspended → active

Rules:

* Grace period = 5 days.
* Frozen owner accounts cannot access owner dashboard.
* Expired owner subscriptions freeze all owned messes.

---

# NOTIFICATION STATE MACHINE

States:

unread
read

Transitions:

unread → read

Rules:

* Notifications auto-delete after 90 days.
* Notifications cannot become unread again.

---

# LEAVE REQUEST STATE MACHINE

States:

active
locked
cancelled

Transitions:

active → locked
active → cancelled

Rules:

* Leave becomes locked 2 days before meal date.
* Locked leave cannot be edited.
* Cancelled leave excluded from calculations.

---

# QR SESSION STATE MACHINE

States:

generated
used
expired

Transitions:

generated → used
generated → expired

Rules:

* QR generated automatically at meal start.
* QR refreshes every 1 minute.
* Single use only.
* Screenshot reuse blocked through timestamp validation.
* Used QR cannot be reused.

---

# ATTENDANCE STATE MACHINE

States:

not_marked
qr_attendance
manual_attendance_requested
customer_approval_pending
customer_approved
customer_rejected
attendance_marked

Transitions:

not_marked → qr_attendance

not_marked → manual_attendance_requested

manual_attendance_requested → customer_approval_pending

customer_approval_pending → customer_approved
customer_approval_pending → customer_rejected

customer_approved → attendance_marked

qr_attendance → attendance_marked

Rules:

* QR attendance remains the primary attendance mechanism.
* Manual attendance requires owner initiation.
* Manual attendance requires a reason.
* Manual attendance requires customer approval.
* Meal is auto-selected using current time and active plan.
* Owner may override meal selection for correction scenarios.
* System validates that selected meal exists in customer's active plan.
* If meal is not included in plan, request is blocked.
* Attendance records are immutable after marking.
* Admin override allowed only for exceptional cases.

Manual Attendance Reasons:

* QR Failed
* Phone Camera Issue
* Network Issue
* Owner Verified In Person
* Other

---

# REVIEW STATE MACHINE

States:

active
reported
removed

Transitions:

active → reported
active → removed

reported → removed
reported → active

Rules:

* Customer may edit review for 2 minutes.
* Owner may edit reply for 2 minutes.
* Only admin may remove reviews permanently.

---

# FEEDBACK STATE MACHINE

States:

active
reported
removed

Transitions:

active → reported
active → removed

reported → removed
reported → active

Rules:

* Feedback is private.
* Owners may report abusive feedback.
* Only admin may remove feedback.

---

# BLACKLIST STATE MACHINE

States:

active
removed

Transitions:

active → removed

Rules:

* Blacklist affects all messes owned by the same owner.
* Blacklisted users cannot submit join requests.
* Customer is not explicitly informed of blacklist status.
