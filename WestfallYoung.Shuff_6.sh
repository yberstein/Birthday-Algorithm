path=/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/SCRIPTpub  ####Here change to your path.
file=$path/OUTPUT.bday
filegene=$path/OUTPUT.gene.bday
cut -f2,3,9,10 $file | sed 1d | sed 's/[ ]*//g'> $path/temp.main #OUTPUT.bday
cut -f2,3,9,10 $filegene | sed 1d | sed 's/[ ]*//g'> $path/temp.gene.main #OUTPUT.gene.bday
 

while read snp gene case ctrl
do
	yes=`awk -v case=$case -v ctrl=$ctrl '{if(($1<=case)&&($2>=ctrl)){print $0}}' $path/wy.cache/$snp | wc -l `
	no=`awk -v case=$case -v ctrl=$ctrl '{if(($1>case)||($2<ctrl)){print $0}}'  $path/wy.cache/$snp | wc -l `
	echo -e "$snp\t$gene\t$yes\t$no" | awk '{print $0"\t"($3/($3+$4))}'
done< $path/temp.main  > $path/OUTPUT.bday.wy
awk '($5!=1)' $path/OUTPUT.bday.wy > $path/OUTPUT.bday.wy.RANKED |sort -k5  ##to get the sorted list according to the adjusted p (without p=1)

while read gene gene case ctrl
do
        yes=`awk -v case=$case -v ctrl=$ctrl '{if(($1<=case)&&($2>=ctrl)){print $0}}' $path/wy.gene.cache/$gene | wc -l `
        no=`awk -v case=$case -v ctrl=$ctrl '{if(($1>case)||($2<ctrl)){print $0}}'  $path/wy.gene.cache/$gene | wc -l `
        echo -e "$gene\t$gene\t$yes\t$no" | awk '{print $0"\t"($3/($3+$4))}'
done< $path/temp.gene.main > $path/OUTPUT.gene.bday.wy
awk '($5!=1)' $path/OUTPUT.gene.bday.wy |sort -k5  > $path/OUTPUT.gene.bday.wy.RANKED ##to get the sorted list according to the adjusted p (without p=1)

