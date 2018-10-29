path=/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/SCRIPTpub
folder=$path/out.shuff
foldergene=$path/out.gene.shuff
file=$path/OUTPUT.bday
filegene=$path/OUTPUT.gene.bday

var=`awk 'NR{print}' $file| wc -l`
for i in `ls $folder/OUTPUT.*`
do 
lines=`awk 'NR{print}' $i| wc -l`   
if  [ "$lines" -lt "$var"  ]
then
echo $i
rm $i
fi
done  > $path/remove.out.SHUFF.1		


gen=`awk 'NR{print}' $filegene| wc -l`
for i in `ls $foldergene/OUTPUT.gene.*`
do
lines=`awk 'NR{print}' $i| wc -l`
if  [ "$lines" -lt "$gen"  ]
then
echo $i
rm $i
fi
done  > $path/remove.out.gene.SHUFF.1	
