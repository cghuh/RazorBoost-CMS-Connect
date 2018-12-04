#! /bin/bash

ls log/181108/*out > list.out
FileList=list.out

rm -f rerun.txt

for i in `cat $FileList`
do
  while read line; do    
    if [[ "$line" == *"Failed to"* ]];then
      echo $line > temp.out
      rerun=$(sed 's/Failed to transfer the file //' temp.out)
      echo $rerun >> rerun.txt
      rm -f temp.out
      rm -f $i
    fi
    if [[ "$line" == *"Failed ru"* ]];then
      echo $line > temp.out
      rerun=$(sed 's/Failed running script with //' temp.out)
      echo $rerun >> rerun.txt
      rm -f temp.out
      rm -f $i
    fi
  done < $i
done
rm -f $FileList
