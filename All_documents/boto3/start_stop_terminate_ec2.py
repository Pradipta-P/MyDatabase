import boto3
client = boto3.client('ec2')

#Start the specified instances and print the instanceIds
responce = client.start_instances(InstanceIds=['i-02bf86336b914b2ad', 'i-0b436b1d79298bbd4'])

for instance in responce['StartingInstances']:
    print("The Instance ID {} has been started successfully".format(instance['InstanceId']))

#Stop the specified instances and print the instanceIds
# responce = client.stop_instances(InstanceIds=['i-02bf86336b914b2ad', 'i-0b436b1d79298bbd4'])

# for instance in responce['StoppingInstances']:
 #   print("The Instance ID {} has been stopped successfully".format(instance['InstanceId']))


#Terminate the specified instances and print the instanceIds
# responce = client.terminate_instances(InstanceIds=['i-00e53b6ea5b1eb60b'])

# for instance in responce['TerminatingInstances']:
 #   print("The Instance ID {} has been terminated".format(instance['InstanceId']))