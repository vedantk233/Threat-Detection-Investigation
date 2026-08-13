# Incident Investigation Timeline

## Objective

The purpose of this investigation was to trace suspicious IAM activity
using AWS CloudTrail and GuardDuty logs and reconstruct the sequence of events.

The test activity was performed only in the AWS test account.

---

## Incident Summary

A test IAM user named `threat-test-user` was created and an
AdministratorAccess policy was attached to the user.

An access key was also created for the test user.

GuardDuty detected activity associated with root credentials and
reported an IAM-related security finding.

The activity was then investigated using CloudTrail Event History.

---

## Investigation Timeline

| Event | Identity | Source IP | Result | Evidence |
|---|---|---|---|---|
| IAM user created | root | 106.213.84.117 | Successful | CloudTrail CreateUser event |
| AdministratorAccess attached | root | 106.213.84.117 | Successful | CloudTrail AttachUserPolicy event |
| Access key created | root | 106.213.84.117 | Successful | IAM Security Credentials |
| GuardDuty finding generated | Root | 106.213.84.117 | Finding detected | GuardDuty Findings |
| EventBridge rule triggered | GuardDuty/EventBridge | AWS service | Triggered | EventBridge rule |
| Lambda containment executed | Lambda | AWS service | Successful | Lambda execution log |
| Access key disabled | Lambda | AWS service | Successful | IAM Security Credentials |

---

## CloudTrail Evidence

### CreateUser

CloudTrail Event History recorded a `CreateUser` event for
`threat-test-user`.

The event was performed by the root identity and originated from
the recorded source IP address.

The event details confirmed:

- Event name: `CreateUser`
- User name: `root`
- Event source: `iam.amazonaws.com`
- AWS Region: `us-east-1`
- Source IP: `106.213.84.117`

---

## AttachUserPolicy

CloudTrail also recorded an `AttachUserPolicy` event.

The event shows that the `AdministratorAccess` policy was attached
to the test IAM user.

Important evidence:

- Event name: `AttachUserPolicy`
- User name: `root`
- Target user: `threat-test-user`
- Policy: `AdministratorAccess`
- Source IP: `106.213.84.117`
- Event source: `iam.amazonaws.com`

This activity was intentionally generated as part of the security
testing exercise.

---

## GuardDuty Finding

GuardDuty generated an IAM-related finding indicating that the
`AttachUserPolicy` API was invoked using root credentials.

The finding was classified as a LOW severity finding.

The finding identified:

- Finding type: `Policy:IAMUser/RootCredentialUsage`
- API: `AttachUserPolicy`
- User type: Root
- Resource type: AccessKey
- Source IP: `106.213.84.117`

This demonstrated that GuardDuty can identify suspicious use of
privileged credentials.

---

## Automated Response

An EventBridge rule named:

`guardduty-auto-containment-rule`

was configured to react to GuardDuty findings.

The rule invokes the Lambda function:

`guardduty-auto-containment`

The Lambda function checks the finding and disables the affected
IAM access key as a containment action.

---

## Containment Result

The Lambda test execution completed successfully.

The execution output showed:

- Status code: `200`
- Test user: `threat-test-user`
- Contained key: the test access key
- Containment action: access key disabled

CloudWatch logs recorded the Lambda execution and the containment
operation.

The IAM Security Credentials page subsequently showed the test
access key in an **Inactive** state.

---

## Investigation Conclusion

The investigation successfully demonstrated the complete security
response workflow:

1. Suspicious IAM activity was generated.
2. CloudTrail recorded the activity.
3. GuardDuty detected the suspicious credential usage.
4. EventBridge routed the GuardDuty event.
5. Lambda executed the automated containment action.
6. The test access key was disabled.
7. CloudWatch recorded the Lambda execution.

This demonstrates how AWS security services can be connected to
automatically respond to suspicious IAM activity.