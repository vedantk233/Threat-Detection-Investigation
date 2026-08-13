# Security Incident Report

## Incident Title

Suspicious IAM Privilege Activity and Automated Credential Containment

---

## 1. Executive Summary

A controlled security incident was generated inside the AWS test
environment to evaluate detection, investigation and automated
response capabilities.

A test IAM user named `threat-test-user` was created and
AdministratorAccess was attached to the user.

CloudTrail recorded the IAM activity and GuardDuty generated a
finding related to the use of root credentials.

An EventBridge rule was configured to automatically invoke a Lambda
containment function.

The Lambda function successfully disabled the affected test access
key.

---

## 2. What Happened

The following controlled actions were performed:

1. Created the test IAM user `threat-test-user`.
2. Attached the AWS managed `AdministratorAccess` policy.
3. Created an access key for the test user.
4. Reviewed the resulting CloudTrail events.
5. Reviewed the GuardDuty finding.
6. Allowed the EventBridge rule to trigger the Lambda function.
7. Lambda disabled the test access key.
8. IAM Security Credentials confirmed that the access key became
   inactive.

All activity was performed within the test AWS account.

---

## 3. Detection

The activity was investigated using AWS CloudTrail and AWS GuardDuty.

CloudTrail recorded the IAM management events, including:

- `CreateUser`
- `AttachUserPolicy`

GuardDuty generated an IAM-related finding:

`Policy:IAMUser/RootCredentialUsage`

The finding indicated that the `AttachUserPolicy` API was invoked
using root credentials.

---

## 4. Investigation

CloudTrail Event History was used to reconstruct the activity.

The investigation identified:

- Identity involved: root
- Test IAM user: `threat-test-user`
- Event source: `iam.amazonaws.com`
- Region: `us-east-1`
- Source IP: `106.213.84.117`
- Policy involved: `AdministratorAccess`

The CloudTrail evidence was compared with the actions performed
during the controlled test.

---

## 5. Impact Assessment

The test user received AdministratorAccess during the controlled
exercise.

This represents a high level of privilege and would create
significant risk if performed by an unauthorized identity in a
production environment.

However, this exercise was intentionally performed in a controlled
test account.

The access key was subsequently disabled by the automated
containment function.

---

## 6. Automated Response

The response architecture was:

GuardDuty
    |
    v
EventBridge
    |
    v
Lambda
    |
    v
Disable IAM Access Key

The EventBridge rule was configured to automatically invoke the
Lambda containment function when the relevant GuardDuty event was
received.

The Lambda function successfully executed the containment action.

---

## 7. Containment Result

The Lambda execution returned a successful response.

Observed result:

- Status code: `200`
- Test user: `threat-test-user`
- Containment action: Access key disabled

The IAM Security Credentials page subsequently showed the access
key as **Inactive**.

CloudWatch logs also recorded the Lambda execution.

---

## 8. Prevention Recommendations

The following controls should be considered for a real environment:

- Avoid using root credentials for routine AWS operations.
- Use IAM roles and least-privilege permissions.
- Avoid unnecessary AdministratorAccess permissions.
- Enable MFA for privileged identities.
- Monitor IAM activity using CloudTrail and GuardDuty.
- Configure automated response only for carefully selected finding
  types.
- Review IAM access keys regularly.
- Remove unused access keys.
- Maintain centralized and protected security logs.

---

## 9. What CloudTrail Could Not Tell Us

CloudTrail provides detailed records of AWS API activity, but the
logs do not by themselves explain the complete human intent behind
an action.

For example, CloudTrail can show which identity performed an API
call, when it occurred, the source IP and whether the API operation
was successful, but it does not necessarily establish why the
person performed the action.

Therefore, CloudTrail evidence should be combined with other
investigation sources when investigating a real incident.

---

## 10. Automated Response Risk

Automated containment can reduce response time, but it can also
cause problems if a legitimate administrator performs an unusual
action.

For example, automatically disabling an access key because of a
single unusual event could interrupt legitimate business activity.

Before using this design in a production environment, additional
controls should be considered, such as:

- Restricting automatic containment to high-confidence findings.
- Using approval workflows for sensitive actions.
- Applying allowlists for known administrative identities.
- Logging every automated response.
- Testing the response thoroughly before production deployment.

---

## 11. Final Conclusion

The exercise demonstrated an end-to-end AWS threat detection and
automated response workflow.

The investigation progressed from suspicious IAM activity through
CloudTrail investigation and GuardDuty detection to automated
containment using EventBridge and Lambda.

The final containment action successfully disabled the test access
key.

The project demonstrates how security monitoring can be extended
from manual investigation to automated response while also
highlighting the risks that must be considered before deploying
automated containment in production.