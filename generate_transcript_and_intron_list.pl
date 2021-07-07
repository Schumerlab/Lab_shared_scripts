#perl! -w 

###my_list should be an \n delimited file with the exact gene name of the gene of interest

if(@ARGV<4){
    print "perl generate_transcript_seqs_list.pl my_list gtf_file genome outfile_name\n"; exit;
}#check command line

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list of gene names\n";

my $gtf=shift(@ARGV); chomp $gtf;

my $genome=shift(@ARGV); chomp $genome;

my $outfile=shift(@ARGV); chomp $outfile;

open OUT, ">$outfile";

while(my $line=<IN>){

    chomp $line;
    print "$line\n";
    my $start=qx(grep -w $line $gtf | cut -f 4 | head -n 1); chomp $start;
    my $stop=qx(grep -w $line $gtf | cut -f 5 | tail -n 1); chomp $stop;
    my $scaff=qx(grep -w $line $gtf | cut -f 1 | head -n 1); chomp $scaff;
#    system("grep -w $line $gtf | grep CDS > focal_gene.gtf");
#    my $seq=qx(perl /home/groups/schumer/shared_bin/Lab_shared_scripts/extract_gtf_seqs_mergetranscript_printstdout_10x_assembly.pl focal_gene.gtf $genome $line); chomp $seq;

    my $seq=qx(fastahack $genome -r $scaff:$start..$stop); chomp $seq;

    print OUT ">"."$line"."_w_intron\n"."$seq\n";

}

#system("perl -pi -e 's/focal_gene.gtf_//g' $outfile");
