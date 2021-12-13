#perl! -w

my $phy=shift(@ARGV); chomp $phy;
open IN, $phy or die "cannot open phy file\n";

my $outfile1="$phy".".ped";
open OUT1, ">$outfile1";

my $genotype=0;
my $idcounter=0;
while(my $line=<IN>){

    chomp $line;
    $line =~ s/ +/\t/g;

    if($line =~  /[GATC]/){

	$idcounter++;
	
	my @raw_data=split(/\t/,$line);
	my $sequence=$raw_data[1]; chomp $sequence;
#	print "$sequence\n";

	(my $id, my $chr)=split(/_/,$raw_data[0]); chomp $id; chomp $chr;
#	print "$id\t$chr\n";

	my @basepairs=split(//,$sequence);

	    print OUT1 "FAM001\t$id\t0\t0\t1\t-9\t";

	#HERE, PROCESS SEQUENCE
	my $counter=0;
	for my $i (0..scalar(@basepairs)-1){
	    $counter=$counter+1;
	    
	    my $focal=$basepairs[$i]; chomp $focal;

	    if($focal =~/[GATC]/){
		
		print OUT1 "$focal $focal\t";
	    }#if ATGC
	    elsif($focal eq 'N'){
		print OUT1 "0 0\t";
	    }#if N
	    elsif($focal =~/[RYSWKM]/){
		
		if($focal eq 'R'){
		    print OUT1 "A G\t";
		}
		if($focal eq 'Y'){
		    print OUT1 "C T\t";
		}
		if($focal eq 'S'){
		    print OUT1 "C G\t";
		}
		if($focal eq 'W'){
		    print OUT1 "A T\t";
		}
		if($focal eq 'K'){
		    print OUT1 "G T\t";
		}
		if($focal eq 'M'){
		    print OUT1 "A C\t";
		}

	    }else{

		print "$focal\tERROR no matched basepair\n";

	    }#if not any WARN


	}#for all basepairs


	print OUT1 "\n";

    }#this is a data line


}#for all entries in the phy file
