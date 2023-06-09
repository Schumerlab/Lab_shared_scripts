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

    my @elements=split(/\t/,$line);
    my $r1=$elements[0]; my $r2=$elements[1];
    
    my $lines1=qx(zcat $r1 | wc -l | perl -p -e 's/ +/\t/g' | cut -f 1); chomp $lines1;
    my $reads1=$lines1/4;

    my $lines2=qx(zcat $r2 | wc -l | perl -p -e 's/ +/\t/g' | cut -f 1); chomp $lines2;
    my $reads2=$lines2/4;

    my $total=$reads1+$reads2;
    print OUT "$line\t$total\n";

}#for all lines
