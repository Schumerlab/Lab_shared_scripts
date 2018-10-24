#perl! -w

if(@ARGV<2){
    print "perl filter_identical_columns_threshold_transposed.pl transposed_genotypes num_different_markers\n";
}

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open transposed genotypes file\n";

my $thresh=shift(@ARGV); chomp $thresh;

my $outfile="$infile".".identical_filter.txt";
open OUT, ">$outfile";

my $counter=0;
my $firstline=<IN>; chomp $firstline;
my @data_prev=split(/\t/,$firstline);
my $line_prev=$firstline;
my $marker_prev=$data_prev[0]; chomp $marker_prev;
my @info=split(/:/,$marker_prev);
my $group_prev=$info[0]; chomp $group_prev;
#print "$group_prev\n";
while(my $line=<IN>){

    chomp $line;
    my @data=split(/\t/,$line);

    my $marker=$data[0]; chomp $marker;
    my @info=split(/:/,$marker);
    my $group=$info[0]; chomp $group;
#!    print "$group\n";

    $counter=0;
    for my $k (1..scalar(@data)-1){
	my $focal1=$data[$k]; chomp $focal1;
	my $focal2=$data_prev[$k]; $focal2;
	if($focal1 ne $focal2){
	    $counter=$counter+1;
	}#count
    }#compare lines, count

    if(($counter>=$thresh) or ($group ne $group_prev)){
	print OUT "$line_prev\n";
    }#check, preint

#!    print "$counter\n";

    $line_prev=$line;
    @data_prev=@data;

    $group_prev=$group;

}

print OUT "$line_prev\n";
