# CloudTrail Configuration Notes

## Purpose

AWS CloudTrail was configured to record AWS management activity for the
threat detection and investigation exercise.

## Trail Configuration

Trail Name:
threat-detection-trail

Logging Status:
Enabled

Multi-Region Trail:
Yes

Log File Validation:
Enabled

Organization Trail:
Not enabled

## Log Storage

CloudTrail log files are delivered to an Amazon S3 bucket configured for
the investigation environment.

S3 Log Location:
Configured in the AWS CloudTrail console.

## Security Monitoring

CloudTrail management events were used as evidence during the investigation.

The recorded events were used to identify:

- User identity
- Event name
- Event time
- Source IP address
- AWS region
- AWS access key
- Request details
- API activity

## Investigation Events

The investigation included IAM activity such as:

- CreateUser
- AttachUserPolicy

These events were reviewed through CloudTrail Event History.

## Evidence

Supporting CloudTrail screenshots are stored under:

docs/screenshots/stage-1/

and

docs/screenshots/stage-4/

## Security Note

Sensitive AWS account information, access keys, ARNs, and other credentials
must be masked before screenshots or documentation are published to GitHub.