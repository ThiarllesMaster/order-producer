#Required tools to docker the application inside the EC2
 sudo apt-get update && sudo apt-get install -y ca-certificates git docker.io openjdk-21-jdk maven
 sudo systemctl enable --now docker
 git clone https://github.com/TEU-UTILIZADOR/order-producer.git
 mvn clean package -DskipTests
 sudo docker build -t order-producer:1.0 .

#Comands to push the image
aws ecr create-repository --repository-name eks-lab --region eu-west-1
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 482604438475.dkr.ecr.eu-west-1.amazonaws.com
docker tag eks-lab:1.0 482604438475.dkr.ecr.eu-west-1.amazonaws.com/eks-lab:1.0
docker push 482604438475.dkr.ecr.eu-west-1.amazonaws.com/eks-lab:1.0


 aws sts get-caller-identity
 aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 482604438475.dkr.ecr.eu-west-1.amazonaws.com
 aws ecr describe-repositories --region eu-west-1 --query 'repositories[*].[repositoryName,repositoryUri]' --output table
 aws ecr create-repository --repository-name order-producer --region eu-west-1
 aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 482604438475.dkr.ecr.eu-west-1.amazonaws.com

sudo docker tag order-producer:1.0 482604438475.dkr.ecr.eu-west-1.amazonaws.com/order-producer:1.0

#Commands to link the EC2 to EKS cluster
sudo apt-get update
sudo apt-get install -y curl ca-certificates
sudo snap install kubectl --classic
kubectl version --client
sudo apt install awscli
aws eks update-kubeconfig --region eu-west-1 --name $CLUSTER_NAME

