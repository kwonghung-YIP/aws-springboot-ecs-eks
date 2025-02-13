## Features coverd in this example
- Create a ECS Cluster which uses EC2 instances as working node, and deploy a Nginx service on it
- EC2 instances are spinned up with Auto Scaling Group and EC2 Launch Template


##
```bash
sudo echo ECS_CLUSTER=esc-ec2-cluster >> /etc/ecs/ecs.config

sudo cfn-get-metadata \
    --stack=ecs-ec2-cluster \
    --region=eu-north-1 \
    --resource=EC2NodeLaunchTemplate

sudo cfn-init -v \
    --stack ecs-ec2-cluster \
    --resource EC2NodeLaunchTemplate \
    --region eu-north-1    
```

## Problem encountered

If multiple security groups allow a EC2 outbound connection, but the destination resourse (e.g. EFS) only allows inbound connection for one of the security groups, so how to determine which group will be used?

## Reply from Amazon Q
When an EC2 instance has multiple security groups attached that allow outbound connections, and the destination resource (like EFS) only allows inbound connections from one specific security group, the determination of which security group will be used for the connection is based on the following principles:

* Outbound Rules Evaluation: All security groups attached to the EC2 instance are evaluated for outbound rules. If any of the security groups allow the outbound connection, the traffic is permitted to leave the instance.
* Inbound Rules at Destination: The destination resource (e.g., EFS) will only accept incoming connections that match its inbound rules. In this case, only connections from the specified security group will be allowed.
* Security Group Matching: The connection will only be established if the security group ID of the outbound traffic matches the one specified in the destination's inbound rules.
* First Match Principle: If multiple security groups attached to the EC2 instance allow the outbound connection and match the destination's inbound rules, the first matching security group (in terms of rule evaluation order) will be used for the connection.
* Stateful Behavior: Once a connection is established, return traffic is automatically allowed, regardless of outbound rules on the destination or inbound rules on the source.

It's important to note that while multiple security groups may allow outbound connections, only the one that matches the destination's inbound rules will effectively establish the connection. This behavior ensures that the principle of least privilege is maintained, allowing fine-grained control over network access.

For best practices:

* Minimize Security Groups: Attach only the necessary security groups to your EC2 instances to reduce complexity and potential conflicts.
* Use Specific Rules: Create specific inbound and outbound rules in your security groups, avoiding overly permissive settings.
* Regular Audits: Regularly review and audit your security group configurations to ensure they align with your security requirements.
* Documentation: Maintain clear documentation of your security group configurations and their intended purposes.
* Use Tags: Utilize AWS tags to help organize and manage your security groups effectively.

## Reference
- [Amazon ECS clusters](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html)
- [Capacity providers for the EC2 launch type](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/asg-capacity-providers.html)
- [Amazon EC2 container instances for Amazon ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-capacity.html)
- [CloudFormation Template Example - ECS Cluster](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/quickref-ecs.html)
- [Create an Amazon ECS cluster with Amazon Linux 2023 ECS-Optimized-AMI](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html#aws-resource-ecs-cluster--examples--Create_an_cluster_with_the_Amazon_Linux_2023_ECS-Optimized-AMI)
- [Bootstrapping Amazon ECS Linux container instances to pass data](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/bootstrap_container_instance.html)
- [ECS agent (/etc/ecs/ecs.config) Environment Variables References](https://github.com/aws/amazon-ecs-agent/blob/master/README.md#environment-variables)
- [Associate an Application Load Balancer with an Amzaon ECS service](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html#aws-resource-ecs-service--examples--Associate_an_Application_Load_Balancer_with_an_service)
- [AWS ECS - Allocate a network interface for an Amazon ECS task](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking-awsvpc.html)
- [ECS Workshop](https://ecsworkshop.com/ecs_networking/awsvpc/)
- [How do I pass values between nested stacks within the same parent stack in AWS CloudFormation?](https://repost.aws/knowledge-center/cloudformation-nested-stacks-values)