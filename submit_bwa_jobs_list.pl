#perl! -w

###This script assumes that bwa is globally installed. If it is not, export the path to bwa before running the script
###The list of fastq files should contain one entry per line if the data is single end and two per line (tab delimited) if the data is paired end, i.e.:
#id1_read1\n
#or
#id1_read1\tid1_read2\n

###PE/SE for paired end or single end data

###The slurm submission file should contain everything you need to include in your slurm batch command except for the commands to run the job, those will be added by this script

###also give the absolute path to picard tools, leave blanks if globally installed

###give the genome to map to, make sure this is already indexed with bwa index!

if(@ARGV<5){
print "perl submit_bwa_jobs_list.pl list_of_fastq_files PE_or_SE slurm_submission_file path_to_picard_tools genome_to_map_to\n"; exit; 
}#usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list\n";

my $read_type=shift(@ARGV); chomp $read_type;

my $slurm_file=shift(@ARGV); chomp $slurm_file;

my $path_picard=shift(@ARGV); chomp $path_picard;

my $genome=shift(@ARGV); chomp $genome;

my $counter=0;
while(my $line=<IN>){
    chomp $line;
    $counter=$counter+1;
    my @files=split(/\t/,$line);
    my $file1=""; my $file2="";
    if($read_type eq 'PE'){
    $file1=$files[0]; $file2=$files[1];
    } else{
    $file1=$files[0];
    }#define files based on read type

    my $curr_id="$file1";
    $curr_id=~ s/\.fq.gz//g; $curr_id=~ s/\.fastq.gz//g;
    my $RG1="'"."\@RG"."\\t"."ID:"."$curr_id"."\\t"."SM:quail_"."$curr_id"."\\t"."PL:illumina"."\\t"."LB:lib1"."\\t"."PU:LSIslowmode"."'";
    my $command=qx(cat $slurm_file); chomp $command;

    my $sam="$file1".".sam";
    my $bam="$file1".".sorted.bam";
    
    my $string1="bwa mem -t 3 -M -R $RG1 $genome $file1 $file2 > $sam";
    my $string2="java -jar $picard_path/SortSam.jar INPUT="."$sam"." OUTPUT="."$bam"." SORT_ORDER=coordinate";
    my $string3="java -jar $picard_path/BuildBamIndex.jar INPUT="."$bam";

    open OUT, ">run_bwa_shell_"."$counter".".sh";
    print OUT "$command\n$string1\n$string2\n$string3\n";

    my $script="run_bwa_shell_"."$counter".".sh";
    system("sbatch $script");

}
