#!perl

# generates an average ancestry file from two transposed .tsv files 
# usage
# perl calculate_avg_ancestry_v5.pl infilepar1 infilepar2 num_ind_thresh posterior_prob_thresh path_to:transpose_nameout.pl > outfile

if (@ARGV<5){
	print "\nusage: perl parsetsv_ancestry.pl infilepar1 infilepar2 num_ind_thresh posterior_prob_thresh path_to:transpose_nameout.pl > outfile\n\n"; exit;
}

my $infile = shift(@ARGV); chomp $infile;
my $infile2=shift(@ARGV); chomp $infile2;

my $num_indivs_thresh=shift(@ARGV); chomp $num_indivs_thresh;

my $ppthresh1=shift(@ARGV); chomp $ppthresh1;
my $ppthresh2=1-$ppthresh1;

my $path=shift(@ARGV); chomp $path;

system("perl $path/transpose_nameout.pl $infile");
system("perl $path/transpose_nameout.pl $infile2");

my $trans1="$infile"."_transposed";
my $trans2="$infile2"."_transposed";
open IN, $trans1 or die "can't open ancestry tsv par1 infile\n";
open IN2, $trans2 or die "can't open ancestry tsv par2 infile\n";

my $malcount=0;
my $bircount=0;
my $ancestry=0;
my $total=0;
print "group\tposition\tmalcount\tbircount\thybrid_index\tindivs_cov\n";

my $junk1=<IN>; chomp $junk1;
my $junk2=<IN2>; chomp $junk2;

while ((my $line = <IN>) && (my $line2=<IN2>)){
    chomp $line; chomp $line2;
    my @fields1 = split(/\t/, $line); #birchmanni gempty[es
    my @fields2=split(/\t/,$line2); #malinche genotypes
    

    for my $i (1 .. scalar(@fields1)-1){
	if(($fields1[$i]) =~ 'NA'){
	    #ignore this marker
	} else{
	if (($fields1[$i]>=$ppthresh1) && ($fields2[$i]<=$ppthresh2)){$bircount++; $total++;}
	elsif (($fields2[$i]>=$ppthresh1) && ($fields1[$i]<=$ppthresh2)){$malcount++; $total++;}
	elsif ($fields1[$i]+$fields2[$i] <= $ppthresh2 ){$bircount=$bircount+.5;$malcount=$malcount+.5; $total++;}   
	else{$genotype="NA";}
	}
      } # for all elements of the row
    print OUT "\n";

    if ($total >= $num_indivs_thresh){
    $ancestry= $malcount/($malcount+$bircount);
    #calculate hybrid index
    }
    else {$ancestry="NA"}
    #if it is 100% bir or mal or all markers are missing

    my $marker=$fields1[0];
    $marker=~ s/:/\t/g;
    print "$marker\t$malcount\t$bircount\t$ancestry\t$total\n";
    #!print "$fields1[0]\t$malcount\t$bircount\t$ancestry\t$total\n";
    $malcount=0; $bircount=0; $total=0; $ancestry=0;
} # while the infile has lines in it

