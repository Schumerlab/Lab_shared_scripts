#!perl

# generates an ancestry file from two .tsv files 
# usage
# perl parse_genotypes_ancestry.pl genotypes_file

if (@ARGV<1){
	print "\nusage: perl parsetsv_ancestry.pl genotypes_file \n"; exit;
}

my $infile = shift(@ARGV); chomp $infile;
open IN, $infile or die "wrong format for in infile\n";

my $outfile = "$infile"."_hybrid_index";
open OUT, ">$outfile";

my $na=NA;
my $malcount=0;
my $bircount=0;
my $ancestry=0;
my $hetcount=0;

print OUT "id\thybrid_index\theterozygosity\n";

my $junk1=<IN>; chomp $junk1;

while ((my $line = <IN>) ){
    chomp $line; 

    $line=~ s/NA/0.33/g;

    my @fields1 = split(/\t/, $line); #birchmanni gempty[es
      
    my $total=0;
    for my $i (1 .. scalar(@fields1)-1){
	if ($fields1[$i]==0){$bircount++; $total++;}
	elsif ($fields1[$i]==2){$malcount++; $total++;}
	elsif ($fields1[$i]==1 ){$bircount=$bircount+.5;$malcount=$malcount+.5; $total++; $hetcount=$hetcount+1;}   
    #}
	else{$genotype="$na";}
      } # for all elements of the row

    if (($malcount ne 0) or ($bircount ne 0)){
    $ancestry= $malcount/($malcount+$bircount);
    #calculate hybrid index
}
    else {$ancestry="NA"}
    #if it is 100% bir or mal or all markers are missing
    my $heterozygosity="NA";
    if($total>0){
    $heterozygosity=$hetcount/$total;
    }
    print OUT "$fields1[0]\t$ancestry\t$heterozygosity\n";
    $malcount=0; $bircount=0; $hetcount=0;
} # while the infile has lines in it

