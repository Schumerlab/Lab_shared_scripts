#!perl

# generates an ancestry file from two .tsv files 
# usage
# perl parsetsv_ancestry.pl infilepar1 infilepar2 > outfile

if (@ARGV<2){
	print "\nusage: perl parsetsv_ancestry.pl infilepar1 infilepar2 > outfile\n\n"; exit;
}

my $infile = shift(@ARGV); chomp $infile;
open IN, $infile or die "wrong format for in1 infile\n";

my $infile2=shift(@ARGV); chomp $infile2;
open IN2, $infile2 or die "wrong format for in2 infile\n";

my $na="NA";
my $malcount=0;
my $bircount=0;
my $ancestry=0;
my $hets=0;
my $counter=0;
my $prop_hets=0;
my $genotype="";
print "\tmalcount\tbircount\thybrid_index\theterzygosity\n";

my $junk1=<IN>; chomp $junk1;
my $junk2=<IN2>; chomp $junk2;

while ((my $line=<IN>) && (my $line2=<IN2>)){
    chomp $line; chomp $line2;

    $line=~ s/NA/0.33/g;
    $line2=~ s/NA/0.33/g;

    my @fields1 = split(/\t/, $line); #birchmanni gempty[es
    my @fields2=split(/\t/,$line2); #malinche genotypes
    

    for my $i (1 .. scalar(@fields1)-1){
	if (($fields1[$i]>=0.95) & ($fields2[$i]<=0.05)){$bircount++; $counter++;}
	elsif (($fields2[$i]>=0.95) & ($fields1[$i]<=0.05)){$malcount++; $counter++;}
	elsif ($fields1[$i]+$fields2[$i] <=0.1 ){$bircount=$bircount+.5;$malcount=$malcount+.5; $hets=$hets+1; $counter++;}   
    #}
	else{$genotype="NA";}
      } # for all elements of the row
    #print OUT "\n";

    if (($malcount ne 0) or ($bircount ne 0)){
    $ancestry= $malcount/($malcount+$bircount);
    #calculate hybrid index
    }
    else {$ancestry="NA"}
    #if it is 100% bir or mal or all markers are missing

    if($counter>0){
	$prop_hets=$hets/$counter;
    }#there are counts
    else{
	$prop_hets="NA";
    }

    print "$fields1[0]\t$malcount\t$bircount\t$ancestry\t$prop_hets\n";
    $malcount=0; $bircount=0; $hets=0; $counter=0;
} # while the infile has lines in it

