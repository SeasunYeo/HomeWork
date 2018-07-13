**factorial.sh**
```
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
```
**程序结构**
首先判断是否存在参数，如果没有参数，则输出usage。有参数时，通过设定全局变量ans存储计算结果，在multi函数内部，通过局部变量prinum来保存当前的操作数，局部变量nextnum保存下一步进行计算的数字，每一次递归中，ans都乘上当前的操作数，然后进入下一层递归，最后得到答案。

**self_compression.sh**
```
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
fi 
```
**解题分析**
看到题目的时候，以为这道题重点在于如何把文件解压缩，但实际开始想程序的时候，才发现这道题最难的在于对文件名进行处理，判断文件类型。刚开始写的程序就是提取出文件的最后一个后缀名，然后在case语句中进行解压缩，但考虑到会存在.tar.gz和.gz文件的最后一个后缀均为.gz，但是二者的解压方式却不一样，如果用.tar.gz的一步解压方式，会造成对.gz文件不适用的情况，但在发现了.tar.gz的分步解压方式其实就是先解压.gz后解压.tar后，选择用一个循环去解决这个问题。用filename变量来存储当前操作的文件名，用nextname来保存去掉当前解压后缀之后的文件名，也就是下一次要操作的文件名，用extention来保存当前操作的后缀类型，如果当前的extention已经不在可解压范围内，则返回Already done，表示已经解压到最后一部。而循环开始时会判定nextname和filename的值是否相等，如果相等，说明文件已经没有后缀，也就意味着解压完成。最后，因为采用的是分布解压的方式，如果用户输入了目标位置的参数，考虑到分布解压的可操作性，决定把分布解压的中间结果全部放在默认目录(也就是压缩文件所在目录)下，然后在解压完成后将解压后的文移动到目标目录下，这样可以减少分步解压出错的可能性，并且可以在代码上，有无目标目录的程序也可以进行合并，只需要在执行完成后，判断如果有目标目录，就进行文件移动。

**file_size.sh**
```
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
```
**解题分析**
感觉这道题本身并不难，但却让我花费了很长的时间。为什么呢？因为我在最后寻找合适的排序方法的时候发生了一些问题。最开始我用的命令是:
ls -sh | sort -rn | sed -n $n | awk...
其实就是先列出来，然后用sort的基于数字排序来进行排序，之后用sed选择前面的输出。但是发现这里面有几个问题，就是ls -sh输出的，永远有一个total，所以需要把total去掉，其次呢就是，ls -sh对于每个有大小的文件都会在大小后面给上合适的单位，但是大小为0的文件却是没有单位的，他在排序用sort排序的时候总是特例独行，所以后来选择了现在的处理方法，在ls的手册里找到了ls自带的sort，那就不用额外的sort了，以大小为依据排序后，大小为0的文件也能得到正确的排序，然后total因为总是最大的，所以总是在第一个，所以用sed提取时，从第二行开始提取，提取需要的个数，然后awk输出，就好了。
