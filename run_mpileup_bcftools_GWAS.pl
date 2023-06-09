#perl! -w

##ASSUMES THAT SAMTOOLS V~1.3.1 is installed and in your path
##REQUIRES THAT YOU PROVIDE PATHS FOR BCFTOOLS LEGACY AND SAMTOOLS LEGACY
##requires the list of reads used in the previous step
##requires corresponsing list of case/control status of the same length and in the same order. Cases must be coded as 1s and controls as 0s 
##requires name of focal scaffold

if(@ARGV<5){

    print "perl run_samtools_multi_indiv_parental.pl read_list case_control_status genome1 samtools_legacy_path focal_scaff\n"; exit;

}#usage

my $infile1=shift(@ARGV); chomp $infile1; my $trimmed="$infile1"."_trim";
system("cut -f 1 $infile1 > $trimmed");
open IN, $trimmed or die "cannot open indiv id list\n";

my $sampleid=shift(@ARGV); chomp $sampleid;
open ID, $sampleid or die "cannot open sample id list\n";

my $genome1=shift(@ARGV); chomp $genome1;

my $samtools_legacy_path=shift(@ARGV); chomp $samtools_legacy_path;

my $scaff=shift(@ARGV); chomp $scaff;

####make sure reference is indexed:
#!system("samtools faidx $genome1");

my $cases="";
my $controls="";
my $num_controls=0;

my $indivstring="";
my $samplestring="";
while ((my $id = <IN>) && (my $status = <ID>)){

    chomp $status;
    chomp $id;

    my $line1="$id".".sam";

    my $unique1="$line1".".sorted.bam.unique.realigned.bam";    
    print "sorted bam file is $unique1\n";
    if(! -e $unique1){ die "sorted bam file $unique1 does not exits\n";}

#!    system("samtools index $unique1");

if($status==0){
    $num_controls++;
    if(length($controls)>0){
	print "CONTROL\t$unique1\n";
    $controls="$controls"." "."$unique1";
    } else{
	$controls="$unique1";
	print "CONTROL\t$unique1\n";
    }
}
elsif($status==1){
    if(length($cases)>0){
	print "CASE\t$unique1\n";
    $cases="$cases"." "."$unique1";
    } else{
	print "CASE\t$unique1\n";
	$cases="$unique1";
    }
}

    $indivstring="$indivstring"." "."$unique1";
    $samplestring="$indivstring".","."$unique1";
}

#####VARIANT CALLING

    my $mpileup1 = "$infile1"."indivs.allindiv."."$scaff".".bcf";
    my $vcf1="$infile1"."indivs.allindiv."."$scaff".".vcf";
    print "processing data from $indivstring\n";

    print "samtools legacy path is: $samtools_legacy_path\n";

    system("$samtools_legacy_path/samtools-vlegacy mpileup -gR -r $scaff -f $genome1 $controls $cases | $samtools_legacy_path/bcftools-vlegacy view -I -vcg -1 $num_controls - > $vcf1");
    print "$samtools_legacy_path/samtools-vlegacy mpileup -gR -r $scaff -f $genome1 $controls $cases | $samtools_legacy_path/bcftools-vlegacy view -I -vcg -1 $num_controls - > $vcf1","\n";

