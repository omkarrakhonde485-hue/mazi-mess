\# MAZI MESS - SCREEN SPECIFICATION



Version: 2.0



Status: Production Ready



Platform



Flutter



Design System



Material Design 3



Supported Roles



\- Customer

\- Owner

\- Administrator



\---



\# PURPOSE



This document defines every screen, navigation flow, reusable component, and user interaction within the Mazi Mess platform.



This specification should be used together with:



\- Firestore Schema

\- Product Specification

\- Permission Matrix

\- State Machines

\- Payment Verification

\- Backend Architecture



\---



\# DESIGN PRINCIPLES



The application follows these UI principles.



• Clean



• Fast



• Consistent



• Accessible



• Mobile First



• Material Design 3



Every screen should provide:



\- Loading State

\- Empty State

\- Error State

\- Success State



Every action requiring backend communication should display progress feedback.



\---



\# ROLE-BASED APPLICATION FLOW



Customer



↓



Customer Dashboard



Owner



↓



Owner Dashboard



Administrator



↓



Admin Dashboard



Navigation and permissions are controlled by backend role validation.



\---



\##################################################

\# CUSTOMER APPLICATION

\##################################################



\---



\# SPLASH SCREEN



Purpose



Initialize application.



Responsibilities



\- Load local preferences

\- Restore authentication session

\- Check app version

\- Navigate to appropriate dashboard



Possible Destinations



Login



Customer Dashboard



Owner Dashboard



Admin Dashboard



Maintenance Screen



\---



\# LOGIN SCREEN



Purpose



Authenticate existing users.



Fields



Phone Number



Password



Buttons



Login



Forgot Password



Create Account



Validation



• Required fields



• Invalid credentials



• Suspended account



Success



Navigate based on user role.



\---



\# REGISTER SCREEN



Purpose



Create customer account.



Fields



Full Name



Phone Number



Email



Password



Confirm Password



Address



Buttons



Register



Already Have Account



Validation



Phone uniqueness



Email uniqueness



Password strength



Success



Customer Dashboard



\---



\# CUSTOMER HOME



Purpose



Primary dashboard.



Displays



Greeting



Current Subscription



Today's Meal



Attendance QR



Unread Notifications



Latest Notices



Quick Actions



Quick Actions



Explore Messes



Attendance



Subscriptions



Leave



Notifications



Profile



Widgets



Today's Attendance



Subscription Status



Upcoming Expiry



Manual Attendance Status



Loading



Skeleton Cards



Empty State



No Active Subscription



\---



\# EXPLORE MESSES



Purpose



Browse approved messes.



Displays



Search



Filters



Sort



Mess Cards



Filters



City



Rating



Price



Meal Availability



Distance (Future)



Card Information



Cover Image



Mess Name



Rating



Starting Price



Capacity



Buttons



View Details



Join



Empty State



No messes found.



\---



\# MESS DETAILS



Purpose



View complete mess information.



Sections



Gallery



Description



Facilities



Meal Plans



Ratings



Reviews



Location



Owner Reply



Actions



Join Mess



View Reviews



Share



Rules



Only active messes are visible.



\---



\# JOIN REQUEST SCREEN



Purpose



Submit join request.



Displays



Selected Plan



Plan Price



Duration



Meal Details



Customer Details



Actions



Submit Request



Cancel



Validation



Customer cannot create duplicate pending requests.



Success



Join Request Submitted



↓



Waiting For Owner Approval



\---



\# JOIN REQUEST STATUS



Displays



Pending



Approved



Rejected



Expired



Cancelled



Actions



Refresh



Cancel Request



Continue Payment (Approved)



\---



\# PAYMENT SCREEN



Purpose



Begin subscription payment.



Displays



Mess Name



Plan Name



Subscription Price



Verification Amount



Payment Instructions



Buttons



Open UPI App



I Have Paid



Cancel



Rules



Customer cannot modify verification amount.



UPI Deep Link launches installed UPI application.



\---



\# PAYMENT VERIFICATION



Purpose



Track verification progress.



Displays



Verification Timeline



Verification Status



Payment Amount



Verification Amount



Verification Time



Status



Pending



Verifying



Verified



Manual Review



Failed



Actions



Refresh Status



Contact Mess



Return Home



Success



Subscription Activated



\---



\# SUBSCRIPTIONS



Purpose



Display subscription history.



Sections



Active



Expired



Cancelled



Card Displays



Mess



Plan



Start Date



End Date



Days Remaining



Status



Actions



View Details



Renew



\---



\# SUBSCRIPTION DETAILS



Displays



Plan Information



Attendance Summary



Leave Summary



Payment History



Subscription Timeline



Actions



Renew Subscription



Download Receipt (Future)



\---



\# ATTENDANCE QR



Purpose



Generate meal attendance QR.



Displays



Animated QR



Countdown Timer



Meal



Current Date



Subscription



States



Generating



Ready



Validating



Used



Expired



Rules



QR refreshes automatically.



Single use only.



\---



\# MANUAL ATTENDANCE APPROVAL



Purpose



Approve owner's attendance request.



Displays



Mess



Owner



Meal



Reason



Time



Buttons



Approve



Reject



States



Pending



Approved



Rejected



Expired



Success



Attendance Recorded



\---



\# ATTENDANCE HISTORY



Displays



Date



Meal



Attendance Method



QR



Manual



Status



Present



Leave



Filters



Week



Month



Custom Range



Actions



View Details



\---



\# LEAVE MANAGEMENT



Purpose



Manage planned leave.



Displays



Calendar



Selected Dates



Meal



Leave Status



Actions



Add Leave



Edit



Cancel



Rules



Leave follows configured lock period.



\---



\# NOTIFICATION CENTER



Displays



Customer Notifications



Categories



Subscription



Payment



Attendance



Manual Attendance



Leave



Notice



Review



Announcements



States



Unread



Read



Archived



Actions



Open



Mark Read



Archive



\---



\# PROFILE



Displays



Photo



Name



Phone



Email



Address



Language



Theme



Buttons



Edit Profile



Change Password



Logout



\---



\# SETTINGS



Displays



Language



Theme



Notification Preferences



Privacy Policy



Terms \& Conditions



App Version



About



Buttons



Logout

---



\##################################################

\# OWNER APPLICATION

\##################################################



\---



\# OWNER DASHBOARD



Purpose



Primary operational dashboard for mess owners.



Displays



Mess Summary



Today's Attendance



Today's Leave Requests



Pending Join Requests



Active Customers



Pending Payments



Monthly Revenue



Unread Notifications



Quick Actions



Customers



Plans



Attendance



Revenue



Notices



Reviews



Profile



Widgets



Today's Attendance



Revenue Summary



Pending Actions



Subscription Status



Loading



Skeleton Cards



Empty State



No customers yet.



\---



\# CUSTOMER MANAGEMENT



Purpose



Manage customers of the selected mess.



Displays



Search



Filters



Customer List



Filters



Active



Expired



Pending Payment



Suspended



Card Displays



Customer Photo



Customer Name



Phone Number



Plan



Subscription Status



Actions



View Details



Call



Search



\---



\# CUSTOMER DETAILS



Displays



Profile



Subscription



Attendance Summary



Leave Summary



Payment History



Private Notes



Actions



Add Note



View Attendance



View Payments



Renew Subscription



Rules



Owner can access only customers belonging to their own mess.



\---



\# PLANS



Purpose



Manage subscription plans.



Displays



Plan Cards



Plan Name



Price



Duration



Meals Included



Subscriber Count



Status



Actions



Create Plan



Edit



Activate



Deactivate



Delete



Rules



Plans with active subscribers cannot be deleted.



\---



\# CREATE / EDIT PLAN



Fields



Plan Name



Description



Price



Duration



Meals Included



Meal Timings



Buttons



Save



Cancel



Validation



Price must be greater than zero.



At least one meal must be selected.



\---



\# JOIN REQUESTS



Displays



Pending Requests



Approved Requests



Rejected Requests



Expired Requests



Card Displays



Customer



Plan



Requested Date



Status



Actions



Approve



Reject



View Details



Rules



Approval enables payment.



Rejection requires a reason.



\---



\# ATTENDANCE SCANNER



Purpose



Record customer attendance.



Displays



QR Scanner



Current Meal



Today's Date



Quick Actions



Manual Attendance



Attendance History



Rules



QR attendance is the primary attendance method.



\---



\# MANUAL ATTENDANCE REQUEST



Purpose



Request customer approval for manual attendance.



Displays



Customer Search



Selected Customer



Meal



Reason



Optional Remarks



Reasons



QR Failed



Camera Issue



Network Issue



Owner Verified



Other



Actions



Send Request



Cancel



Validation



Customer must have an active subscription.



Attendance must not already exist.



Request allowed only during the attendance window.



Success



Customer receives approval request.



\---



\# ATTENDANCE HISTORY



Displays



Date



Customer



Meal



Attendance Method



QR



Manual



Status



Present



Leave



Filters



Today



Week



Month



Custom Range



Actions



View Details



Export (Future)



\---



\# NOTICES



Purpose



Publish announcements.



Displays



Notice List



Title



Category



Expiry



Pinned Status



Categories



General



Holiday



Menu Change



Payment Reminder



Emergency



Actions



Create



Edit



Delete



Pin



Unpin



\---



\# REVIEWS



Displays



Average Rating



Review Cards



Customer



Rating



Review



Owner Reply



Report Count



Actions



Reply



Edit Reply



Report



Rules



Owners cannot delete reviews.



\---



\# PRIVATE FEEDBACK



Displays



Feedback List



Customer



Feedback



Owner Reply



Status



Actions



Reply



View History



\---



\# REVENUE



Purpose



Display financial summary.



Displays



Today's Revenue



Monthly Revenue



Expected Revenue



Collected Revenue



Pending Verification



Failed Verification



Charts



Revenue Trend



Payment Status



Filters



Today



Week



Month



Custom Range



Actions



Export Report (Future)



\---



\# OWNER SUBSCRIPTION



Purpose



Manage owner's Mazi Mess subscription.



Displays



Current Plan



Billing Cycle



Start Date



Expiry Date



Days Remaining



Renewal Due



Grace Period Status



Payment History



Actions



Renew Subscription



View Payment History



Contact Support



Rules



Expired subscriptions display renewal instructions.



\---



\# PAYMENT CONFIGURATION



Purpose



Display payment integration status.



Displays



Configuration Status



Integration Status



Status



Configured



Not Configured



Disabled



Message



"Payment verification infrastructure is managed by the Platform Administrator."



Rules



Owner cannot view:



\- Verification Gmail

\- Make Account

\- Make Password

\- Scenario ID

\- Webhook URL



Owner cannot modify payment infrastructure.



\---



\# OWNER NOTIFICATIONS



Categories



Join Requests



Payments



Payment Verified



Payment Failed



Attendance



Manual Attendance



Reviews



Private Feedback



Subscription



Platform Announcements



States



Unread



Read



Archived



Actions



Open



Mark Read



Archive



\---



\# OWNER PROFILE



Displays



Profile Photo



Business Name



Name



Phone



Email



Address



Language



Theme



Buttons



Edit Profile



Change Password



Logout



Rules



Business verification information is read-only.



Verification status is displayed.



\---



\# OWNER SETTINGS



Displays



Language



Theme



Notification Preferences



Support



Privacy Policy



Terms \& Conditions



App Version



Buttons



Logout



---



\##################################################

\# ADMIN APPLICATION

\##################################################



\---



\# ADMIN DASHBOARD



Purpose



Central control panel for the entire platform.



Displays



Platform Statistics



Owner Statistics



Mess Statistics



Customer Statistics



Revenue Summary



Pending Verifications



Pending Approvals



System Alerts



Quick Actions



Owner Verification



Mess Approval



Payment Monitoring



Business Analytics



Global Settings



Maintenance



Widgets



Platform Revenue



Monthly Revenue



Active Owner Subscriptions



Pending Owner Verifications



Pending Mess Approvals



Pending Payment Verifications



Integration Failures



Loading



Skeleton Cards



Empty State



No pending administrative actions.



\---



\# OWNER VERIFICATION



Purpose



Approve or reject owner registrations.



Displays



Owner Photo



Business Name



Owner Name



Phone



Email



Verification Status



Submitted Documents



Admin Notes



Actions



Approve



Reject



Request Documents



Suspend



Filters



Pending



Approved



Rejected



Suspended



Rules



Only Administrators may approve owners.



Every action creates an Audit Log.



\---



\# OWNER DETAILS



Displays



Owner Information



Business Information



Verification History



Owned Messes



Owner Subscription



Activity Timeline



Audit History



Actions



Approve



Suspend



Reactivate



View Messes



\---



\# MESS APPROVAL



Purpose



Review newly registered messes.



Displays



Mess Photo



Mess Name



Owner



Address



Capacity



Verification Documents



Current Status



Actions



Approve



Reject



Request Changes



View Documents



Filters



Pending



Approved



Rejected



Frozen



Rules



Approved messes become visible in Explore.



Rejected messes require resubmission.



\---



\# MESS DETAILS



Displays



Complete Mess Information



Gallery



Owner Information



Plans



Customers



Reviews



Payment Infrastructure Status



Verification Timeline



Actions



Freeze



Delist



Activate



Delete



\---



\# PAYMENT MONITORING



Purpose



Monitor all customer payment verification.



Displays



Customer



Mess



Plan



Verification Amount



Payment Status



Verification Method



Verification Time



Retry Count



Filters



Pending



Verified



Manual Review



Failed



Date Range



Mess



Actions



View Details



Retry Verification



Manual Override



\---



\# PAYMENT VERIFICATION DETAILS



Displays



Payment Intent



Customer



Mess



Plan



Verification Amount



Webhook Status



Gmail Status



Gemini Extraction



Confidence Score



Retry History



Verification Timeline



Failure Reason



Actions



Retry



Approve



Reject



Close



Rules



Only Administrators may override payment verification.



Every override generates an Audit Log.



\---



\# INTEGRATION CONFIGURATION



Purpose



Configure payment infrastructure for each approved mess.



Displays



Mess Name



Verification Gmail



Make Account Email



Make Account Password



Scenario ID



Webhook URL



Integration Status



Status



Not Configured



Configured



Active



Failed



Disabled



Actions



Create



Edit



Test Connection



Activate



Disable



Rules



Only Administrators have access.



Owners never see this screen.



\---



\# INTEGRATION MONITORING



Purpose



Monitor infrastructure health.



Displays



Mess



Webhook Status



Make Status



Gmail Status



Last Successful Verification



Last Failure



Failure Reason



Overall Health



Filters



Healthy



Failed



Disabled



Actions



Refresh



View Configuration



View Logs



\---



\# BUSINESS ANALYTICS



Purpose



Display business intelligence.



Displays



Platform Revenue



Monthly Revenue



Annual Revenue



MRR



ARR



ARPO



Owner Growth



Customer Growth



Subscription Churn



Payment Success Rate



Charts



Revenue Trend



Growth Trend



Owner Distribution



Subscription Distribution



Filters



Today



Week



Month



Year



Custom Range



Actions



Export Report



\---



\# OWNER SUBSCRIPTIONS



Purpose



Manage owner SaaS subscriptions.



Displays



Owner



Current Plan



Billing Cycle



Start Date



Expiry Date



Grace Period



Status



Actions



Renew



Suspend



Reactivate



View History



Filters



Trial



Active



Renewal Due



Grace Period



Expired



Suspended



\---



\# GLOBAL SETTINGS



Purpose



Configure platform-wide behaviour.



Sections



Registration



Attendance



Reviews



Notifications



Owner Subscription



Maintenance



Verification



Fields



Registration Enabled



Owner Registration Enabled



Review Eligibility Days



Attendance Approval Window



Leave Lock Days



Verification Timeout



Maximum Verification Retries



Grace Period



Push Notifications



Email Notifications



Buttons



Save



Reset



Rules



Changes affect the entire platform.



Every save generates an Audit Log.



\---



\# REGISTRATION CONTROL



Displays



Customer Registration



Owner Registration



Current Status



Buttons



Enable



Disable



Rules



Existing users remain unaffected.



Only new registrations are blocked.



\---



\# MAINTENANCE MODE



Purpose



Control platform availability.



Displays



Current Status



Maintenance Message



Affected Services



Buttons



Enable



Disable



Rules



Customers



Blocked



Owners



Continue Working



Administrators



Full Access



Background services continue running.



\---



\# AUDIT LOGS



Purpose



Review administrative history.



Displays



Action



Entity



Performed By



Role



Previous State



New State



Timestamp



Device



App Version



Filters



Date



Entity Type



Administrator



Action



Actions



View Details



Export (Future)



Rules



Audit Logs are immutable.



\---



\# PLATFORM REPORTS



Displays



Daily Report



Weekly Report



Monthly Report



Yearly Report



Status



Generating



Ready



Failed



Actions



Generate



Download



Delete



\---



\# ADMIN NOTIFICATIONS



Categories



Owner Verification



Mess Approval



Payment Failure



Manual Review



Integration Failure



Webhook Failure



System Alert



Business Alert



Audit Alert



Maintenance



States



Unread



Read



Archived



Actions



Open



Mark Read



Archive



\---



\# ADMIN PROFILE



Displays



Profile Photo



Name



Email



Role



Language



Theme



Buttons



Edit Profile



Change Password



Logout



\---



\# ADMIN SETTINGS



Displays



Language



Theme



Notification Preferences



Platform Information



Privacy Policy



Terms \& Conditions



App Version



Buttons



Logout



---



\##################################################

\# SHARED COMPONENTS

\##################################################



Every reusable component should follow Material Design 3.



Shared components must maintain consistent styling throughout the application.



\---



\# APP BAR



Displays



Back Button (when applicable)



Screen Title



Optional Action Buttons



Rules



• Consistent height across screens.



• Back navigation follows platform navigation rules.



\---



\# BOTTOM NAVIGATION BAR



Customer



Home



Explore



Subscriptions



Notifications



Profile



Owner



Dashboard



Customers



Attendance



Revenue



Profile



Administrator



Dashboard



Owners



Payments



Analytics



Settings



Rules



Maximum five primary destinations.



\---



\# SEARCH BAR



Features



Real-time Search



Clear Button



Search Hint



Supported In



Customers



Messes



Plans



Payments



Reviews



Audit Logs



Rules



Search should debounce user input.



\---



\# FILTER PANEL



Supported Controls



Status



Date Range



Category



Meal



Rating



City



Owner



Mess



Rules



Multiple filters may be combined.



Provide a "Clear Filters" action.



\---



\# STATUS CHIP



Supported States



Active



Pending



Approved



Rejected



Suspended



Expired



Failed



Verified



Manual Review



Configured



Disabled



Rules



Status chips use consistent colors and icons throughout the application.



\---



\# CARDS



Reusable Card Types



Mess Card



Customer Card



Plan Card



Review Card



Payment Card



Attendance Card



Notification Card



Revenue Card



Analytics Card



Owner Card



Rules



Cards should have:



\- Rounded corners

\- Consistent spacing

\- Material elevation

\- Responsive layout



\---



\# BUTTONS



Primary



Filled Button



Secondary



Outlined Button



Tertiary



Text Button



Danger



Filled Tonal / Destructive Style



Loading



Progress Indicator inside button



Buttons should prevent duplicate taps while processing.



\---



\##################################################

\# DIALOGS

\##################################################



Confirmation Dialog



Examples



Delete



Approve



Reject



Suspend



Cancel



Fields



Title



Description



Confirm



Cancel



\---



\# SUCCESS DIALOG



Displays



Success Icon



Message



Continue Button



\---



\# ERROR DIALOG



Displays



Error Icon



Description



Retry Button



Cancel Button



\---



\# LOADING DIALOG



Displays



Circular Progress Indicator



Loading Message



Blocks user interaction while processing.



\---



\##################################################

\# BOTTOM SHEETS

\##################################################



Used For



Sort



Filters



Quick Actions



Share



Plan Selection



Meal Selection



Rules



Support drag-to-dismiss where appropriate.



\---



\##################################################

\# FORMS

\##################################################



Every form should provide:



Field Validation



Required Indicators



Inline Error Messages



Keyboard Optimization



Input Formatting



Disable submit while processing.



\---



\##################################################

\# LOADING STATES

\##################################################



Every screen requiring backend data should display skeleton loaders.



Examples



Dashboard



Customer List



Payment History



Reviews



Analytics



Avoid blank screens during loading.



\---



\##################################################

\# EMPTY STATES

\##################################################



Every list screen should provide a meaningful empty state.



Examples



No Customers



No Reviews



No Notifications



No Payments



No Attendance Records



No Join Requests



Empty states should include a helpful message and, where appropriate, a primary action.



\---



\##################################################

\# ERROR STATES

\##################################################



Display



Error Illustration



Error Message



Retry Button



Support Contact (where applicable)



Technical details should never be shown to end users.



\---



\##################################################

\# SUCCESS STATES

\##################################################



Examples



Registration Complete



Payment Verified



Attendance Recorded



Review Submitted



Plan Created



Owner Approved



Display a confirmation message followed by the appropriate navigation.



\---



\##################################################

\# OFFLINE STATES

\##################################################



Cached Information



Profile



Active Subscription



Previously Loaded Notices



Previously Loaded Reviews



Restricted While Offline



Payments



Attendance Submission



Attendance Approval



Join Requests



Global Settings



Show a clear offline indicator.



\---



\##################################################

\# NAVIGATION FLOWS

\##################################################



Customer



Splash



↓



Login



↓



Home



↓



Explore



↓



Mess Details



↓



Join Request



↓



Payment



↓



Payment Verification



↓



Subscription Activated



↓



Attendance QR



↓



Attendance History



Owner



Dashboard



↓



Customers



↓



Customer Details



↓



Attendance



↓



Manual Attendance Request



↓



Revenue



↓



Owner Subscription



Administrator



Dashboard



↓



Owner Verification



↓



Mess Approval



↓



Payment Monitoring



↓



Integration Configuration



↓



Business Analytics



↓



Global Settings



↓



Audit Logs



\---



\##################################################

\# ACCESSIBILITY GUIDELINES

\##################################################



Support



Screen Readers



Dynamic Text Scaling



High Contrast



Accessible Touch Targets



Semantic Labels



Avoid using color alone to communicate status.



\---



\##################################################

\# RESPONSIVE DESIGN

\##################################################



Primary Target



Mobile Phones



Support



Small Phones



Large Phones



Tablets (Future)



Landscape layouts should preserve functionality.



\---



\##################################################

\# SCREEN RELATIONSHIPS

\##################################################



Authentication



↓



Role Detection



↓



Customer Dashboard



OR



Owner Dashboard



OR



Admin Dashboard



Business actions navigate through defined workflows only.



Deep linking should respect authentication and authorization.



\---



\##################################################

\# VERSION HISTORY

\##################################################



| Version | Status | Description |

|----------|--------|-------------|

| 1.0 | Draft | Initial screen specification |

| 2.0 | Production Ready | Complete rewrite after frontend MVP completion with customer, owner, and administrator workflows, payment verification, manual attendance, owner subscriptions, integration management, analytics, maintenance mode, and shared UI standards |



\---



\##################################################

\# RELATED DOCUMENTS

\##################################################



This document should be read together with:



\- 01\_Firestore\_Schema.md

\- 02\_Product\_Spec.md

\- 03\_Permission\_Matrix.md

\- 04\_State\_Machines.md

\- 06\_Payment\_Verification.md

\- 07\_Backend\_Architecture.md



Together these documents define the complete functional, technical, and UI architecture of the Mazi Mess platform.



\---



\##################################################

\# DOCUMENT STATUS

\##################################################



Document Name



Screen Specification



Version



2.0



Status



Production Ready



Platform



Flutter



Design System



Material Design 3



Maintained By



Mazi Mess Development Team



This document is the authoritative reference for all application screens, navigation flows, reusable UI components, and interaction patterns.



Any new screen or significant UI change should be reflected here before implementation.



\---



END OF DOCUMENT

