path=/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/SCRIPTpub
script=/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/SCRIPTpub/scripts
rm -r $path/in.shuff
rm -r $path/out.shuff
rm -r $path/out.gene.shuff
rm -r $path/log.shuff
mkdir $path/in.shuff
mkdir $path/out.shuff
mkdir $path/out.gene.shuff
mkdir $path/log.shuff


##loop for resampling affected status (1k permutations - 1 1000)
for i in `seq 1 1000`
#for i in `seq 101 118` ##complete missing permutations start 1001
do
	perl $script/random_labels.pl sample_id.txt >$path/in.shuff/sample_id.$i.temp

	echo "
		n=\$(grep Case $path/in.shuff/sample_id.$i.temp |wc -l);

		####count total control (M)
		m=\$(grep Control $path/in.shuff/sample_id.$i.temp |wc -l);

		###for each position count recurrence case (k) and recurrence control (l)
		pos=\$(wc -l out.012.pos);
		perl $script/count_recurrence.pl out.012.fixed $path/in.shuff/sample_id.$i.temp out.012.pos| awk ' { print \$1\"_\"\$2 \"\\t\" \$3 \"\\t\" \$4 } '  > $path/in.shuff/recurrence.$i.temp
		perl $script/merge.files.pl pos.gene.size.txt $path/in.shuff/recurrence.$i.temp |awk ' { print \$1 \"\\t\" \$2 \"\\t\"\$3 \"\\t\" \$5 \"\\t\" \$6 } '>$path/in.shuff/pos.gene.size.recurrence.$i.temp
		awk -v N=\$n -v M=\$m ' { print \$0 \"\\t\" N \"\\t\" M  } ' $path/in.shuff/pos.gene.size.recurrence.$i.temp |sed 's/(/|/g' |sed 's/)/ /g' |awk '{FS=\"\\t\"}{ if(\$3!=\"NA\") print \$0}' |sed 's/[ ]*//g' > $path/in.shuff/INPUT.$i.bday
		###Make input for gene level: for each gene count recurrence case (k) and recurrence control (l)
	 	sed 's/|.*//g' $path/in.shuff/INPUT.$i.bday|cut -f1,2> $path/in.shuff/INPUT.$i.bday.1.temp
                cut -f3-7 $path/in.shuff/INPUT.$i.bday > $path/in.shuff/INPUT.$i.bday.2.temp
                paste $path/in.shuff/INPUT.$i.bday.1.temp $path/in.shuff/INPUT.$i.bday.2.temp > $path/in.shuff/INPUT.$i.bday.fix 		
		awk '{a[\$2]+=\$4}END{for (i in a){print i\"\\t\"a[i]}}' $path/in.shuff/INPUT.$i.bday.fix > $path/in.shuff/rec.gene.case.$i.temp
		awk '{a[\$2]+=\$5}END{for (i in a){print i\"\\t\"a[i]}}' $path/in.shuff/INPUT.$i.bday.fix > $path/in.shuff/rec.gene.ctrl.$i.temp
                perl $script/merge.files.pl $path/in.shuff/rec.gene.case.$i.temp $path/in.shuff/rec.gene.ctrl.$i.temp|awk ' { print  \$1\"\\t\"\$2\"\\t\"\$4}' >$path/in.shuff/rec.gene.$i.temp
		perl $script/merge.files.pl gene.size.txt $path/in.shuff/rec.gene.$i.temp |awk ' {print  \$1\"\\t\"\$3\"\\t\"\$2\"\\t\"\$4\"\\t\"\$5}' > $path/in.shuff/gene.size.rec.$i.temp
                awk -v N=\$n -v M=\$m ' { print \$0 \"\\t\" N \"\\t\" M  } ' $path/in.shuff/gene.size.rec.$i.temp |sed 's/(/|/g' |sed 's/)/ /g' |awk '{FS=\"\\t\"}{ if(\$3!=\"NA\") print \$0}' |sed 's/[ ]*//g' > $path/in.shuff/INPUT.gene.$i.bday
		###variant level bday
		Rscript $script/birthday_Sup_7.rsc $path/in.shuff/INPUT.$i.bday 0.05 > $path/out.shuff/OUTPUT.$i.bday
		###gene level bday
                Rscript $script/birthday_Sup_7.rsc $path/in.shuff/INPUT.gene.$i.bday 0.05 > $path/out.gene.shuff/OUTPUT.gene.$i.bday
	" > qsub.sh
	qsub -cwd -e log.shuff -o log.shuff -l m_mem_free=8G qsub.sh


done

