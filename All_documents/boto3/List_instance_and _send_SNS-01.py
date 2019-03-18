import boto3
import logging

# define client connection
ec2c = boto3.client('ec2')
# define ressources connection
# ec2r = boto3.resource('ec2')
sns = boto3.client('sns')


def lambda_handler(event, context):
    global ec2c
    global ec2r
    instance_list = []

    # Get list of regions
    regionslist = ec2c.describe_regions().get('Regions', [])

    # Iterate over regions
    for region in regionslist:
        print("=================================\n\n")
        print("Looking at region %s " % region['RegionName'])
        reg = region['RegionName']

        # Connect to region
        # ec2r = boto3.setup_default_session(region_name=reg)
        ec2r = boto3.resource('ec2', region_name=reg)

        # get a list of all instances
        all_running_instances = [i for i in
                                 ec2r.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['*']}])]
        for instance in all_running_instances:
            print("Available instance : %s" % instance.id)

        # get instances with filter of running + with tag `Name`
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

        # make a list of filtered instances IDs `[i.id for i in instances]`
        # Filter from all instances the instance that are not in the filtered list
        instances_to_delete = [to_del for to_del in all_running_instances if to_del.id not in [i.id for i in instances]]

        # run over your `instances_to_delete` list and terminate each one of them

        for instance in instances_to_delete:
            print("Instance without the specified Tags : %s" % instance.id)
            instance_list.append(instance.id)
        print("=================================\n\n")
    sns.publish(
        TopicArn='arn:aws:sns:us-east-1:901374725663:Lambda_demo',
        Subject='EBS Snapshot',
        Message=str(instance_list))