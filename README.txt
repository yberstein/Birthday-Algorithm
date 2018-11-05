------------------------------------------------------------------------------------------------------
Algorithm for the detection of rare disease-related genetic variants using the birthday model 
------------------------------------------------------------------------------------------------------

Description
------------
Probabilistic method to predict causative rare variants in case-control
studies using a popular
probabilistic problem, the Birthday Model, which estimates the probability
that a group of individuals share the same birthday. We consider the
probability and coincidence of samples sharing a variant akin to the chance of
individuals sharing the same birthday.Can be applied in both variant or gene
level analysis.

Getting Started
---------------
These instructions will guide you how to apply this algorithm to your genomic data.
First, download all files provided here your local machine or server. This include all scripts and the database(appris_data.appris.P.UNIQ.SIZE.txt) necessary to run the algorithm. Also an example is included, including the output of the scripts. It shows the format of the input files you will need to get started. 

Prerequisites
--------------
Softwares:
* Unix
* Perl
* R
* vcf tools

List of scripts for running algorithm:
Main scripts:
* generate_INPUT_bday_1.sh
* generate_INPUT_bday_SHUFF_2.sh
* check_complete.SHUFF_3.sh
* generate_INPUT_bday_SHUFF_redo_4.sh 
* ParsePermutations_5.sh
* WestfallYoung.Shuff_6.sh

Sub scripts:
* appris_size_to_pos.pl
* birthday_Sup_7.rsc 
* count_recurrence.pl
* find_affected_to_ID.pl  
* find_gene_to_pos.pl  
* merge.files.pl
* random_labels.pl  

Example
------------
The example (example.vcf) is from the 1000 genome project
http://www.internationalgenome.org/home
Here we focus on chr22 --> ALL.chr22.phase3_shapeit2_mvncall_integrated_v5_extra_anno.20130502.genotypes.vcf
In order to illustrate a case-control study we uses the 94 individuals of COL
population as cases. And the 96 individuals of CEU population as controls.

The anno.example.txt file, is the annotation file obtained by ANNOVAR, maily
to get gene names where the variants are located. Any annotation tool of your
preference can be used, just make sure the gene names are inn 7th field. For this example we included only :missense, stopgain and stop loss
variants with maf<=1%).

The fam file fam.example.txt provide labels of status of the individuals
(case or control )


Authors
________________
Yael Berstein
See also the list of contributors who participated in this project.

License
________________
MIT License

Copyright (c) 2018 Yael Berstein

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

 
#######################################   README.txt      ############################################

--------------------------------------------------------------------------------------------------------------------------------------
Input files
--------------------------------------------------------------------------------------------------------------------------------------
1. example.vcf  ##vcf file
### from 1K genome project : chr22: ALL.chr22.phase3_shapeit2_mvncall_integrated_v5_extra_anno.20130502.genotypes.vcf   CEU:96; COL:94

2. anno.example.txt ##annotation file with gene names in 7th field to use find_gene_to_pos.pl script. 
### for this example we included only :missense, stopgain and stop loss variants with maf<=1%) 

3. fam.example.txt ## fam file : provide labels of status of the individuals (case or control)

4. appris_data.appris.P.UNIQ.SIZE.txt ###from APPRIS database the size of the
gene based on the principal isoform, for details http://appris.bioinfo.cnio.es/#/


-------------------------------------------------------------------------------------------------------------------------------------
Get started
--------------------------------------------------------------------------------------------------------------------------------------
Using vcftools:

1. Convert vcf file to genotype matrix:
* vcf file: example.vcf

vcftools --vcf example.vcf  --012

2. Transform genotype matrix to a binary matrix (homozygous for variant allele or heterozygous genotype > 1; missing genotype or homozygous for reference > 0):  

sed 's/\-1/0/g' out.012 |sed 's/2/1/g' > out.012.fixed

3. Update your files names as follows:
 annotation file name to  "anno.example.txt" 

cp "your annotation file" anno.example.txt
 
 fam file name to "fam.example.txt"

cp "your fam file" fam.example.txt
 
4. Run generate_INPUT_bday_1.sh 

5. Update the paths on script:  generate_INPUT_bday_SHUFF_2.sh . Then run it.

6. Update the paths on script:  check_complete.SHUFF_3.sh . Then run it. This script check the permutations that
got incompleted. After running it do the following:
 6.1 wc -l remove.out.SHUFF.1
     wc -l remove.out.gene.SHUFF.1 
 6.2 If any of those is not zero, go to script
generate_INPUT_bday_SHUFF_2_redo.sh and change the values on the sequence to complete the permutations. For
example: if wc -l remove.out.SHUFF.1 is 3, and we asked for 1000 permutations
change as follows:
for i in `seq 1001 1003` 
##For avoiding gene or variant level, in case of not needed extra
permutation, turn to moments the respective command lines in the script.
Return to beginning of 6,(variant or/and gene level) change the suffix number in the script to next
number: remove.out.SHUFF.1--> remove.out.SHUFF.2 ; remove.out.gene.SHUFF.1-->
remove.out.gene.SHUFF.2 
7. Update the path on script:  ParsePermutations_5.sh  . Then run it.
8. Update the path on script and number of permutations ("perm",if needed):  check_complete.Parse_6.sh . Then run it.
9. Update the path on script:   WestfallYoung.Shuff_6.sh  . Then run it.

Your results are in the following files:
*Variant level : OUTPUT.bday.wy (all variants) and OUTPUT.bday.wy.RANKED(top
results ranked)
*Gene level : OUTPUT.gene.bday.wy (all genes) and OUTPUT.gene.bday.wy.RANKED(top 
results ranked)


