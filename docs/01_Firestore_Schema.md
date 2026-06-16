01_Firestore_Schema.md
MAZI MESS - FIRESTORE SCHEMA V1
Naming Conventions

Collection Names:

lowercase
plural
snake_case

Document IDs:

Firestore auto-generated IDs

Public IDs:

Stored as fields

Example:

messCode = MZ7K4P

Collection: users

Purpose:
Store all authenticated users.

Fields:

userId : string

role :

customer
owner
admin

accountStatus :

active
suspended
deleted

fullName : string

dob : timestamp

gender :

male
female

phoneNumber : string

email : string

address : string

profilePhotoUrl : string|null

isDeleted : boolean

isPhoneVerified : boolean

language :

en
mr
hi

theme :

light
dark
system

notificationEnabled : boolean

createdAt : timestamp

updatedAt : timestamp

Indexes:

phoneNumber
role
accountStatus

Collection: owner_profiles

Purpose:
Owner-specific information.

Fields:

ownerProfileId : string

userId : string

ownerName : string

verificationStatus :

pending
approved
rejected
suspended

verificationNotes : string

ownerPhotoUrl : string|null

approvedBy : string|null

approvedAt : timestamp|null

createdAt : timestamp

Indexes:

userId
verificationStatus

Collection: messes

Purpose:
Mess master records.

Fields:

messId : string

ownerId : string

messCode : string

messName : string

description : string

address : string

latitude : double

longitude : double

contactNumber : string

capacity : number

currentCustomers : number

averageRating : number

totalRatings : number

verified : boolean

deliverySupported : boolean

diningSupported : boolean

status :

pending_approval
active
frozen
delisted
deleted

coverImageUrl : string

galleryImages : array

createdAt : timestamp

updatedAt : timestamp

Indexes:

ownerId
messCode
status
averageRating

Note:

currentCustomers is a derived field.
Actual count comes from active subscriptions.

Collection: mess_verifications

Purpose:
Store verification data.

Fields:

verificationId : string

messId : string

ownerId : string

ownerPhotoUrl : string|null

messPhotoUrls : array

aadhaarNumber : string|null

verificationNotes : string

verifiedBy : string|null

verifiedAt : timestamp|null

createdAt : timestamp

Indexes:

messId

Collection: plans

Purpose:
Subscription plans.

Fields:

planId : string

messId : string

planName : string

description : string

price : number

durationDays : number

mealTypes : array

mealTimings : map

Example:

{
breakfast: {
start: "06:00",
end: "10:00"
},
lunch: {
start: "11:00",
end: "15:00"
},
dinner: {
start: "18:00",
end: "23:00"
}
}

isActive : boolean

createdAt : timestamp

updatedAt : timestamp

Indexes:

messId
isActive

Collection: join_requests

Fields:

joinRequestId : string

customerId : string

messId : string

planId : string

status :

pending
approved
rejected
expired
cancelled_by_customer

rejectionReason : string|null

cooldownUntil : timestamp|null

createdAt : timestamp

updatedAt : timestamp

Indexes:

customerId
messId
status

Collection: subscriptions

Purpose:
Customer subscriptions.

Fields:

subscriptionId : string

customerId : string

messId : string

planId : string

joinRequestId : string

status :

pending_payment
active
expired
cancelled
suspended

startDate : timestamp

endDate : timestamp

extendedDays : number

renewalReminderSent : boolean

PLAN SNAPSHOT

planName : string

price : number

durationDays : number

mealTypes : array

createdAt : timestamp

updatedAt : timestamp

Indexes:

customerId
messId
status
endDate

Collection: leave_dates

Fields:

leaveId : string

subscriptionId : string

customerId : string

messId : string

leaveDate : timestamp

status :

active
cancelled

createdAt : timestamp

Indexes:

subscriptionId
leaveDate

Collection: qr_sessions

Purpose:
Single-use attendance QR sessions.

Fields:

qrSessionId : string

customerId : string

subscriptionId : string

messId : string

mealType :

breakfast
lunch
dinner

generatedAt : timestamp

expiresAt : timestamp

isUsed : boolean

usedAt : timestamp|null

Indexes:

subscriptionId
expiresAt
isUsed

Collection: attendance_scans

Purpose:
Attendance records.

Fields:

attendanceId : string

subscriptionId : string

customerId : string

messId : string

mealType :

breakfast
lunch
dinner

attendanceStatus :

present
leave

scanTimestamp : timestamp

createdAt : timestamp

Indexes:

subscriptionId
messId
mealType
scanTimestamp

Collection: reviews

Fields:

reviewId : string

customerId : string

messId : string

subscriptionId : string

rating : number

reviewText : string

ownerReply : string|null

replyCreatedAt : timestamp|null

createdAt : timestamp

Indexes:

messId
rating

Collection: feedback

Fields:

feedbackId : string

customerId : string

messId : string

subscriptionId : string

feedbackText : string

ownerReply : string|null

createdAt : timestamp

Indexes:

messId

Collection: customer_reputation

Purpose:
Internal moderation data.

Visible only to admins.

Fields:

reputationId : string

customerId : string

blacklistCount : number

totalReports : number

lastReportedAt : timestamp|null

createdAt : timestamp

updatedAt : timestamp

Indexes:

customerId

Collection: payments

Purpose:
Verified payment history.

Fields:

paymentId : string

paymentIntentId : string

customerId : string

messId : string

subscriptionId : string

amount : number

status :

verified
failed

transactionReference : string

rawWebhookId : string|null

verifiedAt : timestamp

createdAt : timestamp

Indexes:

customerId
messId

Retention:

Forever

Collection: payment_intents

Fields:

paymentIntentId : string

customerId : string

messId : string

planId : string

subscriptionId : string|null

amount : number

status :

pending
under_verification
verified
failed
refunded

expiresAt : timestamp

createdAt : timestamp

Indexes:

customerId
status

Collection: notices

Fields:

noticeId : string

messId : string

title : string

body : string

category :

general
holiday
menu_change
payment_reminder
emergency

expiryDate : timestamp

createdAt : timestamp

Indexes:

messId
expiryDate

Retention:

90 days after expiry

Collection: notifications

Fields:

notificationId : string

userId : string

title : string

body : string

type :

join_approved
join_rejected
subscription_expiring
subscription_activated
notice
payment_verified
review_reply
feedback_reply

status :

unread
read

createdAt : timestamp

Indexes:

userId
status

Retention:

90 days

Collection: blacklists

Fields:

blacklistId : string

ownerId : string

customerId : string

reason : string

createdAt : timestamp

Indexes:

ownerId
customerId

Collection: owner_notes

Fields:

noteId : string

ownerId : string

customerId : string

note : string

createdAt : timestamp

updatedAt : timestamp

Indexes:

ownerId
customerId

Collection: owner_subscriptions

Purpose:
Mazi Mess subscription.

Fields:

ownerSubscriptionId : string

ownerId : string

planName : string

status :

trial
active
grace_period
expired
suspended

startDate : timestamp

endDate : timestamp

createdAt : timestamp

Indexes:

ownerId
status

Collection: audit_logs

Purpose:
Immutable system log.

Fields:

auditId : string

actorId : string

actorRole : string

action : string

targetType : string

targetId : string

metadata : map

createdAt : timestamp

Indexes:

actorId
targetType

Retention:

Forever

Collection: settings

Purpose:
Global platform settings.

Fields:

featuredListingEnabled : boolean

paymentVerificationEnabled : boolean

ownerRegistrationEnabled : boolean

customerRegistrationEnabled : boolean

defaultLanguage : string

maintenanceMode : boolean

createdAt : timestamp

updatedAt : timestamp