#!/bin/bash
exit_msg=" Sorry! Something went wrong. Please Delete the Stack and Try Again. "
divider_line="--------------------------------------------------------------------------"
echo

echo $divider_line
echo " Setting up KnowEnG-Platform K8S Cluster  | Roughly 25 mins "
echo " Go do something more productive instead of staring at the screen :) "
echo $divider_line
echo
sleep 2
echo $divider_line
echo " Authorizing kubectl "
echo $divider_line
echo
sleep 2
echo 'KUBECONFIG=/home/ubuntu/kubeconfig' | sudo tee -a /etc/profile.d/kubeconfig.sh >> /dev/null
scp master:/home/ubuntu/kubeconfig .
export KUBECONFIG=/home/ubuntu/kubeconfig
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- kubectl authorized "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " Installing kubectl "
echo $divider_line
sleep 2
sudo apt-get update && sudo apt-get install -y apt-transport-https && \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update && \
  sudo apt-get install -y kubectl
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- kubectl installed and configured "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " EFS Provisioner "
echo $divider_line
sleep 2
kubectl apply -f efs-provisioner.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- EFS provisioned "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " EFS RBAC "
echo $divider_line
sleep 2
kubectl apply -f https://raw.githubusercontent.com/kubernetes-incubator/external-storage/master/aws/efs/deploy/rbac.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- EFS RBAC applied "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " PVCs - networks "
echo $divider_line
sleep 2
kubectl apply -f https://raw.githubusercontent.com/prkriz/knowkubedev/master/pvcs/networks.pvc.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- networks pvc created "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " PVCs - postgres "
echo $divider_line
sleep 2
kubectl apply -f https://raw.githubusercontent.com/prkriz/knowkubedev/master/pvcs/postgres.pvc.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- postgres pvc created "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " PVCs - redis"
echo $divider_line
sleep 2
kubectl apply -f https://raw.githubusercontent.com/prkriz/knowkubedev/master/pvcs/redis.pvc.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- redis pvc created "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " PVCs - userfiles "
echo $divider_line
sleep 2
kubectl apply -f https://raw.githubusercontent.com/prkriz/knowkubedev/master/pvcs/userfiles.pvc.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- userfiles pvc created "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi


echo $divider_line
echo " Seeding Knowledge Network | Takes about 5 minutes "
echo $divider_line
sleep 2
ssh -t master 'sudo mkdir efs' && \
	ssh -t master 'echo 'export EFS_DNS=$EFS_DNS' | sudo tee -a /etc/profile.d/efs.sh >> /dev/null' && \
	ssh -t master "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_DNS:/ efs" && \
	ssh -t master "sudo aws s3 cp --recursive s3://KnowNets/KN-20rep-1706/userKN-20rep-1706/ /home/ubuntu/efs/$(sudo ls /home/ubuntu/efs/ | grep networks)/"
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- KnowNet seeded "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi
