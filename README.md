# AWS Threat Detection & Automated Incident Response

## Project Overview

This project demonstrates an AWS-based threat detection,
investigation, and automated response workflow.

The solution uses AWS security services to detect suspicious
activity, investigate security findings, and automatically
contain a test IAM credential.

---

## AWS Services Used

- Amazon GuardDuty
- AWS CloudTrail
- Amazon EventBridge
- AWS Lambda
- AWS IAM
- Amazon CloudWatch

---

## Project Workflow

The project follows the security incident lifecycle:

Detection
   ↓
Investigation
   ↓
Containment
   ↓
Automated Response
   ↓
Verification

---

## Project Stages

### Stage 1 — Environment Setup

AWS environment and required security services were configured
for the security investigation lab.

### Stage 2 — CloudTrail Monitoring

AWS CloudTrail was used to record and investigate IAM activity
and API events.

### Stage 3 — GuardDuty Detection

Amazon GuardDuty was enabled to detect suspicious activity and
generate security findings.

### Stage 4 — Investigation

GuardDuty findings and CloudTrail events were investigated to
understand the suspicious activity, affected resources and
source information.

### Stage 5 — Manual Containment

The affected test IAM access key was manually disabled as part
of the containment process.

### Stage 6 — Automated Containment

An EventBridge rule was configured to invoke a Lambda function
when the relevant GuardDuty event is detected.

The Lambda function identifies the affected test access key and
disables it using AWS IAM.

CloudWatch Logs were used to verify Lambda execution.

---

## Automated Response Architecture

```text
GuardDuty Finding
       |
       v
Amazon EventBridge
       |
       v
AWS Lambda
       |
       v
AWS IAM
       |
       v
Access Key Disabled
       |
       v
CloudWatch Logs