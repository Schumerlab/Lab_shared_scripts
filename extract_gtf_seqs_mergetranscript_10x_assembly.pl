#perl! -w

#NOTE: depends on fastahack- path hard coded below

if(@ARGV<3){
    print "perl extract_gtf_seqs_mergetranscript_10x_assembly.pl list_of_exons.gtf fasta_file outfile_tag\n"; exit;
}

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list file\n";

my $fasta=shift(@ARGV); chomp $fasta;

my $tag=shift(@ARGV); chomp $tag;

my $counter=0; my $strand=""; my $seq="";

open OUT, ">"."$list"."_"."$tag";
while(my $line = <IN>){

    $counter++;
    chomp $line;
    my @elements=split(/\t/,$line);
    my $group=$elements[0]; chomp $group;
    my $start=$elements[3]; chomp $start;
    my $stop=$elements[4]; chomp $stop;
    my $adjust=$elements[7]; chomp $adjust;
    
    if($elements[6] eq '+'){
	#$start=$start+$adjust;
	$strand="+";
    } else{
	#$stop=$stop-$adjust;
	$strand="-";
    }

#    print "$group\t$start\t$stop\n";
    
    if($counter eq 1){
	print OUT ">"."$list"."_"."$tag"."\n";
    }

    my $curr_seq=qx(/home/groups/schumer/shared_bin/fastahack $fasta -r $group:$start..$stop); chomp $curr_seq;

    $seq="$seq"."$curr_seq";
    
}


if($strand eq '-'){

    $seq = reverse_complement_IUPAC($seq);
            #print "$revcomp\n";                                                                                            
}

print OUT "$seq";
print OUT "\n";


sub reverse_complement_IUPAC {
    my $dna = shift;

        # reverse the DNA sequence
    my $revcomp = reverse($dna);

        # complement the reversed DNA sequence
    $revcomp =~ tr/ABCDGHMNRSTUVWXYabcdghmnrstuvwxy/TVGHCDKNYSAABWXRtvghcdknysaabwxr/;
    return $revcomp;
}
