#perl! -w

##NOTE: Assumes fastahack is globally available. If it is not export the path, edit path in script or link to fastahack

if(@ARGV<3){
    print "perl extract_bed_seqs.pl list_of_seqs.bed fasta_to_extract outfile_tag_name\n"; exit;
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
    my $start=$elements[1]; chomp $start;
    my $stop=$elements[2]; chomp $stop;
    
    if($elements[6] eq '+'){
#	$start=$start+$adjust;
    } else{
#	$stop=$stop-$adjust;
    }

    print "$group\t$start\t$stop\n";

    my $name="$list"."_"."$tag".".fa";

    if($counter ==1){
	open OUT, ">$name";
	#print OUT ">"."$list"."_"."$tag"."\n";
    }

    my $seq=qx(fastahack $fasta -r $group:$start..$stop); chomp $seq;

    
    if($elements[6] eq '-'){

	 $seq = reverse_complement_IUPAC($seq);
	    #print "$revcomp\n";
    }
    
    print OUT ">"."$group"."_"."$start"."_"."$stop\n";
    print OUT "$seq\n";
    
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
