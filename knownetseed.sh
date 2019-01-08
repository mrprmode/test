#!/bin/bash
exit_msg=" Sorry! Something went wrong. Please Delete the Stack and Try Again. "
divider_line="--------------------------------------------------------------------------"
echo

echo $divider_line
echo " Seeding Knowledge Network | Takes about 5 minutes "
echo $divider_line
sleep 2
ssh -t master "sudo aws s3 cp --recursive s3://KnowNets/KN-20rep-1706/userKN-20rep-1706/ /home/ubuntu/efs/\$(sudo ls /home/ubuntu/efs/ | grep networks)/"
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
