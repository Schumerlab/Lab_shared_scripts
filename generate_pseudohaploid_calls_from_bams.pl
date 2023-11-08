#perl! -w

if(@ARGV<3){

    print "usage is: perl generate_pseudohaploid_calls_from_bams.pl bam_list.txt fasta_file.fa chr_targets.tsv.gz\n"; exit;

}

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open bam list\n";

my $fasta=shift(@ARGV); chomp $fasta;

my $targets=shift(@ARGV); chomp $targets;

while(my $line=<IN>){

    chomp $line;
    my $vcf="$line".".mpileup.vcf.gz";

    system("bcftools mpileup -f $fasta -T $targets $line | bcftools call -mO z -i -T $targets -C alleles -i -o $vcf");

    my $unzip="$line".".mpileup.vcf";

    system("gunzip $vcf");

    system("perl /home/groups/schumer/shared_bin/Lab_shared_scripts/pseudo_haploid_calls_bcftools.pl $unzip");

}
