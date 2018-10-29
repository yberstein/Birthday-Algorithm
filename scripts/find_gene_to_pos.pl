#!/usr/bin/perl
#use strict;

my $patterns=$ARGV[0]; #file with positions corresponding to genotype matrix (out.012.pos)
my $search=$ARGV[1]; #file where we search (annotation with gene names in 7th field- anno.example.txt)

open(SR,$search)|| die "$search $!\n";
open(PA,$patterns)|| die "$patterns $!\n";

my %hash;

while(<SR>){
	chomp;
	my @a=split(/\t/,$_);
	my $pos=$a[0].":".$a[1];
        $hash{$pos}=$a[6];	
}
close(SR);

while(<PA>){
        chomp;
        my @a=split(/\t/,$_);
	if($hash{$a[0].":".$a[1]} eq ""){next}
        print $_,"\t",$hash{$a[0].":".$a[1]},"\n"
}
close(PA);

