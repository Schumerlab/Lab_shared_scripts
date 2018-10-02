#!perl 

# usage 
# perl getScaffold_samtools.pl reffile scaffold >outfile
# perl getScaffold_samtools.pl sec_genome/dsec-all-chromosome-r1.3.fasta scaffold_0 >scaffold_0_ref.fa

# if $scaffold = all, all of the contigs are printed out
# _samtools version prints out 50bp per line, to keep samtools froom choking

if (@ARGV < 2){
	print "\nusage: perl getScaffold_samtools.pl reffile scaffold >outfile\n\n";
	exit;
}

my $reffile = shift(@ARGV); chomp $reffile;
open REF, $reffile or die "wrong format for infile\n";

my $scaffold = shift(@ARGV); chomp $scaffold;

my %data = ();
my @sequence_names = ();
my @sequence_temp =();  
my @data_temp =();	# needed to read in nexus files

#**************** read in sequence & create output sequence
	while (my $line = <REF>) {
		chomp $line;
		#$line =~ s/\s+//g; # remove all white spaces
		#$line =~ s/type/\ttype/g; # insert a tab
		if ($line =~ />/) 
			{
			(my $name, my $other) = split(/\t/, $line); chomp $name;
			push(@sequence_names, $name);
			$sequence_temporary = join ("", @data_temp);
			push(@sequence_temp,$sequence_temporary); 
			@data_temp=();
			} 
		else {push(@data_temp, $line);}
		}
	close REF;
	$sequence_temporary = join ("", @data_temp);
	push(@sequence_temp,$sequence_temporary); 
	for $x (0..(scalar(@sequence_names)-1))	# put sequences into @data
		{
		#$sequence_temp[$x+1]=~s/^N+//; # remove leading Ns
		#$sequence_temp[$x+1]=~s/N+$//; # remove trailing Ns
		$data{$sequence_names[$x]}=$sequence_temp[$x+1];
		}

my $seq_count = scalar (keys (%data));

# print "searching for: >$scaffold\n";

# foreach $key (keys (%data)){
foreach $key (sort {lc($a) cmp lc($b)} keys(%data)){
if ($scaffold eq "all") {
	print "$key\n";
	for ($i=0; $i<length($data{$key}); $i+=50){
		print substr($data{$key}, $i, 50), "\n";
		}
	}
elsif (substr($key,0) =~ /\b$scaffold\b/) {
	print "$key\n";
	for ($i=0; $i<length($data{$key}); $i+=50){
		print substr($data{$key}, $i, 50), "\n";
		}
	}
}




