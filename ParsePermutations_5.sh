path=/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/SCRIPTpub
rm -r $path/wy.cache
rm -r $path/wy.gene.cache
mkdir $path/wy.cache
mkdir $path/wy.gene.cache
rm -r $path/wy.log
rm -r $path/wy.gene.log
mkdir $path/wy.log
mkdir $path/wy.gene.log
file=$path/OUTPUT.bday
filegene=$path/OUTPUT.gene.bday
var=`awk 'NR{print}' $file| wc -l`
for row in `seq 2 $var` 
do 
   name=`awk -v r=$row 'NR==r'  $path/out.shuff/OUTPUT.30.bday  |cut -f2`
   echo "
	for i in \`ls $path/out.shuff/*\`
	do
      	 awk -v r=$row 'NR==r' \$i | cut -f9,10 
        done > $path/wy.cache/$name " > qsub.sh
        qsub -cwd -e wy.lg -o wy.log -l m_mem_free=8G qsub.sh
done

gen=`awk 'NR{print}' $filegene| wc -l`
for row in `seq 2 $gen` 
do 
   name=`awk -v r=$row 'NR==r'  $path/out.gene.shuff/OUTPUT.gene.30.bday  |cut -f2`
   echo "
        for i in \`ls $path/out.gene.shuff/*\`
        do
         awk -v r=$row 'NR==r' \$i | cut -f9,10 
        done > $path/wy.gene.cache/$name " > qsub.sh
        qsub -cwd -e wy.lg -o wy.gene.log -l m_mem_free=8G qsub.sh
done
