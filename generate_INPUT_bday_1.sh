#!/bin/bash
script=/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/SCRIPTpub/scripts
perl $script/find_gene_to_pos.pl out.012.pos anno.example.txt> gene.temp;
perl $script/appris_size_to_pos.pl gene.temp | awk ' { print $1"_"$2 "\t" $3 "\t" $4 } ' > pos.gene.size.0.temp;
sed 's/(.*//g' pos.gene.size.0.temp|cut -f1,2 >pos.gene.size.1.temp
cut -f3 pos.gene.size.0.temp> pos.gene.size.2.temp
paste pos.gene.size.1.temp pos.gene.size.2.temp > pos.gene.size.txt
cut -f2,3 pos.gene.size.txt > gene.size.txt;

####count total cases (N)
perl $script/find_affected_to_ID.pl out.012.indv fam.example.txt > sample_id.txt


echo "		n=\$(grep Case sample_id.txt |wc -l);

		####count total control (M)
		m=\$(grep Control sample_id.txt |wc -l);

		###for each position count recurrence case (k) and recurrence control (l)
		pos=\$(wc -l out.012.pos);
		perl $script/count_recurrence.pl out.012.fixed sample_id.txt out.012.pos| awk ' { print \$1\"_\"\$2 \"\\t\" \$3 \"\\t\"\$4 } '  > recurrence.temp
		perl $script/merge.files.pl pos.gene.size.txt recurrence.temp |awk ' { print \$1 \"\\t\" \$2 \"\\t\" \$3 \"\\t\" \$5 \"\\t\" \$6 } '> pos.gene.size.recurrence.temp
		###final table for input
		awk -v N=\$n -v M=\$m ' { print \$0 \"\\t\" N \"\\t\" M  } ' pos.gene.size.recurrence.temp |sed 's/(/|/g' |sed 's/)/ /g' | awk '{FS=\"\\t\"}{ if(\$3!=\"NA\") print \$0}' |sed 's/[ ]*//g' > INPUT.bday
		 ###Make input for gene level: for each gene count recurrence case (k) and recurrence control (l)
                sed 's/|.*//g' INPUT.bday|cut -f1,2> INPUT.bday.1.temp
		cut -f3-7 INPUT.bday >INPUT.bday.2.temp
		paste INPUT.bday.1.temp INPUT.bday.2.temp > INPUT.bday.fix
		awk '{a[\$2]+=\$4}END{for (i in a){print i\"\\t\"a[i]}}' INPUT.bday.fix > rec.gene.case.temp
                awk '{a[\$2]+=\$5}END{for (i in a){print i\"\\t\"a[i]}}' INPUT.bday.fix > rec.gene.ctrl.temp
                perl $script/merge.files.pl rec.gene.case.temp rec.gene.ctrl.temp|awk ' { print  \$1\"\\t\"\$2\"\\t\"\$4}' >rec.gene.temp
                perl $script/merge.files.pl gene.size.txt rec.gene.temp |awk ' {print  \$1\"\\t\"\$3\"\\t\"\$2\"\\t\"\$4\"\\t\"\$5}' > gene.size.rec.temp
                ###final table input 
                awk -v N=\$n -v M=\$m ' { print \$0 \"\\t\" N \"\\t\" M  } ' gene.size.rec.temp |sed 's/(/|/g' |sed 's/)/ /g' |awk '{FS=\"\\t\"}{ if(\$3!=\"NA\") print \$0}' |sed 's/[ ]*//g' > INPUT.gene.bday
                ###variant level bday
		Rscript $script/birthday_Sup_7.rsc INPUT.bday 0.05 >OUTPUT.bday
                ###gene level bday
                Rscript $script/birthday_Sup_7.rsc INPUT.gene.bday 0.05 > OUTPUT.gene.bday
	" > qsub.sh
	qsub -cwd -e log.shuff -o log.shuff -l m_mem_free=8G qsub.sh

#rm *.temp
