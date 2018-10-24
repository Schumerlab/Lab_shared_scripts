#perl! -w

if(@ARGV<2){
    print "perl remove_record_list_from_fasta.pl list_of_sequences_to_remove fasta_file\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list of sequences to remove\n";

my $fasta=shift(@ARGV); chomp $fasta;
open IN2, $fasta or die "cannot open fasta file\n";

my $out="$fasta".".filtered";

open OUT, ">$out";

my @remove=();
while(my $line=<IN>){
    chomp $line;
    push(@remove, $line);
}

my $print=1;
while(my $line2=<IN2>){
    chomp $line2;

    if($line2 =~ />/){
	my $tmp=$line2;
	$tmp=~ s/>//g;

	if($tmp =~ /gi/){
	my @names=split(/\|/,$tmp);
#	print "@names\n";
	$tmp=$names[3]; chomp $tmp;
	}

	if($tmp ~~ @remove){
	    $print=0;
	    print "removing $tmp\n";
	}
	else{
	    $print=1;
	    print "keeping $tmp\n";
	}

    }
    if($print==1){
	print OUT "$line2\n";
    }


}
