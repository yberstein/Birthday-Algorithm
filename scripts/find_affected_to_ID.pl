#!/usr/bin/perl
#use strict;

my $patterns=$ARGV[0]; #file with sample IDs corresponding to genotype matrix (out.012.pos)
my $search=$ARGV[1]; #"fam.example.txt"; #file affected status (fam file)

#my $search="/sonas-hs/mccombie/hpc/data/yberstei/BirthdayModel/Synaptome2015/fam.r1234.pca.ymd-140211.txt"; #file where we search (fam file)

open(SR,$search)|| die "$search $!\n";
open(PA,$patterns)|| die "$patterns $!\n";

my %hash;

while(<SR>){
	chomp;
	my @a=split(/\t/,$_);
	$hash{$a[0]}=$a[1];	
}
close(SR);

while(<PA>){
        chomp;
        my @a=split(/\t/,$_);
        print $_,"\t",$hash{$a[0]},"\n"
}
close(PA);

