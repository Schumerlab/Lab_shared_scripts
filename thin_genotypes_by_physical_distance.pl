#perl! -w

if(@ARGV<3){

    print "perl thin_genotypes_by_physical_distance.pl genotypes.txt thinning_threshold_basepairs path_to_transpose_nameout.pl\n"; exit;

}#usage for physical distance thinning

my $infile=shift(@ARGV); chomp $infile; 

my $thresh=shift(@ARGV); chomp $thresh;

my $path=shift(@ARGV); chomp $path;

system("perl $path/transpose_nameout.pl $infile");

my $transposed="$infile"."_transposed";
open IN, $transposed or die "cannot open transposed genotypes file\n";

my $outfile="$infile"."_thinned_physical_dist.txt";
open OUT, ">$outfile";

my $ids=<IN>; chomp $ids;

print OUT "$ids\n";
my $pos_prev=""; my $group_prev=""; my $counter=0;
while(my $line=<IN>){
    chomp $line; $counter++;
  
    my @elements=split(/\t/,$line);
    my $markerinfo=$elements[0]; chomp $markerinfo;

    my @splitmarker=split(/:/,$markerinfo);
    my $pos=$splitmarker[1];
    my $group=$splitmarker[0];
    if($counter eq 1){
	$pos_prev=$pos - $thresh - 1;
	$group_prev=$group;
    }#for first entry

    my $distance=$pos - $pos_prev;

    if(($distance >= $thresh) or ($group ne $group_prev)){
	print OUT "$line\n";
	$pos_prev=$pos;
    }#save, print

    $group_prev=$group;

}#for all lines

my $tmp="$outfile"."_transposed";
system("perl $path/transpose_nameout.pl $outfile");
system("mv $tmp $outfile");
