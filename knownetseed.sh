#!/bin/bash
exit_msg=" Sorry! Something went wrong. Please Delete the Stack and Try Again. "
divider_line="--------------------------------------------------------------------------"
echo
export KUBECONFIG=kubeconfig

echo $divider_line
echo " Deploying KnowEnG pods "
echo $divider_line
sleep 2
kubectl apply -f https://raw.githubusercontent.com/prkriz/knowkubedev/master/nest.prod.yaml
if [ $? -eq 0 ]
	then
	echo
	echo " Success-- KnowEnG Pods Deployed "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " Exposing Load Balancer "
echo $divider_line
sleep 2
kubectl expose --namespace=default deployment nest --type=LoadBalancer --port=80 --target-port=80 --name=nest-public-lb
if [ $? -eq 0 ]
	then
	echo
	sleep 2
	echo " Success-- Load Balancer Exposed "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " Getting things Ready | Takes about 20 mins. Go play with your cat :) "
echo $divider_line
i=20; while [ $i -gt 0 ]; do echo $i minute\(s\) remaining; i=`expr $i - 1`; sleep 60;  done
echo " Success-- KnowEnG Platform is almost ready "
sleep 2
echo

echo $divider_line
echo " Printing Load Balancer "
echo $divider_line
sleep 2
kubectl --namespace=default describe service nest-public-lb | grep "LoadBalancer Ingress"
if [ $? -eq 0 ]
	then
	echo
	echo " Use the lb URL "
	sleep 2
	echo
else
	echo $exit_msg
	exit
fi

echo $divider_line
echo " Congratulations-- KnowEnG Platform IS READY TO ROLL. Thank You for your patience."
echo $divider_line
echo
