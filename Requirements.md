### Requirements

Query tasks:
* **Actor**: Account
* **Data**: account_id, status???

---

Authorization:
* **Actor**: Account
* **Command**: Login to the System
* **Data**: Login, password???
* **Event**: Account.logined

---

CreateTask:
* **Actor**: Account
* **Command**: Create a task
* **Data**: description, status(???)
* **Event**: Task.created

---

Assign Task:
* **Actor**: Account
* **Command**: Assign a task
* **Data**: Task
* **Event**: Task.assigned

---

Complete task:
* **Actor**: Account
* **Command**: Complete a task
* **Data**: Task, Account_id
* **Event**: Task.completed

---

Create price:
* **Actor**: Task.created (event)
* **Command**: Create a price for a task
* **Data**: Task_id, price_assignment, price_compeliton
* **Event**: Price.created

---

Create auditlog record:
* **Actor**: Task.assigned || Task.completed || Payment.made (events)
* **Command**: Create an auditlog record
* **Data**: Accoun_id, Task_id, amount(sum)
* **Event**: AuditLog.created

---

Make payment:
* **Actor**: ??? (external event, cronjob)
* **Command**: Make a payment
* **Data**: Accound_id, date
* **Event**: Payment.made

---

Send notification:
* **Actor**: Payment.made (event)
* **Command**: Send notification
* **Data**: Task_id, price_assignment, price_compeliton
* **Event**: Price.created

---

Manager result (query):
* **Actor**: Account(manager - role)
* **Data**: events about tasks (assign and compete)
* **Result**: Current balans

---

Popug result (query):
* **Actor**: Account(manager - popug)
* **Data**: events about tasks (assign and compete) for specific account
* **Result**: Current balans

---

Popugi losers result (query):
* **Actor**: Account(manager - role)
* **Data**: events about tasks (assign and compete)
* **Result**: amount popug with negativ result

---

Find most expencive task (query):
* **Actor**: Account(manager - role)
* **Data**: events about completing tasks, date range
* **Result**: Task with price

---

