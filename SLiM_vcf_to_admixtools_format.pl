#perl! -w

if(@ARGV<1){
    print "perl SLiM_vcf_to_insnp_format.pl SLiM.vcf\n";
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open $infile\n";

my $outfilesnp="$infile".".snp";
open OUTSNP, ">$outfilesnp";

my $outfilegeno="$infile".".geno";
open OUTGENO, ">$outfilegeno";

my $outfileind="$infile".".ind";
open OUTIND, ">$outfileind";

my $snpcounter=0;
while(my $line=<IN>){

    if($line !~ /#/){

	chomp $line;
	my @elements=split(/\t/,$line);

	my $group=$elements[0]; chomp $group;
	my $pos=$elements[1]; chomp $pos;
	my $ref=$elements[3]; chomp $ref;
	my $alt=$elements[4]; chomp $alt;

	my $chars=length($alt); 
	if($chars>1){
	    
	}#illegal base for admixtools
	else{
	    $snpcounter++;
	    print OUTSNP "chr"."$group".":"."$pos"."\t"."chr"."$group"."\t0\t$pos\t$ref\t$alt\n";

	    my $total=scalar(@elements)-1;

	    if($snpcounter eq 1){
		print "processing data from ",$total-8," indivs\n";
		print "output files are: "."$outfilesnp\t$outfilegeno\t$outfileind\n";
		for my $m (9..$total){
		    print OUTIND "indiv",$m-8,"\tU\n";
		}#all indivs
	    }#first SNP, generate inds file

	    for my $j (9..$total){

		my $focal=$elements[$j]; #print "$focal\n";

		if(($focal eq '0|1') or ($focal eq '1|0')){
		    print OUTGENO "1";
		}#hets
		if($focal eq '0|0'){
		    print OUTGENO "0";
		}#homo ref
		if($focal eq '1|1'){
		    print OUTGENO "2";
		}#homo alt

	    }#process all individuals in the file

	    print OUTGENO "\n";

	}#single substitution
    }#non-header line


}#for all vcf lines
