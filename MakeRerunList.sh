#! /bin/bash

ls log/181108/*out > list.out
FileList=list.out

rm -f rerun.txt
j=0
k=0
for i in `cat $FileList`
do
  while read line; do    
    if [[ "$line" == *"exceed"* ]];then
      #echo "disk quota exceed"
      echo $rerun >> rerun.txt
      rm -f temp.out
      rm -f $i
      k=$((k+1))
    elif [[ "$line" == *"Failed to"* ]];then
      echo $line > temp.out
      rerun=$(sed 's/Failed to transfer the file //' temp.out)
      echo $rerun >> rerun.txt
      rm -f temp.out
      rm -f $i
      j=$((j+1))
    elif [[ "$line" == *"Failed ru"* ]];then
      echo $line > temp.out
      rerun=$(sed 's/Failed running script with //' temp.out)
      echo $rerun >> rerun.txt
      rm -f temp.out
      rm -f $i
      j=$((j+1))
    fi
  done < $i
done
rm -f $FileList
echo $((j+k)) files need to rerun
echo $k has disk quota exceed
