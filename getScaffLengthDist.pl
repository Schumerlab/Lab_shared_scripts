#!perl 

# optionally prints contigs >= $min_contig_size

# usage 
# perl getScaffLengthDist.pl $fastafile $min_contig_size $print_contigs?(0/1)

# determines the distribution of scaffold lengths from a list of scaffolds in fasta format
# calculates the number of scaffolds, the total assembly length, N50 
# and the number of contigs >= $min_contig_size
# dumps un-sorted distribution of contig sizes to "contig_sizes"

if (@ARGV < 1){print "\nusage: getScaffLengthDist.pl $fastafile $min_contig_size $print_contigs?(0/1) \n\n";exit;}

my $fastafile = shift(@ARGV); chomp $reffile;
my $min_contig_size= shift(@ARGV); chomp $min_contig_size;

my $print_contigs = shift(@ARGV); chomp $print_contigs;

open REF, $fastafile or die "wrong format for infile\n";
open OUT, ">contig_sizes.xls";

my $scaffold = shift(@ARGV); chomp $scaffold;

my @sequences = ();
my @data_temp =();	# needed to read in nexus files
my @sequence_names = ();
my %contigs = ();
my $grand_total = 0; my $num_contigs = 0;
my $size = 0;

#**************** read in sequence & create output sequence
	while (my $line = <REF>) {
		chomp $line;
		$line =~ s/\s+/\t/g; # replace all white spaces with a tab
		if ($line =~ />/) {
			(my $name, my $other) = split(/\t/, $line); chomp $name;
			push(@sequence_names, $name);
			$sequence_temporary = join ("", @data_temp);
			push(@sequences, $sequence_temporary); 
			@data_temp=();
			}
		else {push(@data_temp, $line);}
		}

	close REF;
	$sequence_temporary = join ("", @data_temp);
	push(@sequences, $sequence_temporary); 


for $x (0..(scalar(@sequence_names)-1))	{ # put sequence names and sizes into a hash
	my $noNs = $sequences[$x+1];
	#$noNs =~ s/N//g;
	$size = length($noNs);
	$contigs{$sequence_names[$x]}=$size;
	
	# print "$sequence_names[$x]\t$size\n";
	
	if ($print_contigs==1){
		if ($size>=$min_contig_size){
			open OUT2, ">>contigs_min$min_contig_size";
			print OUT2 "$sequence_names[$x]\n$sequences[$x+1]\n";
			}
		}
	
	$grand_total += $size;
	$num_contigs++;
}


print "\nnumber of scaffolds loaded: $num_contigs\n";
print "total length of scaffolds: $grand_total\n";

my $counter = 0; my $cum_total =0;my $N50=0;

foreach $key (sort hashValueDescendingNum (keys(%contigs))){
	print OUT "$key\t$contigs{$key}\n";	
	if ($contigs{$key}>=$min_contig_size){$counter++}
	$cum_total = $cum_total+$contigs{$key};
	if ($cum_total<=(0.5*$grand_total)){$N50 = $contigs{$key};}
	}
print "N50 for this assembly: $N50\n";
print "# scaffolds >= $min_contig_size: $counter\n\n";



sub hashValueDescendingNum {
	$contigs{$b} <=> $contigs{$a};
}

