\# 03\_Permission\_Matrix.md



\# MAZI MESS - PERMISSION MATRIX V1



\## Roles



System Roles:



\* Customer

\* Owner

\* Admin



\---



\# USERS



| Action                  | Customer | Owner                 | Admin |

| ----------------------- | -------- | --------------------- | ----- |

| View Own Profile        | YES      | YES                   | YES   |

| Edit Own Profile        | YES      | YES                   | YES   |

| Change Mobile Number    | YES      | YES                   | YES   |

| View Other User Profile | NO       | Active Customers Only | YES   |

| Suspend User            | NO       | NO                    | YES   |

| Delete User             | NO       | NO                    | YES   |



\---



\# MESS



| Action          | Customer | Owner         | Admin |

| --------------- | -------- | ------------- | ----- |

| View Mess       | YES      | YES           | YES   |

| Create Mess     | NO       | YES           | YES   |

| Edit Own Mess   | NO       | YES           | YES   |

| Edit Other Mess | NO       | NO            | YES   |

| Delist Mess     | NO       | YES (Request) | YES   |

| Delete Mess     | NO       | NO            | YES   |

| Approve Mess    | NO       | NO            | YES   |



\---



\# PLANS



| Action      | Customer | Owner | Admin |

| ----------- | -------- | ----- | ----- |

| View Plans  | YES      | YES   | YES   |

| Create Plan | NO       | YES   | YES   |

| Edit Plan   | NO       | YES   | YES   |

| Delete Plan | NO       | YES   | YES   |



\---



\# JOIN REQUESTS



| Action             | Customer | Owner | Admin |

| ------------------ | -------- | ----- | ----- |

| Create Request     | YES      | NO    | YES   |

| Cancel Request     | YES      | NO    | YES   |

| Approve Request    | NO       | YES   | YES   |

| Reject Request     | NO       | YES   | YES   |

| View Own Requests  | YES      | NO    | YES   |

| View Mess Requests | NO       | YES   | YES   |



\---



\# SUBSCRIPTIONS



| Action                  | Customer | Owner | Admin |

| ----------------------- | -------- | ----- | ----- |

| View Own Subscription   | YES      | NO    | YES   |

| View Mess Subscriptions | NO       | YES   | YES   |

| Renew Subscription      | YES      | NO    | YES   |

| Extend Subscription     | NO       | YES   | YES   |

| Suspend Subscription    | NO       | NO    | YES   |

| Activate Subscription   | NO       | NO    | YES   |

| Cancel Subscription     | NO       | NO    | YES   |



\---



\# PAYMENTS



| Action             | Customer | Owner | Admin |

| ------------------ | -------- | ----- | ----- |

| View Own Payments  | YES      | NO    | YES   |

| View Mess Payments | NO       | YES   | YES   |

| Verify Payment     | NO       | NO    | YES   |

| Modify Payment     | NO       | NO    | YES   |

| View All Payments  | NO       | YES   | YES   |



Notes:



Owners may view payment records related to their own messes only.



Admins may view all payment records.



\---



\# ATTENDANCE



| Action               | Customer | Owner | Admin |

| -------------------- | -------- | ----- | ----- |

| Generate QR          | YES      | NO    | YES   |

| Scan QR              | NO       | YES   | YES   |

| View Own Attendance  | YES      | NO    | YES   |

| View Mess Attendance | NO       | YES   | YES   |

| Edit Attendance      | NO       | NO    | YES   |

| Delete Attendance    | NO       | NO    | YES   |



Notes:



Attendance cannot be edited by customers.



Attendance cannot be edited by owners.



Admin override allowed only for exceptional situations.



\---



\# LEAVE MANAGEMENT



| Action              | Customer          | Owner | Admin |

| ------------------- | ----------------- | ----- | ----- |

| Create Leave        | YES               | NO    | YES   |

| Edit Leave          | YES (Before Lock) | NO    | YES   |

| Cancel Leave        | YES (Before Lock) | NO    | YES   |

| View Own Leave      | YES               | NO    | YES   |

| View Customer Leave | NO                | YES   | YES   |



\---



\# REVIEWS



| Action          | Customer        | Owner           | Admin |

| --------------- | --------------- | --------------- | ----- |

| Create Review   | YES             | NO              | YES   |

| Edit Review     | YES (2 Minutes) | NO              | YES   |

| Delete Review   | YES (2 Minutes) | NO              | YES   |

| Reply To Review | NO              | YES             | YES   |

| Edit Reply      | NO              | YES (2 Minutes) | YES   |

| Report Review   | YES             | YES             | YES   |

| Remove Review   | NO              | NO              | YES   |



\---



\# FEEDBACK



| Action            | Customer | Owner | Admin |

| ----------------- | -------- | ----- | ----- |

| Create Feedback   | YES      | NO    | YES   |

| View Feedback     | NO       | YES   | YES   |

| Reply To Feedback | NO       | YES   | YES   |

| Report Feedback   | NO       | YES   | YES   |

| Remove Feedback   | NO       | NO    | YES   |



Notes:



Feedback is private.



Customers cannot view feedback submitted by others.



\---



\# NOTICES



| Action        | Customer              | Owner | Admin |

| ------------- | --------------------- | ----- | ----- |

| View Notice   | Active Customers Only | YES   | YES   |

| Create Notice | NO                    | YES   | YES   |

| Edit Notice   | NO                    | YES   | YES   |

| Delete Notice | NO                    | YES   | YES   |



\---



\# NOTIFICATIONS



| Action                 | Customer | Owner | Admin |

| ---------------------- | -------- | ----- | ----- |

| View Own Notifications | YES      | YES   | YES   |

| Mark Read              | YES      | YES   | YES   |

| Delete Notification    | NO       | NO    | YES   |



\---



\# BLACKLIST



| Action                | Customer | Owner    | Admin |

| --------------------- | -------- | -------- | ----- |

| View Blacklist        | NO       | Own Only | YES   |

| Add To Blacklist      | NO       | YES      | YES   |

| Remove From Blacklist | NO       | YES      | YES   |



Notes:



Blacklists apply to all messes owned by that owner.



Blacklisted customers should not see blocked messes.



\---



\# OWNER NOTES



| Action       | Customer | Owner    | Admin |

| ------------ | -------- | -------- | ----- |

| View Notes   | NO       | Own Only | YES   |

| Create Notes | NO       | YES      | YES   |

| Edit Notes   | NO       | YES      | YES   |

| Delete Notes | NO       | YES      | YES   |



\---



\# CUSTOMER REPUTATION



| Action            | Customer | Owner | Admin |

| ----------------- | -------- | ----- | ----- |

| View Reputation   | NO       | NO    | YES   |

| Modify Reputation | NO       | NO    | YES   |



\---



\# AUDIT LOGS



| Action      | Customer    | Owner       | Admin       |

| ----------- | ----------- | ----------- | ----------- |

| View Logs   | NO          | NO          | YES         |

| Create Logs | System Only | System Only | System Only |

| Edit Logs   | NO          | NO          | NO          |

| Delete Logs | NO          | NO          | NO          |



\---



\# SETTINGS



| Action               | Customer | Owner | Admin |

| -------------------- | -------- | ----- | ----- |

| View Settings        | YES      | YES   | YES   |

| Edit Own Settings    | YES      | YES   | YES   |

| Edit Global Settings | NO       | NO    | YES   |



\---



\# SECURITY PRINCIPLES



1\. Client applications never activate subscriptions.

2\. Client applications never verify payments.

3\. Client applications never modify audit logs.

4\. Owners cannot modify attendance records.

5\. Customers cannot access other customers' data.

6\. Payments are validated server-side only.

7\. Sensitive operations must generate audit logs.

8\. Soft delete only.

9\. All role validation must be enforced by backend security rules.



