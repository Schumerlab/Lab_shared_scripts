#perl! -w

if(@ARGV<2){
    print "perl print_alleles_depth_freq_chi_per_site_GWAS.pl infile.legacy.vcf low_dp_thresh\n"; exit;
}
my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile.legacy.vcf\n";

my $dp_thresh=shift(@ARGV); chomp $dp_thresh;

print "group\tpos\tref_allele\talt_allele\tdepth\tAF-group1\tAF-group2\tLR1\tpchi\n";

while(my $line = <IN>){
    chomp $line;
    
    my @elements=split(/\t/,$line);
    if($line !~ /\#/g){
	
	my $group=$elements[0]; chomp $group;
	my $positions=$elements[1]; chomp $positions;
	my $ref=$elements[3]; chomp $ref;
	my $alt=$elements[4]; chomp $alt;
	
	my $info=$elements[7]; chomp $info;
	my @snpinfo=split(/;/,$info);

	if(length($ref)==1 && length($alt)==1 && $ref ne 'N'){
	    my $dp=""; my $af1=""; my $ltr=""; my $pchi=""; my $ltr2="";
	for my $i (0..scalar(@snpinfo)-1){
	    my $focal=$snpinfo[$i]; chomp $focal;
	    if($focal =~ /DP=/g){
		my @depth=split(/=/,$focal);
		$dp=$depth[1]; chomp $dp;
	    }#depth entry
	    if($focal =~ /AF1=/g){
		my @afreq=split(/=/,$focal);
		$af1=$afreq[1]; chomp $af1;
	    }#AF entry
	    if($focal =~ /LRT=/g){
		my @likelihood=split(/=/,$focal);
		$ltr=$likelihood[1];chomp $ltr;
            }#LTR entry
	    if($focal =~ /LRT2=/g){
                my @likelihood2=split(/=/,$focal);
                $ltr2=$likelihood2[1];chomp $ltr2;
            }#LTR2 entry  
	    if($focal =~ /PCHI2=/g){
		my @prob=split(/=/,$focal);
                $pchi=$prob[1];chomp $pchi;
            }#pchi entry  

	}#for all info elements
	    if($dp >= $dp_thresh){
	print "$group\t$positions\t$ref\t$alt\t$dp\t$af1\t$ltr\t$ltr2\t$pchi\n";
	    }
	}#for eligible SNPs
    }#non-header line

}#for all lines in vcf
