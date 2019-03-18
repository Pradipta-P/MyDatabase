import boto3
ec2=boto3.resource('ec2')
sns=boto3.client('sns')
backup_filter = [
    {
        'Name': 'tag:Backup',
        'Values': ['Yes']
    }
]
snapshot_ids = []
for instance in ec2.instances.filter(Filters=backup_filter):
    for vol in instance.volumes.all():
        snapshot = vol.create_snapshot(Description='Created by boto3')
        snapshot_ids.append(snapshot.snapshot_id)
sns.publish(
    TopicArn='arn:aws:sns:us-east-1:901374725663:Lambda_demo',
    Subject='EBS Snapshot',
    Message=str(snapshot_ids)
)
