#perl! -w

if(@ARGV<1){
    print "perl count_IUPAC_poly_single_genome.pl fasta_file\n"; exit;
}

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open fasta file\n";

my $poly=0; my $background=0;

while (my $line=<IN>){

    chomp $line;
    if($line !~ />/){
	my @elements=split(//,$line);
	
	for my $j (0..scalar(@elements)-1){

	    my $focal=$elements[$j]; chomp $focal;

	    if($focal ne 'N'){
		$background=$background+1;
	    }#count backgroun
	    if($focal =~/[RYSWKM]/){
		$poly=$poly+1;
	    }#IUPAC poly base biallelic
	}#for all sites in line

    }#not header, count
    
}#for all lines
print "polymorphisms\ttotal_non_missing\n";
print "$poly\t$background\n";
