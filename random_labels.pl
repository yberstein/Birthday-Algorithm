use strict;
open(IN,$ARGV[0]);
my %a=(0=>'Case',1=>'Control');

while(<IN>){
	chomp;
	my @a=split(/\t/,$_);
	my $r=int(rand(2));
	print $a[0],"\t",$a{$r},"\n";
}
