import boto3

ec2=boto3.resource('ec2')

for instance in ec2.instances.filter(Filters=[
    {
    'Name': 'availability-zone',
    'Values': ['us-east-1d']
},
    {
        'Name': 'tag:Name',
        'Values': ['Docker _Lab']
    },
    {
        'Name': 'instance-state-name',
        'Values': ['*']
    }
]):
    print("InstanceId is {} and Instance Type is {}".format(instance.instance_id, instance.instance_type))