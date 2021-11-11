### Commands

####Create task
```yaml
actor: user
command: create task
data: description, status
event: tasks.created
```

####Assign tasks
```yaml
actor: user (manager or admin)
command: assign task
data: taskId exteral
event: tasks.assigned
```

####Complete task
```yaml
actor: user (assignee)
command: complete task
data: taskId external
event: tasks.completed
```

####Calculate deposit
```yaml
actor: tasks.created
command: calculate deposit
data: taskId external
event: tasks.depositCalculated
```

####Calculate price
```yaml
actor: tasks.completed
command: calculate price
data: taskId external
event: Tasks.priceCalculated
```

####Charge deposit
```yaml
actor: tasks.assigned
command: charge deposit
data: taskId external
event: balance.depositCharged
```

####Pay price
```yaml
actor: tasks.completed
command: pay price
data: taskId external, amount
event: balance.pricePaid
```

####Pay balance
```yaml
actor: closePeriodWorker.fired
command: pay balance
data: userId (popug)
event: balance.paid
```

####Payment notification
```yaml
actor: balance.paid
command: send payment notification to popug
data: userId, amount
event: balance.paymentNotificationSent
```

####Reset balance
```yaml
actor: balance.paid
command: reset postive balance
data: userId
event: balance.reset
```

####Make balance audit record
```yaml
actor: balance.depositCharged, balance.payPrice
command: make balance record to audit
data: taskId external, amount
event: balance.balanceAudited
```

####Make payment audit record
```yaml
actor: balance.paid
command: make payment record to audit
data: userId, payment period
event: balance.paymentAudited
```