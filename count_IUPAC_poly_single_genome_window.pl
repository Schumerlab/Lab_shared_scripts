#perl! -w

if(@ARGV<2){
    print "perl count_IUPAC_poly_single_genome.pl fasta_file window_size_inbp\n";
}

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open fasta file\n";

my $window_size=shift(@ARGV); chomp $window_size;
if(length($window_size) == 0){ print "window size in bp required\n"; die;}

my $poly=0; my $background=0; my $counter=0; my $group="";
my $start=1; my $firstline=1;
while (my $line=<IN>){

    chomp $line;
    if($line !~ />/){
	my @elements=split(//,$line);
	
	for my $j (0..scalar(@elements)-1){
	    $counter++;

	    my $focal=$elements[$j]; chomp $focal;
	    if($focal ne 'N'){
		$background=$background+1;
	    }#count backgroun
	    if($focal =~/[RYSWKM]/){
		$poly=$poly+1;
		#print "$poly\n";
	    }#IUPAC poly base biallelic

	    if($counter>=$window_size){
		print "$group\t$start\t",$start+$window_size,"\t$poly\t$background\n";
		$start=$start+$window_size;
		$poly=0;
		$background=0;
		$counter=0;
	    }#if hit window limit

	}#for all sites in line

    }#not header, count
    if(($line =~ />/)&&($firstline != 1)){
	print "$group\t$start\t",$start+$window_size,"\t$poly\t$background\n";
	$poly=0; $background=0; $counter=0;
	$group=$line;
	$group=~ s/>//g;
	$start=1;
    }#reset group, reset counter
    if(($line =~ />/)&&($firstline == 1)){
	$group=$line;
        $group=~ s/>//g;
	$firstline=0;
	$start=1;
    }#set group
}#for all lines

print "$group\t$start\t",$start+$window_size,"\t$poly\t$background\n";
#print "polymorphisms\ttotal_non_missing\n";
#print "$poly\t$background\n";
