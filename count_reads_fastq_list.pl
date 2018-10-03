#perl! -w

if (@ARGV<1){

    print "perl count_reads_fastq_list.pl list_of_fastqgz_files\n"; exit;

}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list of fastq files\n";

my $outfile="$infile"."_counts";
open OUT, ">$outfile";

while(my $line=<IN>){

    chomp $line;
    
    my $lines=qx(zcat $line | wc -l | perl -p -e 's/ +/\t/g' | cut -f 1); chomp $lines;
    my $reads=$lines/4;
    print OUT "$line\t$reads\n";

}#for all lines
