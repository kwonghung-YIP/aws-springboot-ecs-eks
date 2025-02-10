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