if [ -z $1 ]
    then
	echo "usage: 1.factorial.sh [n]"
	echo "caculates a number's factorial"
    exit -1
fi
num=$1
ans=1
multi(){
	local prinum=$1
	local nextnum=`expr $prinum - 1`
	if [ $prinum -lt 1 ]
	then 
			 return 0
	elif [ $prinum == 1 ]
	then 
			return 0
	else
		ans=`expr $ans \* $prinum`
		multi $nextnum	
	fi
}
multi $num
echo $ans
