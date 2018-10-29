#!/usr/bin/perl
##use strict;

my $patterns=$ARGV[0]; #file with positions corresponding to genotype matrix (out.012.pos) AnD corresponding Gene
my $search="appris_data.appris.P.UNIQ.SIZE.txt "; #file where we search (appris annotation)

open(SR,$search)|| die "$search $!\n";
open(PA,$patterns)|| die "$patterns $!\n";

my %hash;

while(<SR>){
	chomp;
	my @a=split(/\t/,$_);
	$hash{$a[0]}=($a[2]*3);	
}
close(SR);

while(<PA>){
        chomp;
        my @a=split(/\t/,$_);
        my @gene=split(/\(/,$a[2]);
	my @gene_list=split(/,/,$gene[0]);
	my $size;
	foreach $gene(@gene_list){
		if($hash{$gene} eq ""){next}
		$size=$hash{$gene}
	}
		if($size eq ""){$size="NA"}
		print $_,"\t",$size,"\n"
}
close(PA);
