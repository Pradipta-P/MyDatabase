import boto3

client = boto3.client('ec2')
responce = client.describe_instances(Filters=[{

    'Name': 'tag:Name',
    'Values': ['Artifactory']
},
    {
        'Name': 'instance-state-name',
        'Values': ['running']
}])

for reservation in responce['Reservations']:
    for instance in reservation['Instances']:
        print("InstanceId is{}".format(instance['InstanceId']))
