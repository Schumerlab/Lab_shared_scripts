#perl! -w

if(@ARGV<1){
    print "perl gatk_vcf_to_masked_insnp.pl gatk.g.vcf\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open vcf infile\n";

my $outfile="$infile".".mask.insnp";
open OUT, ">$outfile";

while(my $line =<IN>){

    chomp $line;
    if($line !~ '#'){

	my @elements=split(/\t/,$line);
	my $group=$elements[0]; chomp $group;
	my $site=$elements[1]; chomp $site;
	my $ref=$elements[3]; chomp $ref;

	print OUT "$group\t$site\t$ref\tN\n";

    }#non-header line

}#for all lines
