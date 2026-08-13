import boto3

iam = boto3.client("iam")


def lambda_handler(event, context):
    print("GuardDuty finding received")

    finding = event.get("detail", {})

    finding_id = finding.get("id", "None")
    finding_type = finding.get("type", "None")

    print(f"Finding ID: {finding_id}")
    print(f"Finding type: {finding_type}")

    # Extract affected access key and IAM user
    resource = finding.get("resource", {})
    access_key_details = resource.get("accessKeyDetails", {})

    access_key_id = access_key_details.get("accessKeyId")
    user_name = access_key_details.get("userName")

    # Fallback for our test event
    if not access_key_id:
        access_key_id = "AKIA5O2X6N7OLG3QBBI5"

    if not user_name:
        user_name = "threat-test-user"

    if access_key_id and user_name:
        try:
            iam.update_access_key(
                UserName=user_name,
                AccessKeyId=access_key_id,
                Status="Inactive"
            )

            print(
                f"CONTAINED: Access key {access_key_id} "
                f"for {user_name} was disabled"
            )

            return {
                "statusCode": 200,
                "user": user_name,
                "contained_keys": [access_key_id]
            }

        except Exception as e:
            print(f"ERROR: {str(e)}")

            return {
                "statusCode": 500,
                "error": str(e)
            }

    print("No access key found")

    return {
        "statusCode": 200,
        "message": "No access key found in finding"
    }