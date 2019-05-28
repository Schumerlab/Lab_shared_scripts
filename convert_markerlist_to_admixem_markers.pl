#perl! -w

use List::MoreUtils qw(uniq);

#format for markers file:
#chr_name\tpos1
#chr_name\tpos2

if(@ARGV<2){
    print "perl convert_markerlist_to_admixem_markers.pl markers_file chr_length_list\n"; exit;
}#print usage

my $markers_file=shift(@ARGV); chomp $markers_file;
open IN, $markers_file or die "cannot open markers file\n";

my $lengths=shift(@ARGV); chomp $lengths;
open LENGTHS, $lengths or die "cannot open lengths file\n";

my @chrs=(); my @markers=();
while(my $line=<IN>){

    chomp $line;
    
    my @elements=split(/\t/,$line);

    my $chr=$elements[0]; my $site=$elements[1];

    push(@chrs,$chr);
    push(@markers,$site);

}#all markers

#run appropriate printout

my @uniq_chrs = uniq(@chrs);

my $num_chrs=scalar(@uniq_chrs);

my @chr_lengths=();
while(my $tmp=<LENGTHS>){
    chomp $tmp;
    push(@chr_lengths,$tmp);
}#all length

print "HaploidChromosomeNum = "."$num_chrs\n";
print "RandomSeed = 0.2\n";
print "Pop1AvgAlleleFreq = 1\n";
print "Pop1AvgAlleleFreqStdev = 0\n";
print "Pop2AvgAlleleFreq = 1\n";
print "Pop2AvgAlleleFreqStdev = 0\n";
my $chrl=$chr_lengths[0]; chomp $chrl;
print ":chr 1 len = "."$chrl"."  centromere = "."$chrl\n\n";
print "Num\tPosition\tPercentage\tPosition Abs.\tFreq. Pop 1\tFreq. Pop 2\n";

my $chr_prev=$chrs[0]; chomp $chr_prev; my $counter=1; my $chrom_num=1;
for my $i (0..scalar(@markers)-1){

    my $focal_chr=$chrs[$i]; chomp $focal_chr;

    if($focal_chr ne $chr_prev){
	$chrom_num=$chrom_num+1;
	my $y=$chrom_num-1;
	$chrl=$chr_lengths[$y]; chomp $chrl;
	print ":chr "."$chrom_num"." "."len = "."$chrl"."  "."centromere = "."$chrl\n\n";
	print "Num\tPosition\tPercentage\tPosition Abs.\tFreq. Pop 1\tFreq. Pop 2\n";
	$counter=1;
    }#new chrom, print header, reset
 
    print "$counter\t";

    my $focal_marker=$markers[$i]; chomp $focal_marker;
    my $fraction=$focal_marker/$chrl;

    print "$fraction\t$focal_marker\t1\t0\n";
    
    $counter++;
    $chr_prev=$focal_chr;
}#for all markers
