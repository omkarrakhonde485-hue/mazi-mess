\# MAZI MESS - FIRESTORE SCHEMA



Version: 2.0



Status: Production Ready



Platform:



\- Firebase Authentication

\- Cloud Firestore

\- Firebase Storage

\- Firebase Cloud Messaging

\- Make.com Integration

\- Gemini AI Payment Verification



\---



\# SCHEMA DESIGN PRINCIPLES



This schema is designed around business domains instead of application screens.



Collections are grouped into:



\- Users

\- Messes

\- Plans

\- Subscriptions

\- Payments

\- Attendance

\- Reviews

\- Notifications

\- Platform Infrastructure

\- Administration

\- Analytics

\- Audit



Every collection is independently scalable.



\---



\# NAMING CONVENTIONS



\## Collections



Rules:



\- lowercase

\- plural

\- snake\_case



Examples:



users



messes



subscriptions



attendance\_records



owner\_subscriptions



payment\_intents



payment\_verification\_logs



audit\_logs



\---



\## Documents



Firestore Auto IDs



Public identifiers are stored as fields.



Examples:



messCode



MZ7K4P



ownerCode



OWN827



customerCode



CUS194



\---



\## References



Every relationship uses document IDs.



Example



ownerId



messId



customerId



subscriptionId



planId



\---



\## Timestamps



Every collection should contain:



createdAt



updatedAt



unless immutable.



\---



\## Soft Delete



Business records should never be permanently deleted.



Use:



isDeleted



deletedAt



deletedBy



where applicable.



\---



\# COLLECTION: users



Purpose



Stores every authenticated platform user.



Includes:



\- Customer

\- Owner

\- Admin



Fields



userId : string



publicUserCode : string



role :



customer



owner



admin



accountStatus :



active



suspended



deleted



fullName : string



phoneNumber : string



email : string



dob : timestamp



gender :



male



female



other



address : string



profilePhotoUrl : string|null



language :



en



mr



hi



theme :



light



dark



system



notificationEnabled : boolean



isPhoneVerified : boolean



isEmailVerified : boolean



lastLoginAt : timestamp



createdAt : timestamp



updatedAt : timestamp



isDeleted : boolean



deletedAt : timestamp|null



deletedBy : string|null



Indexes



phoneNumber



email



role



accountStatus



publicUserCode



\---



\# COLLECTION: owner\_profiles



Purpose



Stores owner-specific information.



Fields



ownerProfileId : string



ownerId : string



ownerCode : string



verificationStatus :



pending



verification\_requested



approved



rejected



suspended



ownerPhotoUrl : string|null



verificationNotes : string



approvedBy : string|null



approvedAt : timestamp|null



requestedDocuments : array



businessName : string



gstNumber : string|null



panNumber : string|null



createdAt : timestamp



updatedAt : timestamp



Indexes



ownerId



ownerCode



verificationStatus



\---



\# COLLECTION: messes



Purpose



Stores master information for every registered mess.



Fields



messId : string



ownerId : string



messCode : string



messName : string



description : string



address : string



city : string



state : string



pincode : string



latitude : double



longitude : double



contactNumber : string



capacity : number



currentCustomers : number



averageRating : double



totalRatings : number



coverImageUrl : string



deliverySupported : boolean



diningSupported : boolean



status :



pending\_approval



active



frozen



delisted



deleted



createdAt : timestamp



updatedAt : timestamp



isDeleted : boolean



deletedAt : timestamp|null



Indexes



ownerId



messCode



status



city



averageRating



\---



\# COLLECTION: mess\_media



Purpose



Stores all mess-related media separately from the mess document.



Fields



mediaId : string



messId : string



type :



cover



gallery



verification\_document



license



imageUrl : string



uploadedBy : string



uploadedAt : timestamp



displayOrder : number



Indexes



messId



type



\---



\# COLLECTION: mess\_verifications



Purpose



Stores verification workflow for each mess.



Fields



verificationId : string



messId : string



ownerId : string



status :



pending



verification\_requested



approved



rejected



verifiedBy : string|null



verifiedAt : timestamp|null



rejectionReason : string|null



verificationNotes : string



documents : array



createdAt : timestamp



updatedAt : timestamp



Indexes



messId



ownerId



status



\---



\# COLLECTION: mess\_integrations



Purpose



Stores payment verification infrastructure.



One document per mess.



Admin-only.



Fields



integrationId : string



messId : string



verificationGmail : string



makeAccountEmail : string



makeAccountPassword : string



makeScenarioId : string



webhookUrl : string



integrationStatus :



not\_configured



configured



active



failed



disabled



lastSuccessfulVerification : timestamp|null



lastFailure : timestamp|null



failureReason : string|null



createdBy : string



createdAt : timestamp



updatedAt : timestamp



Indexes



messId



integrationStatus



\---



\# COLLECTION: mess\_configuration



Purpose



Stores configurable settings that are unique to a specific mess.



Fields



configurationId : string



messId : string



joinByApproval : boolean



allowReviews : boolean



allowPrivateFeedback : boolean



allowLeaveRequests : boolean



attendanceApprovalEnabled : boolean



maximumCapacity : number



createdAt : timestamp



updatedAt : timestamp



Indexes



messId

---



\# COLLECTION: plans



Purpose



Stores subscription plans created by individual messes.



Fields



planId : string



messId : string



planName : string



description : string



price : number



durationDays : number



mealTypes : array



mealTimings : map



Example



{

&#x20; breakfast: {

&#x20;   start: "06:00",

&#x20;   end: "10:00"

&#x20; },

&#x20; lunch: {

&#x20;   start: "11:00",

&#x20;   end: "15:00"

&#x20; },

&#x20; dinner: {

&#x20;   start: "18:00",

&#x20;   end: "22:30"

&#x20; }

}



status :



draft



active



inactive



deleted



subscriberCount : number



createdAt : timestamp



updatedAt : timestamp



isDeleted : boolean



Indexes



messId



status



subscriberCount



\---



\# COLLECTION: join\_requests



Purpose



Tracks customer requests to join a mess.



Fields



joinRequestId : string



customerId : string



messId : string



planId : string



status :



pending



approved



rejected



expired



cancelled\_by\_customer



rejectionReason : string|null



cooldownUntil : timestamp|null



approvedBy : string|null



approvedAt : timestamp|null



createdAt : timestamp



updatedAt : timestamp



Indexes



customerId



messId



status



createdAt



\---



\# COLLECTION: subscriptions



Purpose



Stores every customer subscription.



Subscriptions are immutable financial records.



Renewals create new subscription documents.



Fields



subscriptionId : string



customerId : string



messId : string



planId : string



joinRequestId : string



paymentIntentId : string|null



paymentId : string|null



status :



pending\_payment



system\_validation



active



renewal\_pending



expired



cancelled



suspended



startDate : timestamp



endDate : timestamp



extendedDays : number



renewalReminderSent : boolean



planSnapshot : map



Example



{

&#x20; planName: "Lunch Plan",

&#x20; durationDays: 30,

&#x20; price: 2500,

&#x20; meals: \["lunch"]

}



activatedBy :



system



admin



activationSource :



automatic



manual\_override



createdAt : timestamp



updatedAt : timestamp



Indexes



customerId



messId



status



endDate



startDate



\---



\# COLLECTION: owner\_subscriptions



Purpose



Stores Mazi Mess SaaS subscriptions.



Fields



ownerSubscriptionId : string



ownerId : string



planName : string



planPrice : number



billingCycle :



monthly



yearly



status :



trial



active



renewal\_due



grace\_period



expired



suspended



startDate : timestamp



endDate : timestamp



renewedFrom : string|null



createdAt : timestamp



updatedAt : timestamp



Indexes



ownerId



status



endDate



\---



\# COLLECTION: owner\_subscription\_history



Purpose



Stores historical renewals.



Never modified.



Fields



historyId : string



ownerSubscriptionId : string



ownerId : string



amount : number



billingCycle :



monthly



yearly



paymentMethod :



upi



bank\_transfer



manual



status :



successful



failed



transactionReference : string



paidAt : timestamp



createdAt : timestamp



Indexes



ownerId



ownerSubscriptionId



paidAt



\---



\# COLLECTION: payment\_intents



Purpose



Represents a payment awaiting verification.



Fields



paymentIntentId : string



customerId : string



messId : string



planId : string



subscriptionId : string|null



amount : number



uniqueAmountOffset : number



expectedAmount : number



verificationMethod :



automatic



manual



status :



pending



under\_verification



verified



failed



manual\_review



expired



expiresAt : timestamp



createdAt : timestamp



updatedAt : timestamp



Indexes



customerId



messId



status



expiresAt



\---



\# COLLECTION: payments



Purpose



Stores permanently verified payments.



Fields



paymentId : string



paymentIntentId : string



customerId : string



messId : string



subscriptionId : string



amount : number



verificationMethod :



automatic



manual\_override



status :



verified



failed



transactionReference : string



verifiedBy :



system



admin



verifiedAt : timestamp



createdAt : timestamp



Indexes



customerId



messId



subscriptionId



verifiedAt



Retention



Forever



\---



\# COLLECTION: payment\_verification\_logs



Purpose



Stores complete payment verification history.



Admin-only.



One payment may generate multiple verification logs.



Fields



verificationLogId : string



paymentIntentId : string



messId : string



gmailMessageId : string|null



makeExecutionId : string|null



webhookRequestId : string|null



geminiConfidenceScore : number|null



geminiExtractedData : map



matchingResult :



matched



partial\_match



no\_match



verificationStatus :



pending



verified



manual\_review



failed



verificationMethod :



automatic



manual



failureReason : string|null



rawWebhookPayload : map



createdAt : timestamp



Indexes



paymentIntentId



messId



verificationStatus



createdAt



Retention



Forever

---



\# COLLECTION: attendance\_requests



Purpose



Stores manual attendance approval requests.



Created only when QR attendance cannot be completed.



Fields



attendanceRequestId : string



messId : string



ownerId : string



customerId : string



subscriptionId : string



mealType :



breakfast



lunch



dinner



reason :



qr\_failed



camera\_issue



network\_issue



owner\_verified



other



status :



pending



approved



rejected



expired



ownerRemarks : string|null



customerRemarks : string|null



requestedAt : timestamp



respondedAt : timestamp|null



expiresAt : timestamp



createdAt : timestamp



Indexes



customerId



ownerId



messId



status



expiresAt



\---



\# COLLECTION: attendance\_records



Purpose



Stores immutable attendance history.



Fields



attendanceId : string



subscriptionId : string



customerId : string



messId : string



attendanceRequestId : string|null



mealType :



breakfast



lunch



dinner



attendanceMethod :



qr



manual



attendanceStatus :



present



leave



markedBy :



system



owner



admin



markedAt : timestamp



createdAt : timestamp



Indexes



subscriptionId



customerId



messId



mealType



markedAt



Retention



Forever



\---



\# COLLECTION: leave\_requests



Purpose



Stores planned leave requests.



Fields



leaveRequestId : string



subscriptionId : string



customerId : string



messId : string



mealType :



breakfast



lunch



dinner



leaveDate : timestamp



status :



active



locked



cancelled



completed



createdAt : timestamp



updatedAt : timestamp



Indexes



subscriptionId



customerId



leaveDate



status



\---



\# COLLECTION: reviews



Purpose



Stores public customer reviews.



Fields



reviewId : string



customerId : string



messId : string



subscriptionId : string



rating : number



reviewText : string



ownerReply : string|null



ownerReplyUpdatedAt : timestamp|null



status :



active



reported



removed



helpfulCount : number



reportCount : number



createdAt : timestamp



updatedAt : timestamp



Indexes



messId



customerId



rating



status



\---



\# COLLECTION: private\_feedback



Purpose



Stores private customer feedback.



Visible only to:



\- Customer

\- Mess Owner

\- Admin



Fields



feedbackId : string



customerId : string



messId : string



subscriptionId : string



feedbackText : string



ownerReply : string|null



status :



active



reported



removed



createdAt : timestamp



updatedAt : timestamp



Indexes



messId



customerId



status



\---



\# COLLECTION: notices



Purpose



Stores notices published by mess owners.



Fields



noticeId : string



messId : string



title : string



body : string



category :



general



holiday



menu\_change



payment\_reminder



emergency



isPinned : boolean



expiryDate : timestamp



publishedBy : string



createdAt : timestamp



updatedAt : timestamp



Indexes



messId



category



expiryDate



Retention



90 Days After Expiry



\---



\# COLLECTION: customer\_notifications



Purpose



Stores notifications visible only to customers.



Fields



notificationId : string



customerId : string



title : string



body : string



category :



join\_request



subscription



payment



attendance



leave



notice



review



feedback



announcement



status :



unread



read



archived



relatedDocumentId : string|null



createdAt : timestamp



Indexes



customerId



status



category



createdAt



Retention



90 Days



\---



\# COLLECTION: owner\_notifications



Purpose



Stores notifications visible only to owners.



Fields



notificationId : string



ownerId : string



title : string



body : string



category :



join\_request



payment



attendance



leave



review



feedback



subscription



platform



status :



unread



read



archived



relatedDocumentId : string|null



createdAt : timestamp



Indexes



ownerId



status



category



createdAt



Retention



90 Days



\---



\# COLLECTION: admin\_notifications



Purpose



Stores platform notifications visible only to administrators.



Fields



notificationId : string



adminId : string



title : string



body : string



category :



owner\_verification



mess\_verification



payment\_failure



webhook\_failure



system\_alert



maintenance



business



audit



status :



unread



read



archived



relatedDocumentId : string|null



createdAt : timestamp



Indexes



adminId



status



category



createdAt



Retention



90 Days



\---



\# COLLECTION: blacklists



Purpose



Stores owner-specific blacklist entries.



Fields



blacklistId : string



ownerId : string



customerId : string



reason : string



status :



active



removed



createdAt : timestamp



updatedAt : timestamp



Indexes



ownerId



customerId



status



\---



\# COLLECTION: owner\_notes



Purpose



Stores private notes maintained by owners.



Fields



noteId : string



ownerId : string



customerId : string



messId : string



note : string



createdAt : timestamp



updatedAt : timestamp



Indexes



ownerId



customerId



messId

---



\# COLLECTION: global\_settings



Purpose



Stores platform-wide configuration.



Only one active document should exist.



Admin-only.



Fields



settingsId : string



platformName : string



supportEmail : string



supportPhone : string



currentAppVersion : string



maintenanceMode : boolean



customerRegistrationEnabled : boolean



ownerRegistrationEnabled : boolean



reviewEligibilityDays : number



minimumAttendanceForReview : number



attendanceApprovalWindowMinutes : number



leaveLockDays : number



ownerGracePeriodDays : number



verificationTimeoutMinutes : number



maximumVerificationRetries : number



pushNotificationsEnabled : boolean



emailNotificationsEnabled : boolean



minimumSupportedVersion : string



privacyPolicyVersion : string



termsVersion : string



refundPolicyVersion : string



createdBy : string



createdAt : timestamp



updatedAt : timestamp



Indexes



None



\---



\# COLLECTION: platform\_statistics



Purpose



Stores platform-wide counters.



Updated automatically.



Fields



statisticsId : string



totalCustomers : number



totalOwners : number



totalMesses : number



activeMesses : number



activeSubscriptions : number



expiredSubscriptions : number



activeOwnerSubscriptions : number



totalPaymentsVerified : number



monthlyRevenue : number



yearlyRevenue : number



createdAt : timestamp



updatedAt : timestamp



Indexes



None



\---



\# COLLECTION: analytics\_daily



Purpose



Precomputed daily analytics.



Used by Admin Dashboard.



Fields



analyticsId : string



date : timestamp



newCustomers : number



newOwners : number



newMesses : number



newSubscriptions : number



verifiedPayments : number



ownerRevenue : number



platformRevenue : number



createdAt : timestamp



Indexes



date



\---



\# COLLECTION: analytics\_monthly



Purpose



Monthly aggregated analytics.



Fields



analyticsId : string



month : string



year : number



newCustomers : number



newOwners : number



newMesses : number



newSubscriptions : number



platformRevenue : number



mrr : number



arpo : number



activeOwners : number



expiredOwners : number



createdAt : timestamp



Indexes



month



year



\---



\# COLLECTION: analytics\_yearly



Purpose



Yearly aggregated analytics.



Fields



analyticsId : string



year : number



platformRevenue : number



arr : number



averageMonthlyRevenue : number



totalCustomers : number



totalOwners : number



totalMesses : number



createdAt : timestamp



Indexes



year



\---



\# COLLECTION: audit\_logs



Purpose



Stores immutable audit history.



Admin-only.



Fields



auditLogId : string



action : string



entityType : string



entityId : string



performedBy : string



performedRole :



customer



owner



admin



system



performedVia :



mobile



admin\_panel



make



backend



previousState : string|null



newState : string



ipAddress : string|null



deviceInfo : string|null



appVersion : string|null



remarks : string|null



createdAt : timestamp



Indexes



entityType



entityId



performedBy



performedRole



createdAt



Retention



Forever



\---



\# COLLECTION: customer\_reputation



Purpose



Stores derived customer behaviour metrics.



Used internally.



Fields



reputationId : string



customerId : string



successfulSubscriptions : number



attendancePercentage : double



leavePercentage : double



paymentFailures : number



reportedReviews : number



blacklistedCount : number



overallScore : number



lastUpdated : timestamp



Indexes



customerId



overallScore



\---



\# COLLECTION: owner\_dashboard\_cache



Purpose



Stores precomputed dashboard data.



Fields



cacheId : string



ownerId : string



totalCustomers : number



activeSubscriptions : number



todayAttendance : number



todayLeaves : number



monthlyRevenue : number



pendingJoinRequests : number



pendingAttendanceRequests : number



updatedAt : timestamp



Indexes



ownerId



\---



\# COLLECTION: customer\_dashboard\_cache



Purpose



Stores precomputed customer dashboard data.



Fields



cacheId : string



customerId : string



activeSubscriptions : number



nextExpiryDate : timestamp|null



todayMealsRemaining : number



pendingAttendanceRequests : number



unreadNotifications : number



updatedAt : timestamp



Indexes



customerId



\---



\# COLLECTION: business\_reports



Purpose



Stores generated business reports.



Fields



reportId : string



reportType :



daily



weekly



monthly



yearly



generatedBy : string



generatedAt : timestamp



storageUrl : string



status :



generating



ready



failed



Indexes



reportType



generatedAt



status



\---



\# COLLECTION: system\_jobs



Purpose



Tracks scheduled backend jobs.



System-only.



Fields



jobId : string



jobName : string



jobType :



subscription\_expiry



notification



leave\_lock



analytics\_refresh



payment\_retry



audit\_cleanup



status :



scheduled



running



completed



failed



lastRunAt : timestamp|null



nextRunAt : timestamp



failureReason : string|null



createdAt : timestamp



Indexes



jobType



status



nextRunAt

---



\# COLLECTION RELATIONSHIPS



The following diagram illustrates the primary relationships between collections.



```

users

&#x20;│

&#x20;├── owner\_profiles

&#x20;│

&#x20;├── messes

&#x20;│      │

&#x20;│      ├── mess\_media

&#x20;│      ├── mess\_configuration

&#x20;│      ├── mess\_verifications

&#x20;│      ├── mess\_integrations

&#x20;│      ├── plans

&#x20;│      ├── notices

&#x20;│      ├── reviews

&#x20;│      ├── private\_feedback

&#x20;│      ├── attendance\_records

&#x20;│      └── join\_requests

&#x20;│

&#x20;├── subscriptions

&#x20;│      │

&#x20;│      ├── payment\_intents

&#x20;│      ├── payments

&#x20;│      ├── attendance\_requests

&#x20;│      ├── attendance\_records

&#x20;│      └── leave\_requests

&#x20;│

&#x20;├── customer\_notifications

&#x20;├── owner\_notifications

&#x20;├── admin\_notifications

&#x20;│

&#x20;├── owner\_subscriptions

&#x20;│      └── owner\_subscription\_history

&#x20;│

&#x20;├── audit\_logs

&#x20;│

&#x20;└── platform\_statistics

```



All relationships should use Firestore document IDs.



Circular references should be avoided.



\---



\# FIREBASE STORAGE STRUCTURE



Firebase Storage should use the following directory layout.



```

users/

&#x20;   profile\_photos/



owners/

&#x20;   verification\_documents/



messes/

&#x20;   cover\_images/



messes/

&#x20;   gallery/



messes/

&#x20;   verification\_documents/



payments/

&#x20;   proofs/



reports/



exports/

```



Uploads should never overwrite previous files.



Use unique filenames.



Example:



```

mess\_9FJ4\_cover\_20260715.jpg

```



\---



\# FIRESTORE SECURITY GUIDELINES



Firestore Security Rules must validate:



Authentication



↓



User Role



↓



Ownership



↓



Business Rules



↓



Requested Operation



The client application must never determine authorization.



\---



\## Customer Access



Customers may access:



\- Their own profile

\- Their own subscriptions

\- Their own attendance

\- Their own leave requests

\- Their own notifications

\- Public mess information

\- Public reviews



Customers must never access:



\- Other customer records

\- Owner private notes

\- Payment verification logs

\- Audit logs

\- Global settings

\- Webhook infrastructure



\---



\## Owner Access



Owners may access:



\- Their own messes

\- Their own customers

\- Their own plans

\- Their own attendance

\- Their own notices

\- Their own analytics

\- Their own owner subscription



Owners must never access:



\- Other owners' data

\- Webhook URLs

\- Make credentials

\- Verification Gmail credentials

\- Platform analytics

\- Global settings

\- Audit logs



\---



\## Admin Access



Administrators have unrestricted access to operational collections.



Sensitive writes should still require backend validation.



\---



\## System Access



Only backend services may write to:



\- payments

\- payment\_verification\_logs

\- audit\_logs

\- analytics\_daily

\- analytics\_monthly

\- analytics\_yearly

\- platform\_statistics

\- system\_jobs



\---



\# COMPOSITE INDEX RECOMMENDATIONS



Create composite indexes for commonly queried fields.



Subscriptions



\- customerId + status

\- customerId + endDate

\- messId + status



Attendance



\- customerId + markedAt

\- messId + mealType + markedAt

\- subscriptionId + markedAt



Payments



\- messId + verifiedAt

\- customerId + verifiedAt

\- paymentIntentId + verificationStatus



Join Requests



\- messId + status

\- customerId + status



Reviews



\- messId + rating

\- messId + status



Notifications



\- customerId + status

\- ownerId + status

\- adminId + status



Analytics



\- month + year

\- year



Audit Logs



\- entityType + entityId

\- performedBy + createdAt



\---



\# DATA RETENTION POLICY



The following retention policy applies.



| Collection | Retention |

|------------|-----------|

| Payments | Forever |

| Payment Verification Logs | Forever |

| Audit Logs | Forever |

| Attendance Records | Forever |

| Owner Subscription History | Forever |

| Reviews | Until Removed |

| Private Feedback | Until Removed |

| Notifications | 90 Days |

| Notices | 90 Days After Expiry |

| Dashboard Cache | Auto Refreshed |

| Analytics Cache | Auto Refreshed |

| System Jobs | 180 Days |



Historical financial records should never be deleted.



\---



\# BACKUP \& RECOVERY



Recommended strategy:



Daily



\- Firestore Backup



Weekly



\- Storage Backup



Monthly



\- Full Platform Snapshot



Critical collections:



\- users

\- messes

\- subscriptions

\- payments

\- owner\_subscriptions

\- audit\_logs

\- global\_settings



Backups should be encrypted.



\---



\# SCALABILITY STRATEGY



The schema is designed to support:



\- Multiple Cities

\- Multiple States

\- Hundreds of Thousands of Customers

\- Thousands of Owners

\- Thousands of Messes



Scalability principles:



\- Small documents

\- Flat collections

\- Avoid deeply nested documents

\- Denormalize where beneficial

\- Cache expensive dashboard queries

\- Precompute analytics

\- Store immutable financial history



Future services should integrate without structural changes.



\---



\# FUTURE EXTENSIONS



The schema allows future addition of:



\- Multiple Payment Providers

\- AI Recommendations

\- Meal Ordering

\- Staff Accounts

\- Franchise Management

\- Referral Program

\- Loyalty Program

\- Coupon Engine

\- Push Campaigns

\- Customer Segmentation



These features should reuse existing collections wherever possible.



\---



\# VERSION HISTORY



| Version | Status | Description |

|----------|--------|-------------|

| 1.0 | Draft | Initial Firestore schema |

| 2.0 | Production Ready | Redesigned after Frontend MVP completion with SaaS architecture, per-mess payment integrations, manual attendance workflow, analytics, audit logging, dashboard caching, global settings, and production-ready collection organization |



\---



\# RELATED DOCUMENTS



This schema should be read together with:



\- 02\_Product\_Spec.md

\- 03\_Permission\_Matrix.md

\- 04\_State\_Machines.md

\- 05\_Screen\_Specification.md

\- 06\_Payment\_Verification.md



Together these documents define the complete architecture of the Mazi Mess platform.



\---



\# DOCUMENT STATUS



Document Name:



Firestore Schema



Version:



2.0



Status:



Production Ready



Backend:



Firebase Authentication



Database:



Cloud Firestore



Storage:



Firebase Storage



Notifications:



Firebase Cloud Messaging



Payment Automation:



Make.com + Gmail + Gemini AI



Maintained By:



Mazi Mess Development Team



This document is the authoritative database specification for the Mazi Mess platform.



Any schema changes should be reflected here before implementation.



\---



END OF DOCUMENT

