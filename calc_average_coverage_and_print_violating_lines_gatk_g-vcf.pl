#perl! -w

use List::Util qw(sum);

#this script takes n random lines from a gatk gvcf file and returns average coverage, then modifies entries for coverage violators for use with insnp_v9_gatk3.4_gvcf.py
#coverage violators are defines as >2x genome-wide average coverage and <2x genome-wide average coverage

if(@ARGV<2){
    print "perl average_coverage_subsample_gatk_g-vcf.pl g.vcf_file number_of_lines\n"; exit;
}#usage

my $infile=shift(@ARGV); chomp $infile;

my $number=shift(@ARGV); chomp $number;

my $sample="$infile".".sample";
my $masked="$infile".".cov-corrected";

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
my $upper=2*$avg;
my $lower=$avg/2;
print "$avg\n";

open VCF, $infile or die "cannot open g.vcf";
open OUT, ">$masked";
while(my $line2=<VCF>){
    chomp $line2;
    #print "$line2\n";
    if($line2 =~ /#/){
	print OUT "$line2\n";
}else{
    my @elements2=split(/\t/,$line2);
    #print "$info2\n";
    $info2=$elements2[9]; chomp $info2;
    my @dpinfo2=split(/:/,$info2);
    my $dp=0;
    if($info2 =~ '0/0'){
	$dp=$dpinfo2[1]; chomp $dp; my $replace=".\/.:0:0"; my $sub2=$elements2[7]; chomp $sub2; my $sub3="$elements2[8]"; chomp $sub3;
	if(($dp >= $lower) && ($dp <= $upper)){print OUT "$line2\n";}
	else{$line2=~ s/\|/-/g; $info2=~ s/\|/-/g; $line2=~ s/$info2/$replace/g; $line2=~ s/$sub2/\./g; $line2=~ s/$sub3/GT:DP:RGQ/g; print OUT "$line2\n";}
        }
    elsif(($info2 =~ '0/1') or ($info2 =~ '1/1')){
	my $alleles=$dpinfo2[1]; chomp $alleles;
	my @allele_depth=split(/,/,$alleles);
        $dp=$allele_depth[0]+$allele_depth[1]; my $replace=".\/.:0:0"; my $sub2=$elements2[7]; chomp $sub2; my $sub3="$elements2[8]"; chomp $sub3;
	if(($dp >= $lower) && ($dp <= $upper)){print OUT "$line2\n";}
	else{$line2=~ s/\|/-/g; $info2=~ s/\|/-/g; $line2=~ s/$info2/$replace/g; $line2=~ s/$sub2/\./g; $line2=~ s/$sub3/GT:DP:RGQ/g; print OUT "$line2\n";}
    }
    elsif($info2 =~ './.'){
        print OUT "$line2\n";
    }
    
    }#print out header line or process
}


sub mean {
    return sum(@_)/@_;
}
