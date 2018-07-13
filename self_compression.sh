Usage(){
	echo "Usage self_compression.sh [--list] or [Source compressed file] [Destination path]"
	echo "Self compression according to the file name suffix"
	exit
}

List(){
	echo "Supported file types: .rar .tar .bz .bz2 .gz .z .zip"
	exit
}
cycle=0
filename=$1
path=$2
extention="${filename##*.}"
defaultpath="${filename%/*}"
nextname="${filename%.*}"
if [ -z $filename ]; then
	Usage;
elif [ $filename = '--list' ];	then
	List;
elif [[ -n $filename ]]; then
	while  [[ ! "$nextname" == "$filename" ]]
	do
		case $extention in 
			'tar')
				echo "解压tar文件"
				eval "tar xvf $filename -C $defaultpath";;
			'gz')
				echo "解压gz文件"
				eval "gzip -d $filename";;
			'bz2')
				echo "解压bz2文件"
				eval "bzip2 -d $filename";;
			'zip')
				echo "解压zip文件"
				eval "unzip $filename -d $defaultpath";;
			'rar')
				echo "解压rar文件"
				eval "rar x $filename $defaultpath";;
			'bz')
				echo "解压bz文件"
				eval "bzip2 -d $filename";;
			'z')
				echo "解压z文件"
				eval "uncompress $filename";;
			*)
				if [ "$cycle" -eq 0 ]; then 
					echo "error(101) This type is not supported(tar|gz|gz2|zip|z|rar|bz|bz2)";
				else
					echo "already done";
					exit;
				fi
		esac
		filename=$nextname
		nextname="${filename%.*}"
		extention="${filename##*.}"
		let "cycle++"
	done
	if [[ -n $path ]]; 	then
		eval "mv $filename $path"
	fi
	echo "right"	
#elif [[ -n $filename && -n $path ]];	then
#	while  [[ ! "$nextname" == "$filename" ]]
#	do
#		case $extention in 
#			'tar')
#				echo "解压tar文件"
#				eval "tar xvf $filename -C $defaultpath";;
#			'gz')
#				echo "解压gz文件"
#				eval "gzip -d $filename";;
#			'bz2')
#				echo "解压bz2文件"
#				eval "bzip2 -d $filename";;
#			'zip')
#				echo "解压zip文件"
#				eval "unzip $filename -d $defaultpath";;
#			'rar')
#				echo "解压rar文件"
#				eval "rar x $filename" $defaultpath;;
#			'bz')
#				echo "解压bz文件"
#				eval "bzip2 -d $filename";;
#			'z')
#				echo "解压z文件"
#				eval "uncompress $filename";;
#			*)
#				if [ "$cycle" -eq 0 ]; then 
#					echo "error(101) This type is not supported(tar|gz|gz2|zip|z|rar|bz|bz2)";
#				else
#					echo "Already done"
#					eval "mv $filename $path"
#					exit;
#				fi
#		esac
#		filename=$nextname
#		nextname="${filename%.*}"
#		extention="${filename##*.}"
#		let "cycle++"
#	done
#	eval "mv $filename $path"
fi 
