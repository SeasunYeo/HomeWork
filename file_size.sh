Usage(){
	echo "usage: ./file_size.sh [-n N] [-d DIR]"
	echo "Show top N largest files/directories"
}
printFiles(){
	local path=$2
	local N=`expr $1 + 1`
	n="2,"$N"p"
	echo "The largest files/directories in $path are"
	ls -sh --sort=size $path | sed -n $n | awk '{ print "\t" NR "\t" $1 "\t" $2}'
	exit
}
if [[ $1 = "-n" && $3 = "-d" ]]
	then
		printFiles $2 $4
else
	Usage
fi
