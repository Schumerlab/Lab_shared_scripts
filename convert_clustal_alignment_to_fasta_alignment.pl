#perl! -w

if(@ARGV<2){
    print "perl convert_clustal_alignment_to_fasta_alignment.pl clustal_alignment.txt seq_name_to_extract\n"; exit;
}#print usage

#converts clustal alignment format to fasta alignment format
my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile\n";

my $seqname=shift(@ARGV); chomp $seqname;

my $seq="";
while(my $line=<IN>){
    chomp $line;
    if ($line=~ $seqname){
	$line =~ s/$seqname//g;
	$line =~ s/ +//g;
	$line =~ s/\d//g;
	$line =~ s/\t//g;
	$seq="$seq"."$line";
	#print "$line\n";
    }

}#for all lines

print ">"."$seqname\n$seq\n";
