#marge two files based on the first column
use strict;
use Getopt::Long;

my $delim="\t";
GetOptions ("del:s"=>\$delim);

if (($ARGV[0] eq '')||($ARGV[1] eq '')){
        print "merge file1 file2  -del <delimiting field>\n";
        exit(0)
}

my %id;

open (IN1,$ARGV[0]) || die "file $ARGV[0] not fount $! \n";
open (IN2,$ARGV[1]) || die "file $ARGV[1] not fount $! \n";
my $ncol1;
my $ncol2;

while(<IN1>){
	chomp;
	$_=~s/\r|\n//g;
	my @a=split(/$delim/,$_);
	$id{$a[0]}=$_;
	$ncol1=$#a;
}

close(IN1);
while(<IN2>){
        chomp;
	$_=~s/\r|\n//g;
        my @a=split(/$delim/,$_);
	   $ncol2=$#a;
	if ($id{$a[0]} eq ''){$id{$a[0]}=NA($ncol1)}
        $id{$a[0]}=$id{$a[0]}."~".$_
}
close(IN2);

for my $i(sort keys %id){
	my @a=split(/~/,$id{$i});
	if($a[1] eq ''){$a[1]=NA($ncol2)}
	print join "\t",@a,"\n"	
}

##################################################################################################

sub NA{
	my($n)=@_;
	my $na;
	for (0..$n){$na=$na."NA\t"}
	chop $na;
	return($na)
}

