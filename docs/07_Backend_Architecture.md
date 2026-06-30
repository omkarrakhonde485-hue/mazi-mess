# MAZI MESS - BACKEND ARCHITECTURE

Version: 1.0

Status: Production Ready

Backend Stack

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging
- Firebase Cloud Functions (Future)
- Make.com
- Gmail
- Gemini AI

---

# PURPOSE

This document defines the backend architecture of the Mazi Mess platform.

It acts as the implementation guide for:

- Firebase Backend
- Firestore
- Authentication
- Payment Verification
- Notifications
- Security
- Automation
- Deployment

This document complements:

- Product Specification
- Firestore Schema
- Permission Matrix
- State Machines

---

# ARCHITECTURE OVERVIEW

The platform follows a service-oriented architecture.

```
                   Flutter Application
                           │
                           ▼
              Firebase Authentication
                           │
                           ▼
                  Cloud Firestore
                           │
      ┌──────────────┬──────────────┐
      ▼              ▼              ▼
 Firebase Storage    FCM        Backend Services
                                          │
                                          ▼
                                      Make.com
                                          │
                                          ▼
                                   Gmail Monitoring
                                          │
                                          ▼
                                      Gemini AI
                                          │
                                          ▼
                                  Payment Verification
                                          │
                                          ▼
                                   Firestore Updates
                                          │
                                          ▼
                                   Push Notifications
```

The Flutter application never communicates directly with external automation services.

All permanent business data is stored in Cloud Firestore.

---

# ARCHITECTURAL PRINCIPLES

The backend follows these principles.

---

## 1. Backend Is Source of Truth

The client application is responsible only for:

- User Interface
- User Input
- Local Caching

The backend determines:

- User permissions
- Business validation
- State transitions
- Payment verification
- Subscription activation

---

## 2. Never Trust The Client

Every write request must validate:

- Authentication
- Authorization
- Resource Ownership
- Business Rules

No client-side validation should be considered authoritative.

---

## 3. Event-Driven Design

Business actions create events.

Example:

Customer Payment

↓

Payment Intent Created

↓

Webhook Received

↓

Verification Completed

↓

Subscription Activated

↓

Notification Sent

Each event is processed independently.

---

## 4. Immutable Financial Records

Financial collections are immutable.

Examples:

- Payments
- Owner Subscription History
- Verification Logs

Corrections create new records.

Historical records are never overwritten.

---

## 5. Audit Everything

Every critical administrative action generates an audit record.

Examples:

- Owner Approval
- Mess Approval
- Payment Override
- Attendance Override
- Global Settings Change
- Webhook Configuration

Audit logs are immutable.

---

## 6. Security First

Sensitive infrastructure must never be exposed.

Examples:

- Make Credentials
- Gmail Credentials
- Webhook URLs

Only Administrators may access infrastructure configuration.

---

## 7. Scalability Before Optimization

Collections are designed to support:

- Thousands of Owners
- Hundreds of Thousands of Customers
- Millions of Attendance Records

without structural redesign.

---

# FIREBASE SERVICES

## Firebase Authentication

Responsibilities

- User Registration
- Login
- Password Reset
- Identity Verification
- Session Management

Authentication never stores business data.

Business data lives only inside Firestore.

---

## Cloud Firestore

Responsibilities

- User Data
- Mess Data
- Plans
- Subscriptions
- Payments
- Attendance
- Reviews
- Notifications
- Analytics
- Audit Logs

Firestore is the primary database.

---

## Firebase Storage

Responsibilities

- Profile Photos
- Mess Images
- Verification Documents
- Payment Proofs (Manual Review)
- Exported Reports

No metadata should be stored only in Storage.

Firestore always contains metadata.

---

## Firebase Cloud Messaging (FCM)

Responsibilities

- Push Notifications
- Background Notifications
- Topic Messaging (Future)
- Device Token Management

FCM should never determine notification content.

Firestore remains the source of notification data.

---

## Firebase Cloud Functions (Future)

Cloud Functions will be introduced only where server-side execution is required.

Potential responsibilities include:

- Scheduled Jobs
- Cleanup Tasks
- Analytics Aggregation
- Notification Fan-out
- Security Enforcement
- Future Third-party Integrations

Version 1 relies primarily on Make.com for payment automation.

---

# DOMAIN-DRIVEN BACKEND MODULES

The backend is divided into independent domains.

Authentication

↓

Users

↓

Owners

↓

Messes

↓

Plans

↓

Subscriptions

↓

Payments

↓

Attendance

↓

Reviews

↓

Notifications

↓

Analytics

↓

Platform

↓

Infrastructure

↓

Audit

Each module owns its data and business rules.

Modules communicate through Firestore documents and backend events.

---

# REPOSITORY LAYER

Every Firestore collection should be accessed through a dedicated repository.

Repositories isolate Firestore from business logic.

Planned repositories include:

AuthRepository

UserRepository

OwnerRepository

MessRepository

PlanRepository

JoinRequestRepository

SubscriptionRepository

OwnerSubscriptionRepository

PaymentRepository

AttendanceRepository

LeaveRepository

ReviewRepository

FeedbackRepository

NotificationRepository

AnalyticsRepository

AuditRepository

GlobalSettingsRepository

Repositories should never contain UI code.

Repositories perform:

- CRUD Operations
- Firestore Queries
- Transaction Handling
- Pagination
- Batch Writes

Business validation belongs in the Service Layer.

---

# SERVICE LAYER

Services coordinate business logic across repositories.

Example services:

AuthenticationService

SubscriptionService

PaymentVerificationService

AttendanceService

ReviewService

NotificationService

AnalyticsService

AuditService

GlobalSettingsService

Service responsibilities include:

- Business validation
- State transitions
- Multi-collection updates
- Event handling
- Error handling

Services never contain UI code.

---

# AUTHENTICATION FLOW

Authentication is handled exclusively by Firebase Authentication.

```
User

↓

Firebase Authentication

↓

ID Token Issued

↓

Flutter Stores Session

↓

Firestore Profile Loaded

↓

Role Determined

↓

Dashboard Loaded
```

Authentication succeeds only after:

- Valid credentials
- Active account
- Existing Firestore profile

If any validation fails:

User is redirected appropriately.

---

## Authentication Responsibilities

Firebase Authentication

- Login
- Registration
- Password Reset
- Session Token

Firestore

- User Profile
- Role
- Permissions
- Preferences

Authentication and authorization remain separate concerns.

---

# REQUEST FLOW

Every client request follows the same pipeline.

```
Flutter

↓

Authentication Check

↓

Firestore Security Rules

↓

Repository

↓

Service Layer

↓

Business Validation

↓

Firestore Write

↓

Audit Log (if applicable)

↓

Notification (if applicable)

↓

Response
```

No client request bypasses this flow.

---

# FIRESTORE ACCESS FLOW

Repositories provide the only access to Firestore.

```
Flutter

↓

Repository

↓

Firestore
```

Complex operations use:

```
Flutter

↓

Service

↓

Repository A

↓

Repository B

↓

Repository C

↓

Firestore Transaction
```

Repositories must not communicate directly with one another.

Services coordinate multiple repositories.

---

# SECURITY RULE STRATEGY

Every Firestore write follows four validation stages.

```
Authentication

↓

Role Validation

↓

Ownership Validation

↓

Business Rule Validation

↓

Allow Write
```

---

## Authentication Validation

Examples:

- User logged in
- Token valid
- Session active

---

## Role Validation

Examples:

Customer

↓

Owner

↓

Admin

Each collection validates permitted roles.

---

## Ownership Validation

Examples:

Customer

↓

Own Subscription

↓

Allowed

Owner

↓

Different Owner's Mess

↓

Denied

---

## Business Rule Validation

Examples:

- Active subscription
- Attendance window
- Leave lock
- Review eligibility
- Owner subscription active
- Registration enabled

Only after all checks pass may data be written.

---

# PAYMENT VERIFICATION PIPELINE

Version 1 uses Make.com for payment automation.

```
Customer

↓

UPI Payment

↓

Paytm Business

↓

Dedicated Gmail

↓

Make.com

↓

Gemini AI Extraction

↓

Webhook

↓

Firestore

↓

Subscription Activated

↓

Customer Notification

↓

Owner Notification
```

---

## Payment Verification Steps

1.

Customer initiates payment.

↓

Payment Intent created.

2.

Customer completes UPI payment.

↓

Paytm Business email received.

3.

Dedicated Gmail receives payment notification.

↓

4.

Make.com processes email.

↓

5.

Gemini extracts:

- Amount
- Sender
- Timestamp
- Reference Number

↓

6.

Webhook sends structured payload.

↓

7.

Backend validates:

- Matching amount
- Customer
- Time window
- Duplicate detection

↓

8.

Payment marked verified.

↓

9.

Subscription activated.

↓

10.

Notifications generated.

---

# MAKE.COM RESPONSIBILITIES

Make.com performs:

- Gmail Monitoring
- Email Parsing
- Gemini Invocation
- Payload Formatting
- Webhook Delivery

Make.com never modifies Firestore directly.

Firestore updates occur only after backend validation.

---

# GEMINI RESPONSIBILITIES

Gemini is responsible only for data extraction.

Gemini extracts:

- Amount
- Sender
- Timestamp
- Transaction Reference

Gemini never:

- Activates subscriptions
- Verifies payments
- Writes Firestore data
- Determines permissions

Gemini is an assistant, not an authority.

---

# NOTIFICATION ARCHITECTURE

Notifications follow an event-driven pipeline.

```
Business Event

↓

Notification Service

↓

Firestore Notification

↓

FCM

↓

Flutter

↓

Notification Screen
```

Notification content is stored in Firestore.

FCM delivers only a push signal.

Flutter retrieves the complete notification from Firestore.

---

# EVENT PROCESSING MODEL

Every major business action becomes an event.

Examples:

Customer Registered

↓

Owner Approved

↓

Mess Approved

↓

Join Request Created

↓

Subscription Purchased

↓

Payment Verified

↓

Attendance Recorded

↓

Review Submitted

↓

Owner Subscription Renewed

↓

Maintenance Mode Enabled

Events trigger:

- Notifications
- Analytics Updates
- Audit Logs
- Dashboard Cache Refresh
- Scheduled Jobs (when required)

Business events should remain independent.

Failure in one event must not corrupt unrelated platform data.

---

# BACKGROUND JOB ARCHITECTURE

The backend executes scheduled jobs to maintain platform health.

These jobs run independently of user activity.

Background jobs should be:

- Idempotent
- Retryable
- Logged
- Monitored

Every execution creates a System Audit Log.

---

# SCHEDULED JOBS

## Subscription Expiry Job

Frequency

Every Hour

Responsibilities

- Find expired subscriptions
- Change status to Expired
- Refresh dashboard cache
- Notify customer
- Notify owner

---

## Owner Subscription Expiry Job

Frequency

Daily

Responsibilities

- Move Active → Renewal Due
- Move Renewal Due → Grace Period
- Move Grace Period → Expired
- Freeze associated messes
- Notify owner

---

## Leave Lock Job

Frequency

Daily

Responsibilities

- Lock leave requests
- Prevent further modification

---

## Attendance Cleanup Job

Frequency

Daily

Responsibilities

- Expire pending attendance requests
- Archive completed requests

---

## Payment Retry Job

Frequency

Every Hour

Responsibilities

- Retry failed webhook verification
- Retry delayed Gmail processing
- Retry temporary automation failures

Retries should respect the configured retry limit.

---

## Notification Cleanup Job

Frequency

Daily

Responsibilities

- Archive old notifications
- Remove expired notifications
- Refresh unread counts

---

## Analytics Refresh Job

Frequency

Daily

Responsibilities

- Update Daily Analytics
- Update Monthly Analytics
- Update Platform Statistics
- Refresh Dashboard Cache

---

## Audit Maintenance Job

Frequency

Weekly

Responsibilities

- Archive old audit logs
- Verify log integrity
- Generate audit summary

Audit records must never be deleted.

---

# CACHING STRATEGY

Frequently accessed information should be cached.

Examples

Owner Dashboard

Customer Dashboard

Platform Statistics

Analytics

Unread Notification Count

Caches reduce Firestore reads.

---

## Cache Invalidation

Caches refresh after:

- Subscription Activation
- Subscription Expiry
- Attendance Recorded
- Leave Submitted
- Join Request Approved
- Payment Verified
- Review Submitted
- Owner Subscription Renewal

Stale cache should never be shown longer than necessary.

---

# DASHBOARD AGGREGATION

Dashboard data should never be calculated directly from raw collections during screen load.

Instead

```
Business Event

↓

Aggregation Service

↓

Dashboard Cache

↓

Flutter Dashboard
```

Advantages

- Faster loading
- Lower Firestore reads
- Better scalability

---

# ERROR HANDLING STRATEGY

Errors are divided into categories.

---

## Validation Error

Examples

- Invalid Phone Number
- Invalid QR
- Missing Required Field

User receives actionable feedback.

---

## Business Rule Error

Examples

- Subscription Expired
- Review Not Eligible
- Attendance Window Closed
- Leave Locked

Business rule failures should explain why the operation was rejected.

---

## Permission Error

Examples

- Access Denied
- Wrong Owner
- Wrong Customer

Security errors must never expose sensitive information.

---

## System Error

Examples

- Firestore Failure
- Make Timeout
- Gmail Unavailable
- Internal Exception

System errors should be logged automatically.

---

## Network Error

Examples

- Offline
- Slow Internet
- Timeout

The application should retry where appropriate.

---

# LOGGING STRATEGY

Every important backend action should generate logs.

Log categories

Authentication

Payments

Attendance

Notifications

Analytics

Webhook

Infrastructure

Security

Audit

---

## Log Levels

INFO

Normal operations

WARNING

Unexpected but recoverable

ERROR

Operation failed

CRITICAL

Platform requires immediate attention

---

# MONITORING STRATEGY

Platform health should continuously monitor:

- Firestore availability
- Authentication failures
- Payment verification failures
- Webhook failures
- Make automation failures
- Gmail failures
- Notification delivery failures

Administrators should receive alerts for critical failures.

---

# PERFORMANCE STRATEGY

Backend performance goals

Authentication

< 500 ms

Firestore Reads

< 300 ms

Dashboard Load

< 1 second

Payment Verification

Typically < 2 minutes after payment notification

Notification Delivery

Within 30 seconds of event completion

These targets should be reviewed as the platform scales.

---

# TRANSACTION STRATEGY

Use Firestore Transactions when:

- Updating multiple collections
- Activating subscriptions
- Recording attendance
- Approving join requests
- Updating counters

Use Batch Writes when:

- Sending notifications
- Updating dashboard caches
- Refreshing analytics

Avoid long-running transactions.

---

# OFFLINE STRATEGY

Flutter supports limited offline access.

Cached locally

- Profile
- Active Subscriptions
- Notices
- Previously loaded Reviews

Never cached for write operations

- Payments
- Attendance Submission
- Attendance Approval
- Join Requests
- Global Settings

When connectivity returns:

Pending reads refresh automatically.

Critical writes always require server validation.

---

# DEPLOYMENT STRATEGY

The backend should support multiple deployment environments.

Development

↓

Staging

↓

Production

Each environment must remain completely isolated.

This includes:

- Firebase Project
- Firestore Database
- Firebase Storage
- Firebase Authentication
- Firebase Cloud Messaging
- Make.com Account
- Gmail Account
- Webhook URLs

Production data must never be used during development or testing.

---

# ENVIRONMENT CONFIGURATION

## Development

Purpose

Feature development and testing.

Characteristics

- Test Firebase Project
- Test Make.com Account
- Test Gmail
- Dummy UPI Payments
- Debug Logging Enabled

---

## Staging

Purpose

Pre-production validation.

Characteristics

- Mirrors Production
- Real integrations
- Limited test users
- Performance testing
- Release candidate testing

---

## Production

Purpose

Live customer environment.

Characteristics

- Stable releases only
- Production Firebase
- Production Make accounts
- Production Gmail accounts
- Production monitoring
- Daily backups

---

# SECRETS MANAGEMENT

Sensitive credentials must never be stored:

- Inside Flutter source code
- Inside GitHub repositories
- Inside Firestore documents accessible to clients

Secrets include:

- Firebase Service Accounts
- Gemini API Keys
- Make API Keys
- Gmail Credentials
- Webhook Signing Secrets

Future server-side implementations should use secure secret management (for example, environment variables or managed secret storage).

---

# BACKUP & DISASTER RECOVERY

## Firestore

Daily automated backups.

Weekly backup verification.

Monthly restore testing.

---

## Firebase Storage

Daily backup.

Deleted files recoverable within retention policy.

---

## Make.com

Export scenarios after major changes.

Maintain version history for automation workflows.

---

## Recovery Objectives

Target Recovery Time (RTO)

Less than 4 hours.

Target Recovery Point (RPO)

Less than 24 hours.

These targets may be tightened as the platform grows.

---

# SECURITY BEST PRACTICES

The backend must enforce:

- Principle of Least Privilege
- Role-based Access Control
- Firestore Security Rules
- Immutable Financial Records
- Audit Logging
- Secure Authentication
- Input Validation
- Server-side Authorization

Client-side checks are for user experience only and must never replace backend enforcement.

---

# FUTURE CLOUD FUNCTIONS ROADMAP

Cloud Functions should be introduced only when they provide clear value.

Potential responsibilities:

Authentication

- Create default user profile
- Initialize owner profile
- Send welcome notification

Payments

- Payment reconciliation
- Scheduled verification retries
- Fraud detection

Attendance

- Attendance analytics
- Missed attendance summaries

Notifications

- Scheduled reminders
- Topic broadcasts
- Quiet-hour delivery

Analytics

- Daily aggregation
- Monthly aggregation
- Dashboard cache refresh

Maintenance

- Cleanup expired notifications
- Archive reports
- Refresh statistics

The initial release should continue using Make.com for payment automation unless server-side processing becomes necessary.

---

# CODING STANDARDS

Backend implementation should follow consistent standards.

Naming

- snake_case for Firestore collections
- camelCase for Dart variables
- PascalCase for Dart classes

Documentation

- Public services should be documented.
- Complex business logic should include explanatory comments.

Error Handling

- Fail gracefully.
- Return meaningful error messages.
- Log unexpected failures.

Testing

Every business service should be independently testable.

Repository layer should remain isolated from business logic.

---

# OBSERVABILITY

The backend should provide visibility into operational health.

Recommended monitoring includes:

- Authentication success/failure rate
- Payment verification success rate
- Webhook delivery success rate
- Firestore read/write errors
- Notification delivery success
- Scheduled job execution
- Average dashboard response time

Critical failures should generate Administrator notifications.

---

# ARCHITECTURAL DECISION RECORDS (ADR)

Major architectural decisions should be documented before implementation.

Examples:

- Migration from Make.com to Cloud Functions
- Introducing additional payment providers
- Multi-state expansion
- Staff accounts
- Franchise support
- AI-powered recommendations

Recording decisions helps preserve project history and reasoning.

---

# FUTURE SCALING ROADMAP

Current Architecture

↓

Pilot Deployment

↓

City Expansion

↓

Multi-City Deployment

↓

State-wide Deployment

↓

Multi-State Deployment

At every stage:

- Firestore schema remains unchanged.
- Business rules remain centralized.
- Security model remains consistent.
- Automation scales horizontally.

No major redesign should be required.

---

# VERSION HISTORY

| Version | Status | Description |
|----------|--------|-------------|
| 1.0 | Production Ready | Initial backend architecture documenting Firebase services, repository and service layers, payment automation, security strategy, deployment environments, observability, disaster recovery, and implementation guidelines. |

---

# RELATED DOCUMENTS

This document should be read together with:

- 01_Firestore_Schema.md
- 02_Product_Spec.md
- 03_Permission_Matrix.md
- 04_State_Machines.md
- 05_Screen_Specification.md
- 06_Payment_Verification.md

Together these documents define the complete technical and business architecture of the Mazi Mess platform.

---

# DOCUMENT STATUS

Document Name:

Backend Architecture

Version:

1.0

Status:

Production Ready

Technology Stack

Frontend

- Flutter

Backend

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging

Automation

- Make.com
- Gmail
- Gemini AI

Maintained By

Mazi Mess Development Team

This document serves as the implementation blueprint for backend development and should be updated whenever architectural decisions significantly change.

---

END OF DOCUMENT