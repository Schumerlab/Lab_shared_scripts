#perl! -w

if(@ARGV<2){

    print "perl run_samtools_multi_indiv_parental.pl read_list genome1\n"; exit;

}#usage

my $infile1=shift(@ARGV); chomp $infile1; my $trimmed="$infile1"."_trim";
system("cut -f 1 $infile1 > $trimmed");
open IN, $trimmed or die "cannot open indiv id list\n";

my $genome1=shift(@ARGV); chomp $genome1;


while (my $id = <IN>){

    chomp $id;
    my $line1="$id".".sam";
    
    my $unique1="$line1".".sorted.unique.bam";    
    print "sorted bam file is $unique1\n";
    if(! -e $unique1){ die "sorted bam file $unique1 does not exits\n";}

    my $mpileup1="$unique1".".pileup";
    system("bcftools mpileup -o $mpileup1  -f $genome1 $unique1");
    my $vcf1="$unique1".".vcf.gz";
    system("bcftools call -mO z -o $vcf1 $mpileup1");

}
