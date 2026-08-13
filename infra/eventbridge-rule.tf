# EventBridge Rule Configuration Notes

## Purpose

Amazon EventBridge was configured to automatically invoke the
GuardDuty containment Lambda function when a relevant GuardDuty
security finding is received.

## Rule Details

Rule Name:
guardduty-auto-containment-rule

Rule Type:
Event Pattern Rule

Event Bus:
default

Status:
Enabled

## Event Flow

GuardDuty Finding
        |
        v
Amazon EventBridge
        |
        v
guardduty-auto-containment-rule
        |
        v
AWS Lambda
        |
        v
Automated Containment

## Target

Target Function:
guardduty-auto-containment

The EventBridge rule invokes the Lambda function when the configured
GuardDuty event pattern matches.

## Verification

The EventBridge rule was verified in the AWS Console and was shown
as Enabled.

The Lambda function was subsequently tested and its execution
results were observed through the Lambda console and Amazon
CloudWatch logs.

## Evidence

Supporting screenshots are stored under:

docs/screenshots/stage-6/

## Security Consideration

Automated containment can take action before a human reviews an
alert. Therefore, the event pattern should be narrowly scoped to
avoid unintended containment of legitimate activity.