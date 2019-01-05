#perl! -w

use Math::Random qw(random_binomial);

#takes a bcftools generated vcf (written for 1.8.8) and generates a ped file

if(@ARGV<3){
    print "perl random_flip_samtools_vcf_for_PCA.pl infile.vcf name pheno\n";
}

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile\n";

my $name=shift(@ARGV); chomp $name;

my $pheno=shift(@ARGV); chomp $pheno;

my $snps="$infile".".ped";
open SNPS,">$snps";

my $map="$infile".".map";
open MAP, ">$map";

print SNPS "$name 1 0 0 -9"." "."$pheno"." ";

my $counter=0;
while (my $line = <IN>){
    chomp $line;

    if(($line !~ /INDEL/g) && ($line !~ /#/)){

    my @elements=split(/\t/,$line);
    my $group=$elements[0];
    my $pos=$elements[1];
    my $ref=$elements[3];
    my $alt=$elements[4];

    $counter++;
    my $snpid="$group"."_"."$pos";

    print MAP "$group\t$snpid\t0\t$pos\n";

    if($line =~ '1/1'){
	print SNPS "$alt $alt ";
    } elsif($line =~ '0/1'){
	my $info=$elements[7];
	my @split1=split(/DP4=/,$info);
	my $depthcontaining=$split1[1];
	my @split2=split(/;/,$depthcontaining);
	my @dparray=split(/,/,$split2[0]);
#	print "@dparray\n";
	my $a1=$dparray[0]+$dparray[1];
	my $a2=$dparray[2]+$dparray[3];
#	print "$a1\t$a2\n";
	
	$freq2=$a2/($a1+$a2);
	my $allele=random_binomial(1,1,$freq2);
#	print "$allele\n";
	if($allele eq 1){
	    print SNPS "$ref $ref ";
	}#reference
	if($allele eq 0){
	    print SNPS "$alt $alt ";
	}#alternate

 } else{

     print SNPS "$ref $ref ";

    }#otherwise do this for invariant sites

    }#Not an indel line

}#for all lines
