import boto3
client = boto3.client('ec2')
resp = client.run_instances(ImageId='ami-0e3688b4a755ad736',
    InstanceType='t2.micro',
    MaxCount=1,
    MinCount=1)
for instances in resp['Instances']:
    print(instances['InstanceId'])