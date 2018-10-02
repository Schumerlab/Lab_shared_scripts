#perl! -w

###RELIES ON fastahack being in your path
###list format: chrom\tstart\tstop\n
use List::Util qw(sum);

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list file\n";

my $genome=shift(@ARGV); chomp $genome;

my $counter=0;
while(my $line=<IN>){

    $counter=$counter+1;
    chomp $line;
    my @elements=split(/\t/,$line);

    my $group=$elements[0]; chomp $group;
    my $start=$elements[1]; chomp $start;
    my $stop=$elements[2]; chomp $stop;

    my $region=qx(fastahack $genome -r $group:$start..$stop); chomp $region;

    #print "$region\n";

    if($counter == 1){
	print "chr\tpos1\tpos2\tA\tT\tC\tG\tat\tgc\n";
    }#header

  my  %counts=();
foreach my $char ( split //, $region ) { $counts{$char}++ }
my $A_count = sum( @counts{ qw(A a) } );
my $T_count = sum( @counts{ qw(T t) } );
my $C_count = sum( @counts{ qw(C c) } );
my $G_count = sum( @counts{ qw(G g) } );

    my $at=0; my $gc=0;
    if(($A_count + $T_count + $C_count + $G_count)>0){
    $at=($A_count + $T_count)/($A_count + $T_count + $C_count + $G_count);
    $gc=($G_count + $C_count)/($A_count + $T_count + $C_count + $G_count);
    }
print "$line\t$A_count\t$T_count\t$C_count\t$G_count\t$at\t$gc\n";    

}#for each specified region
