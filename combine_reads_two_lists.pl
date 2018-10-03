#perl! -w

#merge two fastq files if you have collected extra data before running ancestry calling
#file name lists must include the whole path
if(@ARGV<2){
    print "perl combine_reads_two_lists.pl list1_read_files_ordered list2_read_files_ordered\n"; exit;
}

my $list1=shift(@ARGV); chomp $list1;
open IN1, $list1 or die "cannot open list1_read_files_ordered\n";

my $list2=shift(@ARGV); chomp $list2;
open IN2, $list2 or die "cannot open list2_read_files_ordered\n";

while((my $line1=<IN1>)&&(my $line2=<IN2>)){
    chomp $line1; chomp $line2;

    my $combined="$line1"."_combined".".fastq.gz";

    $combined=~ s/fastq.gz_//g;

    system("zcat $line1 $line2 | gzip > $combined");

}
