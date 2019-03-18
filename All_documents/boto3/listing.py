import boto3

ec2 = boto3.resource('ec2')
sns = boto3.client('sns')
instance_ids = []
for instance in ec2.instances.all():
    print("InstanceId is {} and Instance Type is {}".format(instance.instance_id, instance.instance_type))
    instance_ids.append(instance.instance_id)

sns.publish(
        TopicArn='arn:aws:sns:us-east-1:901374725663:Lambda_demo',
        Subject='EBS Snapshot',
        Message=str(instance_ids)
    )