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

    system("grep -w $line $gtf | grep CDS > focal_gene.gtf");
    my $seq=qx(perl /home/groups/schumer/shared_bin/Lab_shared_scripts/extract_gtf_seqs_mergetranscript_printstdout_10x_assembly.pl focal_gene.gtf $genome $line); chomp $seq;

    print OUT "$seq\n";

}

system("perl -pi -e 's/focal_gene.gtf_//g' $outfile");
