#perl! -w

use Statistics::Distributions;

# calculates deviations from HWE based on ancestry tsv input

# usage
# perl determine_HWE_filter_markers.pl ancestry-par1 ancestry-par2 bonferonni_pval_thresh

if (@ARGV<4){
	print "\nusage: perl determine_HWE_filter_markers.pl ancestry-par1 ancestry-par2 bonferonni_pval_thresh path_to:transpose_nameout.pl\n\n"; exit;
}

my $infile1 = shift(@ARGV); chomp $infile1;

my $infile2 = shift(@ARGV); chomp $infile2;

my $thresh = shift(@ARGV); chomp $thresh;

my $path = shift(@ARGV); chomp $path;

my $genotype=0;
my $na=NA;
my $trans1="$infile1"."_transposed";
my $trans2="$infile2"."_transposed";

system("perl $path/transpose_nameout.pl $infile1");
system("perl $path/transpose_nameout.pl $infile2");

open IN1, $trans1 or die "cannot open transposed infile1\n";
open IN2, $trans2 or die "cannot open transposed infile2\n";

my $nummark=qx(wc -l $trans1 | perl -p -e 's/ +/\t/g' | cut -f 1); chomp $nummark;
$nummark=$nummark-1;

print "number of markers for fdr correction is $nummark\n";

my $name=$infile1;
$name=~ s/par1//g;
open OUT, ">$name"."_deviating_markers";
print OUT "site\texpected_par1\tobserved_par1\texpected_par2\tobserved_par2\texpected_hets\tobserved_hets\tchi-square\tp-value\n";

my $corrected1="$infile1"."_HWE.tsv";
my $corrected2="$infile2"."_HWE.tsv";

open OUT2, ">$corrected1";
open OUT3, ">$corrected2";

my $firstline1 = <IN1>; #this takes care of the first row which is individual ids
my $firstline2 = <IN2>; #get rid of individual IDs for second file too

chomp $firstline1; chomp $firstline2;

print OUT2 "$firstline1\n"; print OUT3 "$firstline2\n";

my @freqs=();

while ((defined(my $line1 = <IN1>))&&(defined(my $line2 = <IN2>))){

    @freqs=();
    chomp $line1; chomp $line2;
    my @fields1 = split(/\t/, $line1);
    my @fields2 = split(/\t/, $line2);

    my $homo_par1=0; my $homo_par2=0; my $hets=0;
    for my $i (1 .. scalar(@fields1)-1){
	
	if (($fields1[$i] ne 'NA')&&($fields2[$i] ne 'NA')) {

	    if(($fields1[$i]+$fields2[$i])<0.1){$genotype=1};
	    if($fields1[$i] >= 0.9){$genotype=0};
	    if($fields2[$i] >= 0.9){$genotype=2};
	    
	    if($genotype == 2){
		$homo_par1++;
	    } elsif($genotype == 1){
		$hets++;
	    } elsif($genotype == 0){
		$homo_par2++;
	    }#for each genotype value

	    push(@freqs,$genotype);
	}#count genotypes

      } # for all elements of the row

    my $avg_par1="NA"; my $avg_par2="NA"; my $HWE=""; my $exp_homo_par1=""; my $exp_hets=""; my $exp_homo_par2=""; my $chisprob="";
    if (scalar(@freqs)>0){
    $avg_par1= average(@freqs);
    $avg_par2=1-$avg_par1;

    $exp_homo_par1=($avg_par1**2)*scalar(@freqs);
    $exp_homo_par2=($avg_par2**2)*scalar(@freqs);
    $exp_hets=2*$avg_par1*$avg_par2*scalar(@freqs);
    
    if(($exp_homo_par1>0)&&($exp_homo_par2>0)&&($exp_hets>0)){
    $HWE=((($homo_par1-$exp_homo_par1)**2)/$exp_homo_par1)+((($homo_par2-$exp_homo_par2)**2)/$exp_homo_par2)+((($hets-$exp_hets)**2)/$exp_hets);
   
    $chisprob=Statistics::Distributions::chisqrprob (1,$HWE);
   
    if($chisprob*$nummark < $thresh){
	my $marker=$fields1[0];
    print  OUT "$marker\t$exp_homo_par1\t$homo_par1\t$exp_homo_par2\t$homo_par2\t$exp_hets\t$hets\t$HWE\t",$chisprob*$nummark,"\n";
    } else{
	print OUT2 "$line1\n";
	print OUT3 "$line2\n";
    }#print out as a deviating marker or as a retained data marker

    }#calculate chisq statistic
    elsif(($exp_homo_par1 eq 0) or ($exp_homo_par2 eq 0) or ($exp_hets eq 0)){
        print OUT2 "$line1\n";
        print OUT3 "$line2\n";
    }#if the expected counts for any group are zero, retain marker   

    }#if there is data
  
    my $sample_size=scalar(@freqs);

} # while the infile has lines in it

my $tmp1="$corrected1"."_transposed";
my $tmp2="$corrected2"."_transposed";

#transpose again and move to original outfile names
system("perl $path/transpose_nameout.pl $corrected1");
system("perl $path/transpose_nameout.pl $corrected2");

system("mv $tmp1 $corrected1");
system("mv $tmp2 $corrected2");

sub average {
    my @array = @_; # save the array passed to this function
    my $sum; # create a variable to hold the sum of the array's values
    foreach (@array) { $sum += $_; } # add each element of the array 
# to the sum
    return $sum/(2*scalar(@array)); # divide sum by the number of elements in the
# array to find the mean
}


