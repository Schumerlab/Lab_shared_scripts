#perl!

use List::Util qw(sum);

#this script takes n random lines from a gatk gvcf file and returns average coverage

if(@ARGV<2){
    print "perl average_coverage_subsample_gatk_g-vcf.pl g.vcf_file number_of_lines\n"; exit;
}#usage

my $infile=shift(@ARGV); chomp $infile;

my $number=shift(@ARGV); chomp $number;

my $sample="$infile".".sample";

system("grep -v '#' $infile | shuf -n $number > $sample");

open IN, $sample or die "cannot open subsampled vcf\n";

my @dp_array=();
while(my $line=<IN>){
    chomp $line;

    my @elements=split(/\t/,$line);

	$info=$elements[9]; chomp $info;
	my @dpinfo=split(/:/,$info);
    
   if($info =~ '0/0'){
       my $dp=$dpinfo[1]; chomp $dp;
       push(@dp_array,$dp);
   }
   elsif(($info =~ '0/1') or ($info =~ '1/1')){
       my $alleles=$dpinfo[1]; chomp $alleles;
       my @allele_depth=split(/,/,$alleles);
       my $dp=$allele_depth[0]+$allele_depth[1];
       push(@dp_array,$dp);
   }
    elsif($info =~ './.'){
	#print "$info\n";
	push(@dp_array,0);
    }


}#for all lines

my $avg= mean(@dp_array);
print "$avg\n";

sub mean {
    return sum(@_)/@_;
}
