# 05_Screen_Specification.md

# PART 1 - CUSTOMER APPLICATION

---

# CUSTOMER NAVIGATION STRUCTURE

Bottom Navigation:

1. Home
2. Explore
3. My Subscription
4. Profile

Global Access:

* Notifications
* Reviews
* Payment History
* Attendance History
* Leave Management

---

# SPLASH SCREEN

Purpose:

Application startup and initialization.

Functions:

* Load app settings
* Load language preference
* Load theme preference
* Check authentication state
* Check account status

Loading Indicator:

Centered Mazi Mess logo with loading spinner.

Navigation:

Authenticated User
→ Role Router

Unauthenticated User
→ Login Screen

Suspended User
→ Account Suspended Screen

---

# LOGIN SCREEN

Purpose:

User authentication using mobile number.

Components:

App Logo

Title:
"Mazi Mess"

Subtitle:
"Find and Manage Your Mess Easily"

Input:

Mobile Number

Buttons:

Send OTP

Links:

Register New Account

Validation:

* Indian mobile number only
* 10 digits required

Actions:

Send OTP

Navigation:

OTP Verification Screen

---

# OTP VERIFICATION SCREEN

Purpose:

Verify phone ownership.

Components:

OTP Input

Countdown Timer

Buttons:

Verify OTP

Resend OTP

States:

Loading

Success

Invalid OTP

Expired OTP

Navigation:

Successful Login
→ Role Router

---

# REGISTRATION SCREEN

Purpose:

Create customer account.

Fields:

Full Name

Date of Birth

Gender

Mobile Number

Email Address

Present Address

Profile Photo (Optional)

Buttons:

Register

Validation:

Required:

* Name
* DOB
* Gender
* Mobile
* Email
* Address

Optional:

* Profile Photo

Navigation:

Successful Registration
→ Customer Home

---

##################################################

# CUSTOMER HOME SCREEN

##################################################

Purpose:

Customer dashboard.

App Bar:

Greeting

Example:

"Good Morning, Omkar"

Notification Bell

Body Sections:

1. Current Subscription Card

Displays:

Mess Name

Plan Name

Days Remaining

Subscription Status

Buttons:

Renew

View Details

States:

Active

Expiring Soon

Expired

No Subscription

---

2. Today's QR Status Card

Displays:

Meal Type

QR Availability

Attendance Status

States:

QR Available

Already Used

Leave Day

No Active Subscription

Button:

Generate QR

---

3. Latest Notices

Displays:

Title

Category

Date

Maximum:
Latest 5 Notices

Button:

View All

---

4. Quick Actions

Buttons:

Leave Calendar

Attendance History

Payment History

Reviews

---

##################################################

# EXPLORE SCREEN

##################################################

Purpose:

Discover messes.

Components:

Search Bar

Search By:

Mess Name

Mess ID

Filters:

Veg

Non-Veg

Both

Rating

Sort:

Distance (Default)

Sponsored Section

Verified Mess Section

Mess List

---

Mess Card

Displays:

Cover Image

Mess Name

Distance

Rating

Food Type

Starting Price

Verified Badge

New Badge (First 15 Customers)

Buttons:

View Details

---

Empty State:

"No Messes Found"

---

##################################################

# MESS DETAILS SCREEN

##################################################

Purpose:

View complete mess information.

Sections:

1. Image Gallery

Cover Image

Gallery Images

Swipe Enabled

---

2. Basic Information

Mess Name

Rating

Address

Distance

Food Type

Description

Verified Badge

---

3. Available Plans

Plan Card Displays:

Plan Name

Price

Duration

Meals Included

Buttons:

Select Plan

---

4. Reviews

Average Rating

Review Count

Review List

Owner Replies

Button:

View All Reviews

---

5. Location

Google Map Preview

Buttons:

Directions

Call Owner

---

Primary Button:

Join Mess

---

##################################################

# JOIN REQUEST SCREEN

##################################################

Purpose:

Submit join request.

Displays:

Selected Mess

Selected Plan

Price

Duration

Meals

Terms Reminder

Buttons:

Submit Join Request

Cancel

States:

Submitting

Submitted

Failed

Navigation:

Join Request Status Screen

---

##################################################

# JOIN REQUEST STATUS SCREEN

##################################################

Purpose:

Track approval status.

States:

Pending

Approved

Rejected

Expired

Displays:

Status Badge

Request Date

Owner Response

Payment Deadline

Actions:

Pay Now (Approved)

Submit New Request (Rejected)

---

##################################################

# PAYMENT SCREEN

##################################################

Purpose:

Subscription payment.

Displays:

Mess Name

Plan Name

Amount

UPI ID

Payment QR

Payment Instructions

Buttons:

Open UPI App

I Have Paid

States:

Pending

Under Verification

Verified

Failed

---

Warnings:

Subscription activates only after verification.

---

##################################################

# MY SUBSCRIPTIONS SCREEN

##################################################

Purpose:

Manage subscriptions.

Displays:

Active Subscriptions

Expired Subscriptions

Each Card Shows:

Mess Name

Plan Name

Start Date

End Date

Days Remaining

Status

Actions:

Renew

View Attendance

Manage Leave

View Payments

---

##################################################

# ATTENDANCE SCREEN

##################################################

Purpose:

Attendance records.

Summary Cards:

Present

Leave

Calculated Absent

History List

Fields:

Date

Meal

Status

Filters:

Today

This Week

This Month

---

##################################################

# QR SCREEN

##################################################

Purpose:

Generate attendance QR.

Displays:

Customer Name

Mess Name

Meal Type

Timestamp

Live QR

Rules:

QR Refresh Every Minute

Single Use

Screenshot Disabled

States:

Available

Used

Expired

Leave Day

---

##################################################

# LEAVE MANAGEMENT SCREEN

##################################################

Purpose:

Manage future leave dates.

Calendar View

Highlighted States:

Leave Marked

Locked

Today

Selectable

Actions:

Add Leave Date

Cancel Leave Date

Rules:

Must be submitted at least 2 days before.

Locked dates cannot be edited.

---

##################################################

# PAYMENT HISTORY SCREEN

##################################################

Purpose:

View payments.

Displays:

Date

Amount

Mess Name

Status

Transaction Reference

Filters:

All

Verified

Failed

---

##################################################

# REVIEWS SCREEN

##################################################

Purpose:

Review management.

Eligibility Banner

Displays:

Rating

Review

Owner Reply

Actions:

Write Review

Edit Review

Delete Review

Rules:

Editable for 2 minutes only.

One review per mess.

---

##################################################

# PROFILE SCREEN

##################################################

Purpose:

Manage account.

Displays:

Profile Photo

Name

Phone

Email

Address

Language

Theme

Notification Preference

Actions:

Change Mobile Number

Edit Profile

Logout

Delete Account Request

---

##################################################

# NOTIFICATION CENTER

##################################################

Purpose:

View notifications.

Displays:

Notification List

Unread Indicator

Timestamp

Actions:

Open Related Screen

Mark As Read

Filters:

All

Unread

Read

Empty State:

"No Notifications"




# PART 2 - OWNER APPLICATION

---

# OWNER NAVIGATION STRUCTURE

Bottom Navigation:

1. Dashboard
2. Customers
3. Analytics
4. Settings

Global Access:

* Mess Switcher
* Join Requests
* Attendance Scanner
* Plan Management
* Notice Management
* Notifications

---

# OWNER DASHBOARD

Purpose:

Primary operational screen.

App Bar:

Current Mess Name

Mess Switcher Button

Notification Bell

Body Sections:

---

1. Today's Expected Meals

Displays:

Breakfast Count

Lunch Count

Dinner Count

Calculation:

Active Customers

* Leave Customers
  = Expected Meals

---

2. Pending Join Requests

Displays:

Pending Count

Recent Requests

Button:

View All Requests

---

3. Expiring Customers

Displays:

Customers expiring within 2 days

Count

Button:

View All

---

4. Revenue Summary

Displays:

Current Month Revenue

Verified Payments Only

Button:

View Analytics

---

5. Quick Actions

Buttons:

Scan Attendance

Create Notice

Manage Plans

Add Customer

---

##################################################

# MESS SWITCHER SCREEN

##################################################

Purpose:

Switch between owned messes.

Displays:

Mess Name

Status

Customer Count

Rating

Actions:

Switch

View Details

Create New Mess

States:

Active

Frozen

Pending Approval

Delisted

---

##################################################

# JOIN REQUESTS SCREEN

##################################################

Purpose:

Approve or reject new customers.

Displays:

Customer Photo

Customer Name

Age

Gender

Requested Plan

Request Date

Status

Actions:

Approve

Reject

View Profile

---

Reject Flow:

Reason Required

Confirm Rejection

---

Approve Flow:

Approve

Notification Sent To Customer

---

##################################################

# CUSTOMER MANAGEMENT SCREEN

##################################################

Purpose:

Manage all customers.

Search:

Name

Mobile Number

Filters:

Active

Expired

Due In 2 Days

Blacklisted

Sorting:

Expiry Date

Newest First

Name

---

Customer Card

Displays:

Photo

Name

Plan

Days Remaining

Status

Actions:

View Profile

Extend Subscription

Blacklist

Add Note

Remove Customer

---

Empty State:

No Customers Found

---

##################################################

# CUSTOMER PROFILE SCREEN

##################################################

Purpose:

View customer details.

Displays:

Profile Photo

Name

Age

Gender

Phone

Address

Current Subscription

Attendance Summary

Payment History

Private Notes

---

Actions:

Add Note

Edit Note

Extend Subscription

Blacklist Customer

Remove Customer

---

Restrictions:

Profile hidden after subscription expires.

Only historical subscription data remains visible.

---

##################################################

# PLAN MANAGEMENT SCREEN

##################################################

Purpose:

Create and manage plans.

Displays:

All Active Plans

Inactive Plans

---

Plan Card

Displays:

Plan Name

Price

Duration

Meals Included

Status

Actions:

Edit

Deactivate

Duplicate

---

Create Plan

Fields:

Plan Name

Price

Duration

Meals Included

Meal Timings

Description

---

Validation:

Price > 0

Duration > 0

At least one meal selected

---

##################################################

# ATTENDANCE SCANNER SCREEN

##################################################

Purpose:

Attendance verification.

Uses:

Device Camera

---

Scanner View

Displays:

Camera Preview

Scanning Area

Torch Toggle

---

Success Screen

Displays:

Customer Name

Meal Type

Time

Status:

Attendance Marked

---

Failure States:

QR Expired

QR Already Used

Invalid QR

Wrong Meal Window

No Active Subscription

---

Actions:

Scan Again

---

##################################################

# ATTENDANCE HISTORY SCREEN

##################################################

Purpose:

Attendance overview.

Displays:

Date

Customer Name

Meal

Status

Time

Filters:

Today

This Week

This Month

Customer

Meal Type

---

##################################################

# NOTICE MANAGEMENT SCREEN

##################################################

Purpose:

Create and manage notices.

Displays:

Active Notices

Expired Notices

---

Notice Card

Displays:

Title

Category

Expiry Date

Created Date

Actions:

Edit

Delete

---

Create Notice

Fields:

Title

Description

Category

Expiry Date

---

Categories:

General

Holiday

Menu Change

Payment Reminder

Emergency

---

##################################################

# ANALYTICS SCREEN

##################################################

Purpose:

Business insights.

Summary Cards:

Active Customers

Total Customers

Revenue

New Admissions

Attendance Percentage

---

Charts:

Customer Growth

Revenue Trend

Attendance Trend

---

Filters:

Today

This Week

This Month

Custom Range

---

##################################################

# PAYMENT RECORDS SCREEN

##################################################

Purpose:

View customer payment records.

Displays:

Customer Name

Plan

Amount

Status

Verification Date

Transaction Reference

Filters:

Verified

Failed

Date Range

---

Restriction:

Only payments related to current owner's messes.

---

##################################################

# BLACKLIST MANAGEMENT SCREEN

##################################################

Purpose:

Manage blocked customers.

Displays:

Customer Name

Reason

Blacklist Date

Actions:

Remove From Blacklist

View Profile

---

Rules:

Blacklist affects all messes owned by same owner.

Customer cannot submit join requests while blacklisted.

---

##################################################

# OWNER NOTES SCREEN

##################################################

Purpose:

Private customer notes.

Displays:

Customer Name

Note

Created Date

Last Updated

Actions:

Add Note

Edit Note

Delete Note

---

Visibility:

Owner Only

Admin Visible

Customer Never Visible

---

##################################################

# OWNER SETTINGS SCREEN

##################################################

Purpose:

Manage mess settings.

Sections:

---

1. Basic Information

Mess Name

Description

Contact Number

Address

---

2. Capacity

Current Capacity

Current Customers

Update Capacity

---

3. Gallery

Cover Image

Gallery Images

Actions:

Add

Remove

Reorder

Replace

---

4. UPI Information

Display Only

Paytm Business UPI ID

Editable:

No

Admin Approval Required For Changes

---

5. App Preferences

Language

Theme

Notifications

---

6. Account Actions

Logout

Request Delisting

Delete Mess Request

---

Rules:

Delete request allowed only when customer count is below platform threshold.

Delisting requires admin approval.

---

##################################################

# OWNER NOTIFICATION CENTER

##################################################

Purpose:

Owner notifications.

Types:

New Join Request

Review Received

Feedback Received

Leave Added

Owner Subscription Expiring

Notice Expired

Payment Verified

Actions:

Open Related Screen

Mark As Read

Filters:

All

Unread

Read



# PART 3 - ADMIN APPLICATION

---

# ADMIN NAVIGATION STRUCTURE

Bottom Navigation:

1. Dashboard
2. Moderation
3. Payments
4. Settings

Global Access:

* Owner Approvals
* Mess Approvals
* User Management
* Review Moderation
* Feedback Moderation
* Audit Logs
* Payment Monitoring

---

##################################################

# ADMIN DASHBOARD

##################################################

Purpose:

Platform overview and monitoring.

Summary Cards:

Pending Owner Approvals

Pending Mess Approvals

Reported Reviews

Reported Feedback

Active Owners

Active Customers

Active Messes

Platform Revenue

---

Quick Actions:

Review Approvals

Review Reports

Payment Monitoring

Audit Logs

Global Settings

---

Recent Activity Feed:

Displays:

User

Action

Timestamp

Example:

Owner Approved

Mess Delisted

Review Removed

Payment Overridden

---

##################################################

# OWNER APPROVAL SCREEN

##################################################

Purpose:

Verify new owner registrations.

Displays:

Owner Name

Phone Number

Email

Address

Owner Photo

Aadhaar Number

Verification Status

Registration Date

---

Actions:

Approve

Reject

Suspend

Request Additional Documents

---

Approval Flow:

Approve
↓
Owner Account Activated
↓
Owner Notified

---

Rejection Flow:

Reason Required

Owner Notified

Status:
Rejected

---

##################################################

# MESS APPROVAL SCREEN

##################################################

Purpose:

Review newly registered messes.

Displays:

Mess Name

Owner Name

Address

Location Map

Contact Number

Capacity

Gallery Images

Verification Documents

---

Actions:

Approve

Reject

Freeze

Delist

Delete

---

Status Filters:

Pending

Active

Frozen

Delisted

Deleted

---

##################################################

# USER MANAGEMENT SCREEN

##################################################

Purpose:

Manage platform users.

Tabs:

Customers

Owners

Admins

---

Search:

Name

Phone Number

User ID

---

User Card Displays:

Name

Role

Status

Registration Date

---

Actions:

View Profile

Suspend

Reactivate

Soft Delete

View History

---

##################################################

# USER PROFILE SCREEN

##################################################

Purpose:

Detailed user inspection.

Displays:

Profile Photo

Name

Phone Number

Email

Address

Role

Status

Created Date

---

Customer View Includes:

Subscription History

Payment History

Review History

Blacklist Count

Attendance Summary

---

Owner View Includes:

Owned Messes

Customer Counts

Revenue Summary

Owner Subscription Status

Verification Status

---

Actions:

Suspend

Reactivate

View Audit Logs

---

##################################################

# REVIEW MODERATION SCREEN

##################################################

Purpose:

Moderate public reviews.

Displays:

Review

Rating

Reviewer

Mess

Owner Reply

Report Count

Created Date

---

Actions:

Keep Review

Remove Review

Suspend Reviewer

Suspend Owner

---

Filters:

Reported

Newest

Oldest

Rating

---

##################################################

# FEEDBACK MODERATION SCREEN

##################################################

Purpose:

Moderate reported private feedback.

Displays:

Feedback Text

Customer

Mess

Owner

Report Reason

Created Date

---

Actions:

Keep Feedback

Remove Feedback

Suspend Customer

---

Filters:

Reported

Newest

Oldest

---

##################################################

# PAYMENT MONITORING SCREEN

##################################################

Purpose:

Monitor custom payment verification system.

Summary Cards:

Pending Verification

Verified Today

Failed Today

Manual Overrides

---

Payment Intent Table

Displays:

Payment Intent ID

Customer

Mess

Amount

Status

Created Time

---

Actions:

Open Details

Verify Manually

Mark Failed

Issue Refund Status

Admin Override

---

Payment Detail View

Displays:

Customer

Mess

Subscription

Amount

Transaction Reference

Webhook ID

Webhook Status

Verification Timestamp

Verification Logs

---

##################################################

# WEBHOOK MONITORING SCREEN

##################################################

Purpose:

Track Make.com integration.

Displays:

Webhook ID

Received Time

Payload Status

Processing Result

Related Payment Intent

---

Status Types:

Success

Pending

Failed

Duplicate

---

Actions:

Retry Processing

View Payload

View Logs

---

##################################################

# AUDIT LOG SCREEN

##################################################

Purpose:

Immutable system audit trail.

Displays:

Actor

Role

Action

Target Type

Target ID

Timestamp

Metadata

---

Filters:

Date Range

Role

Action Type

User

Mess

---

Rules:

Read Only

Never Editable

Never Deletable

---

##################################################

# CUSTOMER REPUTATION SCREEN

##################################################

Purpose:

Internal moderation records.

Displays:

Customer Name

Blacklist Count

Total Reports

Last Report Date

---

Actions:

View Details

Reset Reputation

Add Internal Note

---

Visibility:

Admin Only

---

##################################################

# OWNER SUBSCRIPTIONS SCREEN

##################################################

Purpose:

Manage Mazi Mess owner subscriptions.

Displays:

Owner

Plan

Start Date

End Date

Status

Days Remaining

---

Statuses:

Trial

Active

Grace Period

Expired

Suspended

---

Actions:

Activate

Extend

Suspend

Reactivate

---

##################################################

# FEATURED LISTINGS MANAGEMENT

##################################################

Purpose:

Manage promoted messes.

Displays:

Mess Name

Owner

Current Position

Promotion Status

Start Date

End Date

---

Actions:

Feature

Unfeature

Change Position

Extend Promotion

---

##################################################

# GLOBAL SETTINGS SCREEN

##################################################

Purpose:

Platform-wide controls.

Sections:

---

Registration Controls

Customer Registration Enabled

Owner Registration Enabled

---

Payment Controls

Payment Verification Enabled

Manual Verification Enabled

Webhook Processing Enabled

---

Platform Controls

Maintenance Mode

Force Update Version

Default Language

---

Content Controls

Review System Enabled

Feedback System Enabled

Attendance System Enabled

---

Actions:

Save Changes

Publish Changes

---

##################################################

# ADMIN NOTIFICATION CENTER

##################################################

Purpose:

Admin alerts and operational notifications.

Types:

New Owner Registration

New Mess Registration

Payment Verification Failure

Webhook Failure

Reported Review

Reported Feedback

System Warning

---

Actions:

Open Related Screen

Mark Read

Archive

---

Filters:

Unread

Read

Critical

All

---

##################################################

# ADMIN ANALYTICS SCREEN

##################################################

Purpose:

Platform-wide analytics.

Displays:

Total Customers

Total Owners

Total Messes

Monthly Revenue

Active Subscriptions

Attendance Statistics

Review Statistics

Growth Charts

---

Filters:

Today

This Week

This Month

Custom Range

---

Exports:

CSV

Excel

PDF



# PART 4 - GLOBAL SCREENS & SHARED FLOWS

---

# ROLE ROUTER SCREEN

Purpose:

Determine destination after login.

Logic:

If role = customer
→ Customer Home

If role = owner
→ Owner Dashboard

If role = admin
→ Admin Dashboard

States:

Loading

Role Not Found

Account Suspended

---

##################################################

# ACCOUNT SUSPENDED SCREEN

##################################################

Purpose:

Display account suspension information.

Displays:

Account Status

Reason

Support Contact Information

Actions:

Contact Support

Logout

Restrictions:

No app access while suspended.

---

##################################################

# EDIT PROFILE SCREEN

##################################################

Purpose:

Update personal profile information.

Displays:

Profile Photo

Name

Email

Address

Actions:

Update Profile

Change Profile Photo

Save Changes

Restrictions:

Cannot edit:

* Date Of Birth
* Mobile Number

Mobile Number Change handled separately.

---

##################################################

# CHANGE MOBILE NUMBER SCREEN

##################################################

Purpose:

Secure mobile number replacement.

Flow:

Step 1

Verify Existing Number

OTP Verification

↓

Step 2

Enter New Number

OTP Verification

↓

Replace Number

Success

Rules:

Both OTP verifications mandatory.

---

##################################################

# LANGUAGE SELECTION SCREEN

##################################################

Purpose:

Choose application language.

Options:

English

Marathi

Hindi

Actions:

Save

Preview Language

Applies To:

Entire Application

---

##################################################

# THEME SETTINGS SCREEN

##################################################

Purpose:

Choose visual theme.

Options:

Light

Dark

System Default

Actions:

Save

Preview Theme

Applies Instantly

---

##################################################

# NOTIFICATION SETTINGS SCREEN

##################################################

Purpose:

Manage notification preferences.

Options:

Enable Notifications

Disable Notifications

Categories:

Payment Notifications

Subscription Notifications

Review Notifications

Notice Notifications

System Notifications

Actions:

Save

---

##################################################

# SEARCH SCREEN

##################################################

Purpose:

Global search experience.

Search Types:

Mess Name

Mess Code

Customer Name (Owner/Admin)

Phone Number (Owner/Admin)

Displays:

Recent Searches

Search Results

Filters

Sorting

---

##################################################

# IMAGE VIEWER SCREEN

##################################################

Purpose:

View uploaded images.

Supported Images:

Mess Images

Profile Photos

Verification Documents

Functions:

Zoom

Swipe

Download (Admin Only)

---

##################################################

# MAP VIEW SCREEN

##################################################

Purpose:

Display mess location.

Displays:

Google Map

Mess Marker

User Location

Actions:

Get Directions

Open Google Maps

Call Owner

---

##################################################

# DOCUMENT VIEW SCREEN

##################################################

Purpose:

View verification documents.

Supported Users:

Admin

Displays:

Owner Documents

Mess Verification Documents

Actions:

Approve

Reject

Download

---

##################################################

# SUPPORT SCREEN

##################################################

Purpose:

Contact platform support.

Displays:

Support Contact Number

Support Email

FAQ Link

Actions:

Call Support

Send Email

Create Support Ticket

---

##################################################

# SUPPORT TICKET SCREEN

##################################################

Purpose:

Submit issue to platform team.

Fields:

Issue Category

Title

Description

Attachment (Optional)

Actions:

Submit Ticket

Cancel

Categories:

Technical Issue

Payment Issue

Subscription Issue

Attendance Issue

Review Issue

Other

---

##################################################

# TICKET HISTORY SCREEN

##################################################

Purpose:

Track support requests.

Displays:

Ticket Number

Status

Created Date

Updated Date

States:

Open

In Progress

Resolved

Closed

Actions:

View Details

Reply

Close Ticket

---

##################################################

# DELETE ACCOUNT REQUEST SCREEN

##################################################

Purpose:

Request account deletion.

Displays:

Warning Message

Consequences

Retention Policy

Actions:

Submit Request

Cancel

Rules:

Account is soft deleted.

Payments remain stored.

Audit logs remain stored.

---

##################################################

# EMPTY STATE SCREEN COMPONENTS

##################################################

Reusable Components

No Notifications

No Subscriptions

No Reviews

No Search Results

No Customers

No Join Requests

No Attendance Records

No Payments

Button:

Refresh

---

##################################################

# ERROR STATE COMPONENTS

##################################################

Reusable Error Screens

No Internet

Server Error

Permission Denied

Something Went Wrong

Actions:

Retry

Go Back

Contact Support

---

##################################################

# LOADING COMPONENTS

##################################################

Reusable Loading States

Page Loading

List Loading

Image Loading

Payment Verification Loading

QR Generation Loading

Displays:

Skeleton UI

Progress Indicator

---

##################################################

# SUCCESS SCREEN COMPONENTS

##################################################

Reusable Success States

Registration Successful

Join Request Submitted

Payment Verified

Subscription Activated

Attendance Marked

Notice Published

Actions:

Continue

Go To Home

View Details

---

##################################################

# LOGOUT CONFIRMATION DIALOG

##################################################

Purpose:

Prevent accidental logout.

Displays:

Confirmation Message

Actions:

Logout

Cancel

---

##################################################

# FORCE UPDATE SCREEN

##################################################

Purpose:

Mandatory app update.

Displays:

Current Version

Required Version

Update Notes

Actions:

Update Now

Restrictions:

Cannot bypass.

Controlled by Admin Settings.

---

##################################################

# MAINTENANCE MODE SCREEN

##################################################

Purpose:

Platform maintenance.

Displays:

Maintenance Message

Expected Return Time

Support Contact

Restrictions:

Application access disabled.

Admin may bypass.

---

##################################################

# PERMISSION REQUEST SCREENS

##################################################

Required Permissions

Camera

Storage

Notifications

Location

Displays:

Permission Explanation

Allow

Deny

Rules:

Request only when needed.

Never request all permissions at startup.

---

##################################################

# GLOBAL NAVIGATION RULES

##################################################

1. Back button returns to previous screen.

2. Authentication required for all protected screens.

3. Suspended users cannot access protected screens.

4. Notifications always accessible from App Bar.

5. Language and Theme changes apply immediately.

6. Force Update overrides all navigation.

7. Maintenance Mode overrides all navigation except admin access.





# PART 5 - NAVIGATION MAP & USER JOURNEYS

---

# APPLICATION ROOT FLOW

App Launch
↓
Splash Screen
↓
Authentication Check

If Not Logged In
↓
Login Screen

If Logged In
↓
Role Router

Customer
↓
Customer Home

Owner
↓
Owner Dashboard

Admin
↓
Admin Dashboard

---

##################################################

# CUSTOMER JOURNEYS

##################################################

# JOURNEY 1

CUSTOMER REGISTRATION

Login
↓
Register
↓
Enter Details
↓
Verify OTP
↓
Customer Account Created
↓
Customer Home

Success Condition:

Customer can access application.

---

# JOURNEY 2

DISCOVER MESS

Customer Home
↓
Explore
↓
Search / Filter
↓
Mess Details
↓
View Plans

Success Condition:

Customer finds suitable mess.

---

# JOURNEY 3

JOIN MESS

Mess Details
↓
Select Plan
↓
Submit Join Request
↓
Pending Approval

Owner Approves
↓
Status = Approved
↓
Payment Screen
↓
Payment Verification
↓
Subscription Activated

Success Condition:

Active Subscription Created.

---

# JOURNEY 4

RENEW SUBSCRIPTION

My Subscription
↓
Renew
↓
Select Plan
↓
Payment
↓
Verification
↓
New Subscription Created

Success Condition:

Subscription renewed.

---

# JOURNEY 5

MARK LEAVE

Home
↓
Leave Management
↓
Select Dates
↓
Save Leave

Success Condition:

Leave dates stored.

---

# JOURNEY 6

ATTENDANCE

Home
↓
Generate QR
↓
Owner Scans
↓
Attendance Recorded

Success Condition:

Attendance marked present.

---

# JOURNEY 7

WRITE REVIEW

My Subscription
↓
Review Eligible
↓
Write Review
↓
Submit

Success Condition:

Review visible publicly.

---

# JOURNEY 8

PAYMENT HISTORY

Home
↓
Payment History
↓
View Details

Success Condition:

User can track payments.

---

##################################################

# OWNER JOURNEYS

##################################################

# JOURNEY 1

OWNER REGISTRATION

Register Owner
↓
Submit Documents
↓
Pending Verification

Admin Approves
↓
Owner Dashboard Activated

Success Condition:

Owner gains access.

---

# JOURNEY 2

REGISTER MESS

Owner Dashboard
↓
Create Mess
↓
Upload Photos
↓
Submit

Pending Approval
↓
Admin Approval
↓
Mess Active

Success Condition:

Mess visible to customers.

---

# JOURNEY 3

APPROVE CUSTOMER

Join Requests
↓
Review Request
↓
Approve

Customer Pays
↓
Payment Verified
↓
Subscription Active

Success Condition:

Customer added.

---

# JOURNEY 4

REJECT CUSTOMER

Join Requests
↓
Reject
↓
Provide Reason

Success Condition:

Customer notified.

---

# JOURNEY 5

CREATE PLAN

Plan Management
↓
Create Plan
↓
Configure Meals
↓
Save

Success Condition:

Plan available for purchase.

---

# JOURNEY 6

ATTENDANCE SCAN

Dashboard
↓
Scan Attendance
↓
Scan QR
↓
Validate
↓
Attendance Recorded

Success Condition:

Attendance marked.

---

# JOURNEY 7

CREATE NOTICE

Dashboard
↓
Create Notice
↓
Publish

Push Notification Sent

Success Condition:

Active customers notified.

---

# JOURNEY 8

MANAGE CUSTOMER

Customer List
↓
Customer Profile

Available Actions:

Add Note

Extend Subscription

Blacklist

Remove Customer

Success Condition:

Customer updated.

---

##################################################

# ADMIN JOURNEYS

##################################################

# JOURNEY 1

APPROVE OWNER

Admin Dashboard
↓
Owner Approval
↓
Review Documents
↓
Approve

Success Condition:

Owner activated.

---

# JOURNEY 2

APPROVE MESS

Mess Approval
↓
Review Details
↓
Approve

Success Condition:

Mess activated.

---

# JOURNEY 3

MODERATE REVIEW

Reported Reviews
↓
Review Content

Actions:

Keep

Remove

Suspend User

Success Condition:

Moderation completed.

---

# JOURNEY 4

PAYMENT OVERRIDE

Payment Monitoring
↓
Open Payment
↓
Review Logs

Actions:

Verify

Fail

Refund

Override

Success Condition:

Payment resolved.

---

# JOURNEY 5

USER MANAGEMENT

User Management
↓
Open Profile

Actions:

Suspend

Reactivate

Delete

Success Condition:

User status updated.

---

##################################################

# CROSS ROLE FLOWS

##################################################

# NOTIFICATION FLOW

System Event
↓
Notification Created
↓
Notification Delivered
↓
User Opens Notification
↓
Related Screen Opens

---

# SUPPORT FLOW

User
↓
Create Ticket
↓
Admin Reviews
↓
Respond
↓
Resolved

---

# ACCOUNT DELETION FLOW

User
↓
Delete Account Request
↓
Admin Review
↓
Soft Delete

Success Condition:

Account disabled.

---

##################################################

# ROUTING RULES

##################################################

Authentication Required:

All screens except:

* Splash
* Login
* OTP
* Registration

---

Role Restricted Screens:

Customer Screens
→ Customer Only

Owner Screens
→ Owner Only

Admin Screens
→ Admin Only

---

Navigation Guards:

Suspended Users
→ Account Suspended Screen

Maintenance Mode
→ Maintenance Screen

Force Update
→ Force Update Screen

---

##################################################

# DEEP LINK SUPPORT (FUTURE)

Supported Links

Join By QR

mazimess://join/{messCode}

---

Mess Details

mazimess://mess/{messId}

---

Notice

mazimess://notice/{noticeId}

---

Payment

mazimess://payment/{paymentIntentId}

---

Review

mazimess://review/{reviewId}

---

Future Expansion Only

Not Required For V1


