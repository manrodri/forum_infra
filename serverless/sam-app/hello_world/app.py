import json
import os
import boto3

REGION = os.environ['REGION']


def lambda_handler(event, context):
    ec2 = boto3.resource('ec2', region_name=REGION)

    # find all instances that are running and have tag of office_hours
    instances = ec2.instances.filter(
        Filters=[
            {'Name': 'instance-state-name', 'Values': ['running']},
            {'Name': 'tag:AutoStop', 'Values': ['true']}
        ]
    )
    # try to stop instances
    stopped_instances = []
    errors = []
    for instance in instances:
        try:
            instance.stop()
            stopped_instances.append(instance.id)
            print(f'{instance} stopped')
        except:
            print(f'Error stopping {instance}')
            errors.append(instance.id)

    response = {
        "stopped_instances": stopped_instances,
        "instances_failed_to_stop": errors
    }

    print(response)

    return json.dumps(response)
