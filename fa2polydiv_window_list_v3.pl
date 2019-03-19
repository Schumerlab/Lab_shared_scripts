#!perl 

# calculates divergence and residual polymorphism in windows for a list of scaffolds using two fastas 

use POSIX;

if (@ARGV < 4){
	print "\nusage: perl fa2poly_window.pl infile1.fa infile2.fa scaffold_list windowsize\n\n";
	exit;
}

my $infile1 = shift(@ARGV); chomp $infile1;
my $infile2 = shift(@ARGV); chomp $infile2;

system(qq{perl -p -i -e "s/\<unknowndescription\>//g" $infile1});
system(qq{perl -p -i -e "s/\<unknowndescription\>//g" $infile2});

system("cp $infile1 $infile1.temp");
system("cp $infile2 $infile2.temp");
system(qq{perl -p -i -e "s/\>/\>seq1_/g" $infile1.temp});
system(qq{perl -p -i -e "s/\>/\>seq2_/g" $infile2.temp});
system("cat $infile1.temp $infile2.temp >infile.temp");
system("rm $infile1.temp");
system("rm $infile2.temp");
open REF, "infile.temp" or die "wrong format for infile.fa\n";

my $scaffold_list = shift(@ARGV); chomp $scaffold_list;
open IN, "cut -f 1 $scaffold_list |";

my $windowsize =  shift(@ARGV); chomp $windowsize;


my %data = ();
my @sequence_names = ();
my @sequence_temp =();  
my @data_temp =();	# needed to read in nexus files

#**************** read in sequence & create output sequence
	while (my $line = <REF>) {
		chomp $line;
		$line =~ s/\s+//g; # remove all white spaces
		$line =~ s/type/\ttype/g; # insert a tab
		if ($line =~ />/) {
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
		$data{$sequence_names[$x]}=$sequence_temp[$x+1];
		}

my $seq_count = scalar (keys (%data));
print "# of sequences loaded: $seq_count\n";

system("rm infile.temp");



while (my $scaffold = <IN>) {
	chomp $scaffold;
	open OUT, ">scaffold_".$scaffold."_polydiv";
#!	print OUT "scaffold\tmidpoint\tpoly1\tpoly2\tdxy\tdiv\tnum_sites\n";
	
# read scaffold into an array ############################################################################
my @sequences=();
foreach $key (sort {lc($a) cmp lc($b)} keys(%data)){ # this part assigns the two scaffolds to an array - alphabetical sort
	if (substr($key,6) eq $scaffold) {
		print "$key\n";
		push(@sequences, $data{$key})
		}
	} # foreachkey in hash
	
# calculate polymorphism & divergence ####################################################################

$num_windows = floor(length($sequences[0])/$windowsize);
my $poly1=0; my $poly2=0; my $div=0; my $dxy=0; my $site_counter=0;
	for $i (0..$num_windows){
		$sub_sequence1 = uc(substr($sequences[0], $i*$windowsize, $windowsize));
		$sub_sequence2 = uc(substr($sequences[1], $i*$windowsize, $windowsize));
		for $k (0..(length($sub_sequence1)-1)){
			my $base1=uc(substr($sub_sequence1,$k,1));
			my $base2=uc(substr($sub_sequence2,$k,1));
			if (($base1 ne "N") && ($base2 ne "N")){
				$site_counter++;
				if ($base1 =~/[RYSWKM]/){
						$poly1++;
						$dxy=$dxy+0.5;
						} # if they are not AGCT
				if ($base2 =~/[RYSWKM]/){
						$poly2++;
						$dxy=$dxy+0.5;
						} # if they are not AGCT
				if (($base1 ne $base2) && ($base1 =~/[GATC]/) && ($base2 =~/[GATC]/)){
						$div++;
						$dxy=$dxy+1;
						} # if they are different
				
			} # if both are non-N bases
		} # for all sites in the window
	my $midpoint= ($i+1)*$windowsize/2 + $i*$windowsize/2;
		my $start=$i*$windowsize + 1;
		my $stop=($i+1)*$windowsize;
       print OUT "$scaffold\t$start\t$stop\t$poly1\t$poly2\t$dxy\t$div\t$site_counter\n";
	$poly1=0; $poly2=0; $div=0; $dxy=0;$site_counter=0;
	} # for each window

} # for each scaffold in the list

close OUT;



