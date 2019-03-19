#perl! -w

if(@ARGV<3){
    print "perl filter_identical_columns_threshold_transposed.pl genotypes num_different_markers path_to:transpose_nameout.pl\n"; exit;
}

my $infile=shift(@ARGV); chomp $infile;

my $thresh=shift(@ARGV); chomp $thresh;

my $path=shift(@ARGV); chomp $path;
system("perl $path/transpose_nameout.pl $infile");

my $trans_in="$infile"."_transposed";
open IN, $trans_in or die "cannot open transposed infile\n";

my $outfile="tmp"."$infile".".identical_filter.txt";
open OUT, ">$outfile";

my $outfile_final="$infile".".identical_filter.txt";

my $counter=0;
my $firstline=<IN>; chomp $firstline;
my @data_prev=split(/\t/,$firstline);
my $line_prev=$firstline;
my $marker_prev=$data_prev[0]; chomp $marker_prev;
my @info=split(/:/,$marker_prev);
my $group_prev=$info[0]; chomp $group_prev;
my $group=$group_prev;
#print "$group_prev\n";
while(my $line=<IN>){

    chomp $line;
    my @data=split(/\t/,$line);

    my $marker=$data[0]; chomp $marker;
    my @info=split(/:/,$marker);
    $group=$info[0]; chomp $group;
#!    print "$group\n";

    $counter=0;
    for my $k (1..scalar(@data)-1){
	my $focal1=$data[$k]; chomp $focal1;
	my $focal2=$data_prev[$k]; $focal2;
	if(($focal1 ne $focal2)&&($focal2 ne 'NA')){
	    $counter=$counter+1;
	}#count
    }#compare lines, count

    if(($counter>=$thresh) or ($group ne $group_prev)){
	print OUT "$line_prev\n";
	#print "$group\n";
    }#check, print

#!    print "$counter\n";

    if(($counter>=$thresh) or ($group ne $group_prev)){
    $line_prev=$line;
    @data_prev=@data;
    }#check, reset 

    $group_prev=$group;

}

print OUT "$line_prev\n";

system("perl $path/transpose_nameout.pl $outfile");
my $tmp="$outfile"."_transposed";
system("mv $tmp $outfile_final");
