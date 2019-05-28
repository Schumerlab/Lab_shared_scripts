#perl! -w

#Note: bam and vcf file lists must be in the same order for the script to work properly
#Assumes that samtools is available in your path

#example:
#perl gvcf_to_pseudo_fasta.pl vcf_list bam_list xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta pseudo_inversion_test /home/ms857/molly/scripts_bin /home/ms857/molly/bin

if(@ARGV<6){
    print "perl gvcf_to_pseudo_fasta.pl vcf_list bam_list fasta_to_pseudoupdate tag_for_outfile path_to_bin_containing:insnp_v9_gatk3.4_gvcf.py_and_gatk_vcf_to_masked_insnp.pl path_to_bin_containing:GATK_v3.4_seqtk"; exit;
}#print usage

my $vcf_list=shift(@ARGV); chomp $vcf_list;
open IN, $vcf_list or die "cannot open gvcf list\n";

my $bam_list=shift(@ARGV); chomp $bam_list;
open BAM, $bam_list or die "cannot open bam list\n";

my $fasta=shift(@ARGV); chomp $fasta;

my $tag=shift(@ARGV); chomp $tag;

my $insnp_path=shift(@ARGV); chomp $insnp_path;

my $gatk_path=shift(@ARGV); chomp $gatk_path;

my $string="";
while ((my $line=<IN>)&&(my $line2=<BAM>)){
    chomp $line;
    my $insnp="$line".".insnp";
   system("python $insnp_path/insnp_v9_gatk3.4_gvcf.py $line $insnp 20 5 40 10 10 4 -12.5 -8.0 5");
      
    my $awkcmd3="awk \'\{sum\+\=\$3\} END \{ print sum\/NR\}\'";

    print "$awkcmd3\n";

    my $bam=$line2;

    print "samtools depth $bam | $awkcmd3","\n";
    my $depth=qx(samtools depth $bam | $awkcmd3); chomp $depth;

    my $upper=2*$depth; my $lower=$depth/2;

    my $dpinsnp="failing_cov_"."$line";
    my $gatk_cmd="java -jar $gatk_path/GenomeAnalysisTK.jar -T SelectVariants -R $fasta -V "."$line"." -select \"DP < "."$lower"." || DP > "."$upper"."\""." -o "."$dpinsnp";

    system("$gatk_cmd");

    system("perl $insnp_path/gatk_vcf_to_masked_insnp.pl $dpinsnp");

    my $tmp_fasta="tmp_"."$line"."_"."$tag".".fa";
    my $finalfasta="$line"."_"."$tag".".fa";

    my $mask2="$dpinsnp".".insnp";
    system("$gatk_path/seqtk mutfa $fasta $insnp > $tmp_fasta");
    system("$gatk_path/seqtk mutfa $tmp_fasta $mask2 > $final_fasta");

    system("rm $tmp_fasta");

}
