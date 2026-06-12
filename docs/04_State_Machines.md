# 04_State_Machines.md

# MAZI MESS - STATE MACHINES V1

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

---

# PAYMENT INTENT STATE MACHINE

States:

pending
under_verification
verified
failed
refunded

Transitions:

pending → under_verification

under_verification → verified
under_verification → failed

verified → refunded
verified → failed (Admin Override Only)

Rules:

* Every payment creates a payment intent.
* Only backend can mark verified.
* Verified is considered terminal except admin intervention.
* Older payment intents are automatically cancelled when a new one is created.

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

present
leave

Rules:

* Attendance records are immutable.
* Owner cannot edit attendance.
* Customer cannot edit attendance.
* Admin override allowed only for exceptional cases.
* Absent is calculated and not stored.

Formula:

Absent =
Eligible Meal
-------------

## Present

Leave

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
