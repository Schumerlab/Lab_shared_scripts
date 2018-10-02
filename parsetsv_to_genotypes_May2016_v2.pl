#!perl

# generates an <in.snp> file for seqtk based on min coverage from pi\

# usage
# perl parsetsv.pl infile

if (@ARGV<1){
	print "\nusage: perl create_insnp.pl pileup\n\n"; exit;
}

my $infile = shift(@ARGV); chomp $infile;
open IN, $infile or die "wrong format for in1 infile\n";
my $infile2=shift(@ARGV); chomp $infile2;
open IN2, $infile2 or die "wrong format for in2 infile\n";
my $genotype=0;
my $na=NA;

open IN, "$infile";
open IN2,"$infile2";
open OUT, ">genotypes.txt";

my $firstline = <IN>; chomp $firstline;                   #this takes care of the first row
my $junk=<IN2>; chomp $junk;
print OUT "id$firstline\n";
while ((my $line = <IN>) && (my $line2=<IN2>)){
    chomp $line; chomp $line2;
    my @fields1 = split(/\t/, $line);
    my $genotype = "";
    my @fields2=split(/\t/,$line2);
    #my $genotype2="";
   # print "@fields2\n";
    print OUT "$fields1[0]\t";
   # print "$fields1[3]\t$fields2[3]\n";
    for my $i (1 .. scalar(@fields1)-1){
	#print scalar(@fields1),"\n";
	if(($fields1[$i] ne 'NA')&&($fields2[$i] ne 'NA')){
	if (($fields1[$i]>=0.95)) {$genotype=0;}
	elsif (($fields2[$i] + $fields1[$i])<=0.1){$genotype=1;}
	elsif (($fields2[$i]>=0.95)){$genotype=2;}   
	else{$genotype="NA";}

	} else{
	    $genotype="NA";
	}# if either of the genotypes are NA

# need to figure out what to do with heterozygotes
	if($i != (scalar(@fields1)-1)){
	print OUT "$genotype\t";
	} else{
	    print OUT "$genotype\n";
	}#last line in row
	#print "$i\n";
      } # for all elements of the row
  
} # while the infile has lines in it

#trying to modify to take both tsv files
