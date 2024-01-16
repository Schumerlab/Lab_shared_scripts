#perl! -w

#script used by generate_pseudohaploid_calls_from_bams.pl to generate pseudohap file for all vcf files of interest
#see wiki entry: https://openwetware.org/wiki/Schumer_lab:_Commonly_used_workflows#Pseudohaploid_calls_for_GWAS_or_population_structure_analysis_from_low_coverage_data

use Math::Random qw(random_binomial);

if(@ARGV<1){
    print "perl pseudo_haploid_calls_bcftools.pl myvcf.vcf\n"; exit;
}

my $vcf=shift(@ARGV); chomp $vcf;
open IN, $vcf or die "cannot open vcf file\n";

my $outfile="$vcf".".pseudohap.txt";

open OUT, ">$outfile";

while(my $line=<IN>){

    if($line !~ /#/g){
    chomp $line;
    my @elements=split(/\t/,$line);
    my $chr=$elements[0]; chomp $chr;
    my $pos=$elements[1]; chomp $pos;

    my $geno=$elements[9];

    if($geno eq '.'){

	print OUT "$chr\t$pos\tNA\n";

    } else{

        my $info=$elements[7];
        my @split1=split(/DP4=/,$info);
        my $depthcontaining=$split1[1];
        my @split2=split(/;/,$depthcontaining);
        my @dparray=split(/,/,$split2[0]);
#       print "@dparray\n";
        my $a1=$dparray[0]+$dparray[1];
        my $a2=$dparray[2]+$dparray[3];
#       print "$a1\t$a2\n";
        
	if(($a1 > 0) or ($a2 >0)){ 
	$freq1=$a1/($a1+$a2);
        $freq2=$a2/($a1+$a2);
        my $allele=random_binomial(1,1,$freq2);

	print OUT "$chr\t$pos\t$allele\n";
	} else{

	    print OUT "$chr\t$pos\tNA\n";
	}


    } #two orders of operation depending on whether there is data

    }# exclude header

}# all lines
