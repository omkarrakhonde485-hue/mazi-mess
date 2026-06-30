\# MAZI MESS - PERMISSION MATRIX



Version: 2.0



Status: Production Ready



This document defines every permission available within the Mazi Mess platform.



It serves as the single source of truth for:



\- Backend authorization

\- Firestore Security Rules

\- API authorization

\- Admin permissions

\- Owner permissions

\- Customer permissions



\---



\# PERMISSION LEGEND



| Symbol | Meaning |

|---------|---------|

| ✅ | Allowed |

| ❌ | Not Allowed |

| 🔒 | Allowed only on own resources |

| ⚠️ | Allowed only when business rules are satisfied |

| 🤖 | System Only |



\---



\# SYSTEM ROLES



The platform defines four execution roles.



\## Customer



End user purchasing subscriptions.



\---



\## Owner



Mess owner managing one or more messes.



\---



\## Admin



Platform administrator with unrestricted operational access.



\---



\## System



Backend automation.



Examples:



\- Firebase Authentication

\- Firestore Security Rules

\- Payment Verification

\- Make Automation

\- Scheduled Jobs

\- Notification Delivery



System permissions are never exposed through the client application.



\---



\# USER MANAGEMENT



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Register Account | ✅ | ✅ | ✅ | ❌ |

| Login | ✅ | ✅ | ✅ | ❌ |

| Logout | ✅ | ✅ | ✅ | ❌ |

| View Own Profile | 🔒 | 🔒 | 🔒 | ❌ |

| Edit Own Profile | 🔒 | 🔒 | 🔒 | ❌ |

| Change Mobile Number | 🔒 | 🔒 | 🔒 | ❌ |

| Change Profile Photo | 🔒 | 🔒 | 🔒 | ❌ |

| View Other User Profile | ❌ | ⚠️ Active Customers Only | ✅ | ❌ |

| Suspend User | ❌ | ❌ | ✅ | ❌ |

| Reactivate User | ❌ | ❌ | ✅ | ❌ |

| Delete User | ❌ | ❌ | ✅ (Soft Delete) | 🤖 |



\---



\# AUTHENTICATION



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Sign Up | ✅ | ✅ | ✅ | ❌ |

| Login | ✅ | ✅ | ✅ | ❌ |

| Logout | ✅ | ✅ | ✅ | ❌ |

| Forgot Password | ✅ | ✅ | ✅ | ❌ |

| Reset Password | ✅ | ✅ | ✅ | 🤖 |

| Verify Mobile Number | ❌ | ❌ | ❌ | 🤖 |

| Verify Email | ❌ | ❌ | ❌ | 🤖 |

| Create Authentication Record | ❌ | ❌ | ❌ | 🤖 |

| Delete Authentication Record | ❌ | ❌ | ✅ | 🤖 |



\---



\# MESS MANAGEMENT



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Mess | ✅ | ✅ | ✅ | ❌ |

| Search Mess | ✅ | ✅ | ✅ | ❌ |

| View Featured Messes | ✅ | ✅ | ✅ | ❌ |

| Create Mess | ❌ | ✅ | ✅ | ❌ |

| Edit Own Mess | ❌ | 🔒 | ✅ | ❌ |

| Edit Other Mess | ❌ | ❌ | ✅ | ❌ |

| Submit Mess For Approval | ❌ | 🔒 | ✅ | ❌ |

| Approve Mess | ❌ | ❌ | ✅ | ❌ |

| Reject Mess | ❌ | ❌ | ✅ | ❌ |

| Suspend Mess | ❌ | ❌ | ✅ | ❌ |

| Reactivate Mess | ❌ | ❌ | ✅ | ❌ |

| Delete Mess | ❌ | ❌ | ✅ (Soft Delete) | 🤖 |



\---



\# PLAN MANAGEMENT



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Plans | ✅ | ✅ | ✅ | ❌ |

| Create Plan | ❌ | 🔒 | ✅ | ❌ |

| Edit Plan | ❌ | 🔒 | ✅ | ❌ |

| Activate Plan | ❌ | 🔒 | ✅ | ❌ |

| Deactivate Plan | ❌ | 🔒 | ✅ | ❌ |

| Delete Plan | ❌ | ⚠️ No Active Subscribers | ✅ | ❌ |

| View Subscriber Count | ❌ | 🔒 | ✅ | ❌ |



\---



\# JOIN REQUESTS



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Create Join Request | ✅ | ❌ | ✅ | ❌ |

| Cancel Join Request | ⚠️ Pending Only | ❌ | ✅ | ❌ |

| View Own Requests | 🔒 | ❌ | ✅ | ❌ |

| View Mess Requests | ❌ | 🔒 | ✅ | ❌ |

| Approve Join Request | ❌ | 🔒 | ✅ | ❌ |

| Reject Join Request | ❌ | 🔒 | ✅ | ❌ |

| Expire Old Requests | ❌ | ❌ | ❌ | 🤖 |



\---



\# SUBSCRIPTIONS



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Own Subscription | 🔒 | ❌ | ✅ | ❌ |

| View Mess Subscriptions | ❌ | 🔒 | ✅ | ❌ |

| Purchase Subscription | ✅ | ❌ | ❌ | ❌ |

| Renew Subscription | ✅ | ❌ | ✅ | ❌ |

| Extend Subscription | ❌ | 🔒 | ✅ | ❌ |

| Suspend Subscription | ❌ | ❌ | ✅ | ❌ |

| Cancel Subscription | ❌ | ❌ | ✅ | ❌ |

| Activate Subscription | ❌ | ❌ | ❌ | 🤖 |

| Expire Subscription | ❌ | ❌ | ❌ | 🤖 |



\---



\# PAYMENTS



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Own Payments | 🔒 | ❌ | ✅ | ❌ |

| View Mess Payments | ❌ | 🔒 | ✅ | ❌ |

| Initiate Payment | ✅ | ❌ | ❌ | ❌ |

| Verify Payment | ❌ | ❌ | ✅ | 🤖 |

| Retry Verification | ❌ | ❌ | ✅ | 🤖 |

| Manual Override | ❌ | ❌ | ✅ | ❌ |

| Mark Payment Failed | ❌ | ❌ | ✅ | ❌ |

| Activate Subscription After Verification | ❌ | ❌ | ❌ | 🤖 |

| View Payment Audit Trail | ❌ | ❌ | ✅ | ❌ |

---



\# ATTENDANCE MANAGEMENT



Attendance is immutable.



Historical attendance cannot be edited by Owners.



Manual attendance always requires customer approval.



Attendance is recorded per subscription.



\---



\## Attendance Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Generate QR | ⚠️ Active Subscription | ❌ | ✅ | ❌ |

| Scan QR | ❌ | 🔒 | ✅ | ❌ |

| View Own Attendance | 🔒 | ❌ | ✅ | ❌ |

| View Mess Attendance | ❌ | 🔒 | ✅ | ❌ |

| Request Manual Attendance | ❌ | 🔒 | ✅ | ❌ |

| Receive Attendance Approval Request | 🔒 | ❌ | ❌ | 🤖 |

| Approve Manual Attendance | 🔒 | ❌ | ✅ | ❌ |

| Reject Manual Attendance | 🔒 | ❌ | ✅ | ❌ |

| Record Attendance | ❌ | ❌ | ❌ | 🤖 |

| Override Attendance | ❌ | ❌ | ✅ | ❌ |

| Delete Attendance Record | ❌ | ❌ | ❌ | ❌ |



\---



\## Manual Attendance Business Rules



The Owner may initiate a manual attendance request only when:



\- QR attendance cannot be completed.

\- Customer has an active subscription.

\- Customer is eligible for the current meal.

\- Customer has not already been marked present.

\- Current meal window is still open.



The system automatically determines:



\- Current meal

\- Eligible subscription

\- Attendance window



The Owner may manually change the detected meal only when necessary.



Attendance is recorded only after customer approval.



\---



\# LEAVE MANAGEMENT



Leave records belong to individual subscriptions.



Leave affects only the selected subscription and meal.



\---



\## Leave Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Create Leave | ⚠️ Before Lock Time | ❌ | ✅ | ❌ |

| Edit Leave | ⚠️ Before Lock Time | ❌ | ✅ | ❌ |

| Cancel Leave | ⚠️ Before Lock Time | ❌ | ✅ | ❌ |

| View Own Leave | 🔒 | ❌ | ✅ | ❌ |

| View Customer Leave | ❌ | 🔒 | ✅ | ❌ |

| Lock Leave | ❌ | ❌ | ❌ | 🤖 |



\---



\## Leave Business Rules



Customers may:



\- Submit leave.

\- Edit leave.

\- Cancel leave.



Only until the configured lock period.



Once locked:



\- Customer cannot modify leave.

\- Owner cannot modify leave.

\- Only Admin may override.



\---



\# REVIEWS



Reviews are publicly visible.



Each customer may submit only one review per mess.



\---



\## Review Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Create Review | ⚠️ Eligible Customer | ❌ | ✅ | ❌ |

| Edit Review | ⚠️ Within Edit Window | ❌ | ✅ | ❌ |

| Delete Review | ⚠️ Within Edit Window | ❌ | ✅ | ❌ |

| View Reviews | ✅ | ✅ | ✅ | ❌ |

| Reply To Review | ❌ | 🔒 | ✅ | ❌ |

| Edit Reply | ❌ | ⚠️ Within Edit Window | ✅ | ❌ |

| Remove Review | ❌ | ❌ | ✅ | ❌ |

| Report Review | ✅ | ✅ | ✅ | ❌ |



\---



\## Review Eligibility



Customers must satisfy platform rules.



Example:



\- Minimum subscription duration.

\- Minimum attendance requirement.



These values are configurable through Global Settings.



\---



\# PRIVATE FEEDBACK



Private feedback is visible only to:



\- Customer

\- Mess Owner

\- Admin



It never appears publicly.



\---



\## Feedback Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Submit Feedback | ✅ | ❌ | ✅ | ❌ |

| View Own Feedback | 🔒 | ❌ | ✅ | ❌ |

| View Mess Feedback | ❌ | 🔒 | ✅ | ❌ |

| Reply To Feedback | ❌ | 🔒 | ✅ | ❌ |

| Remove Feedback | ❌ | ❌ | ✅ | ❌ |



\---



\# NOTICES



Only Owners may publish notices for their own messes.



\---



\## Notice Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Notice | ⚠️ Active Customer | 🔒 | ✅ | ❌ |

| Create Notice | ❌ | 🔒 | ✅ | ❌ |

| Edit Notice | ❌ | 🔒 | ✅ | ❌ |

| Delete Notice | ❌ | 🔒 | ✅ | ❌ |

| Deliver Notice | ❌ | ❌ | ❌ | 🤖 |



\---



\# NOTIFICATIONS



Notifications are automatically generated by the platform.



\---



\## Notification Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Own Notifications | 🔒 | 🔒 | 🔒 | ❌ |

| Mark Notification Read | 🔒 | 🔒 | 🔒 | ❌ |

| Delete Notification | ❌ | ❌ | ✅ | ❌ |

| Generate Notification | ❌ | ❌ | ❌ | 🤖 |

| Broadcast Notification | ❌ | ❌ | ✅ | 🤖 |



\---



\## Notification Types



Customer Notifications



\- Join Request Approved

\- Join Request Rejected

\- Payment Verified

\- Payment Failed

\- Subscription Activated

\- Subscription Expired

\- Attendance Approval Request

\- Attendance Approved

\- Attendance Rejected

\- New Notice



Owner Notifications



\- Join Request Received

\- Payment Verification Completed

\- Payment Verification Failed

\- Attendance Approval Response

\- Customer Leave Submitted

\- New Review

\- New Feedback

\- Owner Subscription Expiry



Admin Notifications



\- New Owner Registration

\- New Mess Registration

\- Webhook Failure

\- Payment Verification Failure

\- Platform Alerts

\- Maintenance Alerts

---



\# BLACKLIST MANAGEMENT



Blacklist allows Owners to prevent problematic customers from rejoining any mess they own.



Blacklist records are shared across all messes owned by the same Owner.



\---



\## Blacklist Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Blacklist | ❌ | 🔒 | ✅ | ❌ |

| Add Customer To Blacklist | ❌ | 🔒 | ✅ | ❌ |

| Remove Customer From Blacklist | ❌ | 🔒 | ✅ | ❌ |

| Check Blacklist During Join Request | ❌ | ❌ | ❌ | 🤖 |



\---



\## Blacklist Rules



Owners may only manage blacklists for customers associated with their own messes.



A blacklisted customer:



\- Cannot submit new join requests to any mess owned by that Owner.

\- May continue existing subscriptions until expiry unless manually suspended by Admin.

\- Can be removed from the blacklist by the Owner or Admin.



\---



\# OWNER PRIVATE NOTES



Private Notes help Owners maintain internal records.



Notes are never visible to customers.



\---



\## Owner Notes Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Notes | ❌ | 🔒 | ✅ | ❌ |

| Create Notes | ❌ | 🔒 | ✅ | ❌ |

| Edit Notes | ❌ | 🔒 | ✅ | ❌ |

| Delete Notes | ❌ | 🔒 | ✅ | ❌ |



\---



\# WEBHOOK MANAGEMENT



Webhook Management controls the payment verification infrastructure.



This module is Admin-only.



Owners never access this information.



\---



\## Webhook Management Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Webhook Configuration | ❌ | ❌ | ✅ | ❌ |

| Configure Webhook URL | ❌ | ❌ | ✅ | ❌ |

| Configure Verification Gmail | ❌ | ❌ | ✅ | ❌ |

| Configure Make Account Email | ❌ | ❌ | ✅ | ❌ |

| Configure Make Account Password | ❌ | ❌ | ✅ | ❌ |

| Activate Integration | ❌ | ❌ | ✅ | ❌ |

| Disable Integration | ❌ | ❌ | ✅ | ❌ |

| Execute Webhook | ❌ | ❌ | ❌ | 🤖 |

| Receive Webhook Payload | ❌ | ❌ | ❌ | 🤖 |



\---



\## Webhook Rules



Each approved mess has:



\- One dedicated Gmail account

\- One dedicated Make account

\- One dedicated Make Scenario

\- One dedicated Webhook URL



These credentials are confidential and accessible only to Administrators.



\---



\# PAYMENT MONITORING



Payment Monitoring allows Admins to supervise automated payment verification.



\---



\## Payment Monitoring Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Monitoring Dashboard | ❌ | ❌ | ✅ | ❌ |

| View Failed Payments | ❌ | ❌ | ✅ | ❌ |

| Retry Verification | ❌ | ❌ | ✅ | 🤖 |

| Manual Payment Override | ❌ | ❌ | ✅ | ❌ |

| Mark Payment Verified | ❌ | ❌ | ✅ | ❌ |

| Mark Payment Failed | ❌ | ❌ | ✅ | ❌ |

| View Verification Audit | ❌ | ❌ | ✅ | ❌ |



\---



\## Payment Monitoring Rules



Automatic verification remains the default.



Manual override should only be used when:



\- Customer submits valid payment proof.

\- Automatic verification fails.

\- Administrator completes manual verification.



Every override generates an audit log.



\---



\# BUSINESS ANALYTICS



Business Analytics displays platform revenue information.



This module belongs exclusively to Administrators.



\---



\## Business Analytics Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Business Analytics | ❌ | ❌ | ✅ | ❌ |

| View Revenue Metrics | ❌ | ❌ | ✅ | ❌ |

| View MRR | ❌ | ❌ | ✅ | ❌ |

| View ARR | ❌ | ❌ | ✅ | ❌ |

| View ARPO | ❌ | ❌ | ✅ | ❌ |

| View Revenue Trend | ❌ | ❌ | ✅ | ❌ |

| View Owner Subscription List | ❌ | ❌ | ✅ | ❌ |



\---



\# OWNER SUBSCRIPTIONS



Owner subscriptions control access to the Mazi Mess platform.



They are separate from customer subscriptions.



\---



\## Owner Subscription Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Own Subscription | ❌ | 🔒 | ✅ | ❌ |

| Renew Subscription | ❌ | 🔒 | ✅ | ❌ |

| View Payment History | ❌ | 🔒 | ✅ | ❌ |

| Mark Subscription Renewed | ❌ | ❌ | ✅ | ❌ |

| Activate Subscription | ❌ | ❌ | ❌ | 🤖 |

| Expire Subscription | ❌ | ❌ | ❌ | 🤖 |



\---



\## Owner Subscription Rules



Platform access depends on Owner subscription status.



Possible statuses:



\- Active

\- Expiring Soon

\- Expired



Grace Period behavior is controlled through Global Settings.



\---



\# GLOBAL SETTINGS



Global Settings affect the entire platform.



This module is Admin-only.



\---



\## Global Settings Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Global Settings | ❌ | ❌ | ✅ | ❌ |

| Edit Platform Settings | ❌ | ❌ | ✅ | ❌ |

| Edit Registration Controls | ❌ | ❌ | ✅ | ❌ |

| Edit Subscription Settings | ❌ | ❌ | ✅ | ❌ |

| Edit Customer Rules | ❌ | ❌ | ✅ | ❌ |

| Edit Payment Verification Rules | ❌ | ❌ | ✅ | ❌ |

| Edit Notification Settings | ❌ | ❌ | ✅ | ❌ |

| Edit Security Settings | ❌ | ❌ | ✅ | ❌ |

| Toggle Maintenance Mode | ❌ | ❌ | ✅ | ❌ |



\---



\## Global Settings Rules



Changes made in this module affect the entire platform.



Every change must create an audit log entry.



No Owner or Customer can view or modify these settings.

---



\# AUDIT LOGS



Audit Logs provide a permanent record of critical platform actions.



Audit logs cannot be modified after creation.



\---



\## Audit Log Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| View Audit Logs | ❌ | ❌ | ✅ | ❌ |

| Generate Audit Log | ❌ | ❌ | ❌ | 🤖 |

| Export Audit Logs | ❌ | ❌ | ✅ | ❌ |

| Delete Audit Logs | ❌ | ❌ | ❌ | ❌ |

| Modify Audit Logs | ❌ | ❌ | ❌ | ❌ |



\---



\## Audit Log Triggers



The following actions must automatically generate audit entries:



\### User Management



\- Owner Approval

\- Owner Rejection

\- Owner Suspension

\- Owner Reactivation



\### Mess Management



\- Mess Approval

\- Mess Rejection

\- Mess Suspension

\- Mess Reactivation



\### Payments



\- Manual Payment Override

\- Payment Retry

\- Payment Marked Failed

\- Payment Marked Verified



\### Attendance



\- Attendance Override



\### Platform



\- Global Settings Change

\- Maintenance Mode Toggle

\- Registration Control Change



\### Infrastructure



\- Webhook URL Change

\- Gmail Configuration Change

\- Make Account Configuration Change



\---



\# REGISTRATION CONTROL



Registration Control is managed globally by Administrators.



\---



\## Registration Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Register New Customer | ⚠️ Registration Enabled | ❌ | ✅ | ❌ |

| Register New Owner | ❌ | ⚠️ Registration Enabled | ✅ | ❌ |

| Enable Customer Registration | ❌ | ❌ | ✅ | ❌ |

| Disable Customer Registration | ❌ | ❌ | ✅ | ❌ |

| Enable Owner Registration | ❌ | ❌ | ✅ | ❌ |

| Disable Owner Registration | ❌ | ❌ | ✅ | ❌ |



\---



\## Registration Rules



Disabling registration affects only new users.



Existing Customers continue using the platform.



Existing Owners continue using the platform.



\---



\# MAINTENANCE MODE



Maintenance Mode is controlled globally.



\---



\## Maintenance Permissions



| Action | Customer | Owner | Admin | System |

|---------|:--------:|:------:|:------:|:------:|

| Access Platform During Maintenance | ❌ | ✅ | ✅ | 🤖 |

| Toggle Maintenance Mode | ❌ | ❌ | ✅ | ❌ |

| Display Maintenance Screen | ❌ | ❌ | ❌ | 🤖 |



\---



\## Maintenance Rules



When Maintenance Mode is enabled:



Customer



\- Login blocked

\- Registration blocked

\- Browse blocked

\- Payments blocked

\- Attendance blocked



Owner



\- Full operational access



Admin



\- Full platform access



System



\- Continues running background jobs

\- Continues payment verification

\- Continues notifications

\- Continues scheduled tasks



\---



\# FIREBASE SECURITY RESPONSIBILITIES



The backend is responsible for enforcing all permissions.



The client application must never be trusted.



The backend validates:



\- User Role

\- Resource Ownership

\- Subscription Status

\- Mess Ownership

\- Attendance Eligibility

\- Leave Rules

\- Review Eligibility

\- Payment Status

\- Platform Settings



Firestore Security Rules must reject unauthorized operations.



\---



\# SYSTEM RESPONSIBILITIES



Only backend services may perform these operations.



| Operation | System |

|-----------|:------:|

| Activate Customer Subscription | 🤖 |

| Expire Customer Subscription | 🤖 |

| Verify Payment | 🤖 |

| Execute Payment Retry | 🤖 |

| Deliver Notifications | 🤖 |

| Lock Leave Requests | 🤖 |

| Generate Audit Logs | 🤖 |

| Send Scheduled Notifications | 🤖 |

| Execute Webhooks | 🤖 |

| Process Make Automation Payload | 🤖 |

| Generate Payment Status Updates | 🤖 |



These operations must never be executable directly from the client application.



\---



\# PERMISSION INHERITANCE



Permissions follow the hierarchy below.



Customer



↓



Owner



↓



Admin



↓



System



Higher roles inherit operational visibility where appropriate, but business rules and resource ownership still apply.



Example:



Owner may edit only their own mess.



Admin may edit any mess.



System may update internal platform records automatically.



\---



\# BACKEND ENFORCEMENT PRINCIPLES



The backend must enforce the following principles:



1\. Never trust client-side role validation.



2\. Every request must validate authentication.



3\. Every request must validate authorization.



4\. Every request affecting a mess must validate ownership.



5\. Customer data must remain isolated between different messes.



6\. Owners must never access another Owner's operational data.



7\. Sensitive platform infrastructure must remain Admin-only.



8\. Every payment action must be auditable.



9\. Attendance records must remain immutable except through Admin override.



10\. Soft Delete should be preferred over permanent deletion.



11\. Every important administrative action should generate an audit log.



12\. Business rules configured through Global Settings must always take precedence over hardcoded values.



\---



\# VERSION HISTORY



| Version | Status | Description |

|----------|--------|-------------|

| 1.0 | Draft | Initial permission matrix |

| 2.0 | Production Ready | Redesigned after Frontend MVP completion with backend-ready authorization model, system role, webhook infrastructure, payment monitoring, owner SaaS subscriptions, maintenance mode, audit logging, and Global Settings permissions |



\---



\# RELATED DOCUMENTS



This Permission Matrix should be read together with:



\- 01\_Firestore\_Schema.md

\- 02\_Product\_Spec.md

\- 04\_State\_Machines.md

\- 05\_Screen\_Specification.md

\- 06\_Payment\_Verification.md



Together these documents define the complete authorization model for the Mazi Mess platform.



\---



\# DOCUMENT STATUS



Document Name:



Permission Matrix



Version:



2.0



Status:



Production Ready



Maintained By:



Mazi Mess Development Team



This document is the authoritative reference for platform authorization and must be updated whenever new features introduce new permissions or modify existing authorization rules.



\---



END OF DOCUMENT

