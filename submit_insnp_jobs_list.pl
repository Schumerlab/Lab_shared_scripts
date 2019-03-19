#perl! -w

if(@ARGV<3){
    print "perl submit_insnp_jobs_list.pl gatk3.4_g.vcf_files_list path_to_insnp_and_coverage_scripts:insnp_v9_gatk3.4_gvcf.py:calc_average_coverage_and_print_violating_lines_gatk_g-vcf.pl slurm_header.sh\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list of g.vcf files\n";

my $path1=shift(@ARGV); chomp $path1; 

my $slurm=shift(@ARGV); chomp $slurm;

my $counter=0;
while(my $line=<IN>){

    chomp $line; $counter++;

    my $cor="$line".".cov-corrected"; my $sample="$line".".sample";

    my $command1="perl $path1/calc_average_coverage_and_print_violating_lines_gatk_g-vcf.pl $line 500000";
    my $insnp="$cor".".insnp";
    my $command2="python $path1/insnp_v9_gatk3.4_gvcf.py $cor $insnp 20 10 40 2 60 4 -12.5 -8.0 5";
    
    my $submit=qx(cat $slurm); chomp $submit;

    my $currscript="run_insnp_jobs"."$counter".".sh";
    open OUT, ">"."$currscript";
    print OUT "$submit\n";
    print OUT "module load py-numpy\n"; 
    print OUT "$command1\n$command2\n";
    print OUT "rm $cor $sample\n";

    system("sbatch $currscript");

}#for all insnp files
