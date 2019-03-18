import boto3

ec2 = boto3.resource('ec2')


def lambda_handler(event, context):
 instances = ec2.instances.filter(Filters=[{
    'Name':'tag:AutoOff',
    'Values':['True']
}])
 for instance in instances:
    instance.start()

    print('Success')