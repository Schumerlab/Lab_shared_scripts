#perl! -w

if(@ARGV<3){
    print "perl run_map_GWAS.pl read1_list genome SE_or_PE\n";
}

my $infile1=shift(@ARGV); chomp $infile1;
open IN1, $infile1 or die "cannot open list of reads\n";

my $genome1=shift(@ARGV); chomp $genome1;

my $read_type=shift(@ARGV); chomp $read_type;

$counter=0;
open OUT1, ">sam_mapped_to_genome";
while(my $line1 =<IN1>){

    chomp $line1;
    
    if($read_type eq 'SE'){
	$counter=$counter+1; $curr_id="xipho_id"."$counter";

        my @read_array=split(/\t/,$line1);
        my $read1=$read_array[0]; chomp $read1;

	my $sam1 = "$read1".".sam";


    my $RG1="'"."\@RG"."\\t"."ID:"."$curr_id"."\\t"."SM:tn5_"."$curr_id"."\\t"."PL:illumina"."\\t"."LB:hyblib1"."\\t"."PU:LSIslowmode"."'";
	print "read group header is $RG1\n";
    system("bwa mem -M -R $RG1 $genome1 -t 3 $read1 > $sam1");

    my $bam1="$sam1".".bam";
    system("samtools fixmate -O bam $sam1 $bam1");
    $sorted1="$bam1".".sorted";
    $sorted1=~ s/\.bam//g;
    $sorted1="$sorted1".".bam";

    print "sorted bam file is $sorted1\n";

    system("samtools sort $bam1 -o $sorted1");
    system("samtools index $sorted1");
    my $dedup1="$sorted1".".dedup";
    my $metrics1="$line1".".metrics";

    my $unique1 = "$sorted1".".unique.bam";
    $unique1 =~ s/sorted.bam.unique/sorted.unique/g;
    system("samtools view -b -q 30 $sorted1 > $unique1");
    system("samtools index $unique1");

    

    print OUT1 "$sam1\t$curr_id\n";
 
    }#SE reads

    if($read_type eq 'PE'){

	$counter=$counter+1; $curr_id="xipho_id"."$counter";
	my @read_array=split(/\t/,$line1);

	my $read1=$read_array[0]; chomp $read1;
	my $read2=$read_array[1]; chomp $read2;

        my $sam1 = "$read1".".sam";

     my $RG1="'"."\@RG"."\\t"."ID:"."$curr_id"."\\t"."SM:tn5_"."$curr_id"."\\t"."PL:illumina"."\\t"."LB:hyblib1"."\\t"."PU:LSIslowmode"."'";
       print "read group header is $RG1\n";
       system("bwa mem -M -R $RG1 $genome1 -t 3 $read1 $read2 > $sam1");

     my $bam1="$sam1".".bam";
     system("samtools fixmate -O bam $sam1 $bam1");
     $sorted1="$bam1".".sorted";
     $sorted1=~ s/\.bam//g;
     $sorted1="$sorted1".".bam";

     print "sorted bam file is $sorted1\n";

     system("samtools sort $bam1 -o $sorted1");
     system("samtools index $sorted1");
     my $dedup1="$sorted1".".dedup";
     my $metrics1="$line1".".metrics";

     my $unique1 = "$sorted1".".unique.bam";
     $unique1 =~ s/sorted.bam.unique/sorted.unique/g;
     system("samtools view -b -q 30 $sorted1 > $unique1");
     system("samtools index $unique1");

    print OUT1 "$sam1\t$curr_id\n";

    }#PE reads

}#map each read in list

