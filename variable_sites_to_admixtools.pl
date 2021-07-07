#perl! -w
use List::MoreUtils qw(uniq);

#take an infile with sites in rows and individuals in columns, outputs admixtools files

#produce these files with:
#Variable_sites_extractor_mod.py -i -N ScyDAA6-10-HRSCAF-60_align.fa -o ScyDAA6-10-HRSCAF-60_align.var.fa
#Variable_sites_extractor_mod.py -i -N -c ScyDAA6-10-HRSCAF-60_align.fa -o ScyDAA6-10-HRSCAF-60_align.coords

#grep -v '>' ScyDAA6-10-HRSCAF-60_align.var.fa | perl -p -e 's//\t/g' | perl -p -e 's/\t\t/\t/g' > ScyDAA6-10-HRSCAF-60_align.var.reformat.fa
#cat ScyDAA6-10-HRSCAF-60_align.coords | perl -p -e 's/,/\n/g' | grep -v '>' > ScyDAA6-10-HRSCAF-60_align.coords.reformat

#perl /home/groups/schumer/shared_bin/Lab_shared_scripts/transpose_nameout.pl ScyDAA6-10-HRSCAF-60_align.var.reformat.fa

if(@ARGV<2){
    print "perl variable_sites_to_admixtools.pl genos_in snps_in > outfile\n\nSee top of script for details\n"; exit;
}

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open data file\n";

my $snps=shift(@ARGV); chomp $snps;
open SNPS, $snps or die "cannot open snps file\n";

my $out1="$infile".".geno";
my $out2="$infile".".snp";
print "$out1\n$out2\n";
open OUT1, ">$out1" or die;
open OUT2, ">$out2";

my $junk=<IN>;

while((my $line1=<IN>) && (my $line2=<SNPS>)){

    chomp $line1;
    chomp $line2;
    #print "$line1\n";
    my @elements=split(/\t/,$line1);
    
    my @bases=();
    for my $i (0..scalar(@elements)-1){
	push(@bases,$elements[$i]);
    }

    my @uniqbases = uniq @bases;
    my $string="";
    if(scalar(@uniqbases) le 3){

	my $ref="L"; my $counter=0;
	while( $ref =~/[RYSWKML]/){
	    $ref=$uniqbases[$counter]; $counter=$counter+1;
	    #print "ref is $ref\n";
	}

	#print "$ref\n";
	for my $k (0..scalar(@bases)-1){
	
	    my $focal=$bases[$k]; chomp $focal;
	    #print "$focal\n";
	    if($focal eq $ref){ $string="$string"."0";}
	    if(($focal ne $ref) && ($focal =~ /[ATGC]/)){ $string="$string"."2";}
	    if(($focal ne $ref) && ($focal =~/[RYSWKM]/)){ $string="$string"."1";}
	}
	print OUT1 "$string\n";
	print OUT2 "chr1:"."$line2\t"."chr1\t"."0.0\t$line2\t$bases[0]\t$bases[1]\n";
	#print "$string\n";
	$string="";

    }

}#for all sites 

