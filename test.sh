ssh -t master 'sudo cp test efs/$(ls efs/ | grep networks)/'
