import boto3
import logging

ec2c = boto3.client('ec2')
sns = boto3.client('sns')


def lambda_handler(event, context):
    global ec2c
    instance_list = []
    regionslist = ec2c.describe_regions().get('Regions', [])

    for region in regionslist:
        print("=================================\n\n")
        print("Looking at region %s " % region['RegionName'])
        reg = region['RegionName']

        ec2r = boto3.resource('ec2', region_name=reg)

        all_running_instances = [i for i in
                                 ec2r.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['*']}])]
        for instance in all_running_instances:
            print("Available instance : %s" % instance.id)

        instances = [i for i in ec2r.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['*']},
                                                               {'Name': 'tag:AutoShutDown',
                                                                'Values': ['True']},
                                                               {'Name': 'tag:PatchDay',
                                                                'Values': ['ANY']},
                                                               {
                                                                   'Name': 'tag:PatchTimeWindow',
                                                                   'Values': ['02:00-23:30']
                                                               }
                                                               ])]
        for instance in instances:
            print("Instance with specified tags : %s" % instance.id)

        instances_to_delete = [to_del for to_del in all_running_instances if to_del.id not in [i.id for i in instances]]

        for instance in instances_to_delete:
            print("Instance without the specified Tags : %s" % instance.id)
            instance_list.append(instance.id)
        print("=================================\n\n")
    sns.publish(
        TopicArn='arn:aws:sns:us-east-1:901374725663:Lambda_demo',
        Subject='EBS Snapshot',
        Message=str(instance_list))