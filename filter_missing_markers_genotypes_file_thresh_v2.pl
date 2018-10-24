#perl! -w

if(@ARGV<3){
    print "perl filter_missing_markers_thresh.pl infile_genotypes path_to:transpose_nameout.pl prop_missing_allowed\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;

my $path=shift(@ARGV); chomp $path;
system("perl $path/transpose_nameout.pl $infile");
my $trans_in="$infile"."_transposed";
open IN, $trans_in or die "cannot open transposed infile\n";

my $thresh=shift(@ARGV); chomp $thresh;

my $header=<IN>; #store header 
chomp $header;

my $outfile="$infile"."_filtered_at_"."$thresh";
open OUT, ">$outfile";

print OUT "$header\n";

while(my $line=<IN>){

    chomp $line;
    my @elements=split(/\t/,$line);

    my $missing_counter=0; my $total_counter=0;
    for my $j (1..(scalar(@elements)-1)){
	$total_counter++;
	my $focal=$elements[$j]; chomp $focal;
	    if(($focal eq '-9') or ($focal eq 'NA')){
		$missing_counter++;
	}#count missing
    }#for all elements in the line minus the label

	my $ratio=1;
	if($total_counter>0){
	    $ratio=$missing_counter/$total_counter;
	}#proportion missing
       
	if($ratio le $thresh){
	    print OUT "$line\n";
	}#this is a valid marker

    }#run through lines

#write out list of markers
my $outfile_markers="$outfile"."_marker_list";

system("cut -f 1 $outfile | tail -n +2 > $outfile_markers");

system("perl $path/transpose_nameout.pl $outfile");
my $new_name="$outfile"."_transposed";
system("mv $new_name $outfile");
