#perl! -w

my $infile=shift(@ARGV); chomp $infile;

my $transposed="$infile"."_transposed";

system("perl /home/groups/schumer/shared_bin/Lab_shared_scripts/transpose_nameout.pl $infile");

open IN, $transposed or die "cannot open transposed infile\n";

my $outfile="$infile"."_counts";

open OUT, ">$outfile";

my $junk=<IN>;

while(my $line=<IN>){

    chomp $line;

    my @elements=split(/\t/,$line);
    my $bir=0; my $mal=0; my $het=0; my $marker=$elements[0]; my $total=0;
    for my $i (1..scalar(@elements)-1){
	my $focal=$elements[$i]; chomp $focal;
	if($focal ne 'NA'){
	    $total++;
	    if($focal eq 0){$bir++}
	    if($focal eq 1){$het++}
	    if($focal eq 2){$mal++}
	}

#	print OUT "$marker\t$bir\t$het\t$mal\t$total\n";

    }

    print OUT "$marker\t$bir\t$het\t$mal\t$total\n";
}
