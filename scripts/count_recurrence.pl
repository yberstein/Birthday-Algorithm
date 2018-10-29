#!/usr/bin/perl
use strict;

my $mat_file=$ARGV[0]; #genotype matrix (out.012.fixed)
my $sam_file=$ARGV[1]; #sample_id.temp(sample ID and case/control status)
my $pos_file=$ARGV[2]; #column names
my (%sam,%pos,%count);
my ($sam,$pos); #counter of row number, collumn number
my @mtx;
open(IN,$mat_file);
open(SAMPLE,$sam_file);
open(POS,$pos_file);

#make a hash of sample category (case/control) with row number as key
while(<SAMPLE>){
	chomp;
	my @a=split(/\t/,$_);
	$sam{$sam++}=$a[1];
} 
close(SAMPLE);

#make a hash of position name  (chr"\t"coo) with col number as key
while(<POS>){
        chomp;
        my @a=split(/\t/,$_);
        $pos{$pos++}=$a[0]."\t".$a[1];;
}
close(POS);

#make an array of rows 
while(<IN>){
	chomp;
	push @mtx,$_;
}
close(IN);


#parse matrix
for my $i (0..$#mtx){ #0 to total number of rows/sample
	my @r=split(/\t/,$mtx[$i]); #each row turns to an array (all snps same sample)
	warn $i,"\n";
	for my $j(0..$#r){#) to total number of columns/positions
		$count{$pos{$j}}{$sam{$i}}+=$r[$j];#hash bidimensional (position)(sample:case or control):($c += $a is equivalent to $c = $c + $a),r is 0 or1
	}
}
warn "here\n";
#print output
foreach my $k (sort keys %count){ #sort alfabetic order positions
	$count{$k}{Case}=($count{$k}{Case} eq ""?0:$count{$k}{Case});#take care of empty values:if so print "0"
	$count{$k}{Control}=($count{$k}{Control} eq ""?0:$count{$k}{Control});
	print $k,"\t",$count{$k}{Case},"\t",$count{$k}{Control},"\n"
}
