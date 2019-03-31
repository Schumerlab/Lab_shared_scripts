#perl! -w

if(@ARGV<3){
    print "perl extract_gtf_seqs_mergetranscript.pl gene_of_interest.gtf fasta outfile_tag\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list file\n";

my $fasta=shift(@ARGV); chomp $fasta;

my $tag=shift(@ARGV); chomp $tag;

my $counter=0;
while(my $line = <IN>){

    $counter++;
    chomp $line;
    my @elements=split(/\t/,$line);
    my $group=$elements[0]; chomp $group;
    my $start=$elements[3]; chomp $start;
    my $stop=$elements[4]; chomp $stop;
    my $adjust=$elements[7]; chomp $adjust;
    
    if($elements[6] eq '+'){
#	$start=$start+$adjust;
    } else{
#	$stop=$stop-$adjust;
    }

    print "$group\t$start\t$stop\n";

    my $name="$list"."_"."$tag".".fa";

    if($counter ==1){
	open OUT, ">$name";
	print OUT ">"."$list"."_"."$tag"."\n";
    }

    my $seq=qx(/home/groups/schumer/shared_bin/fastahack $fasta -r $group:$start..$stop); chomp $seq;

    
    if($elements[6] eq '-'){

	 $seq = reverse_complement_IUPAC($seq);
	    #print "$revcomp\n";
    }

    print OUT "$seq";
    
}

print OUT "\n";


sub reverse_complement_IUPAC {
    my $dna = shift;

        # reverse the DNA sequence
    my $revcomp = reverse($dna);

        # complement the reversed DNA sequence
    $revcomp =~ tr/ABCDGHMNRSTUVWXYabcdghmnrstuvwxy/TVGHCDKNYSAABWXRtvghcdknysaabwxr/;
    return $revcomp;
}
