#!perl

# generates an ancestry file from two .tsv files 
# usage
# perl parsetsv_ancestry.pl infilepar1 infilepar2 > outfile

if (@ARGV<2){
	print "\nusage: perl parsetsv_ancestry.pl genotypes_file path_to:transpose_nameout.pl\n"; exit;
}

my $infile = shift(@ARGV); chomp $infile;

my $outfile = "$infile"."_ancestry_by_site";
open OUT, ">$outfile";

my $path=shift(@ARGV); chomp $path;
system("perl $path/transpose_nameout.pl $infile");
my $trans_in="$infile"."_transposed";
open IN, $trans_in or die "cannot open transposed infile\n";

my $na=NA;
my $malcount=0;
my $bircount=0;
my $ancestry=0;

print OUT "group\tpos\tmalinche_ancestry\tnum_indiv\n";

my $junk1=<IN>; chomp $junk1;

while ((my $line = <IN>) ){
    chomp $line; 

    $line=~ s/NA/0.33/g;

    my @fields1 = split(/\t/, $line); #birchmanni gempty[es
      
    my $total=0;
    for my $i (1 .. scalar(@fields1)-1){
	if ($fields1[$i]==0){$bircount++; $total++;}
	elsif ($fields1[$i]==2){$malcount++; $total++;}
	elsif ($fields1[$i]==1 ){$bircount=$bircount+.5;$malcount=$malcount+.5; $total++;}   
    #}
	else{$genotype="$na";}
      } # for all elements of the row

    if (($malcount ne 0) or ($bircount ne 0)){
    $ancestry= $malcount/($malcount+$bircount);
    #calculate hybrid index
}
    else {$ancestry="NA"}
    #if it is 100% bir or mal or all markers are missing
    my $modified=$fields1[0];
    $modified=~ s/:/\t/g;
    print OUT "$modified\t$ancestry\t$total\n";
    $malcount=0; $bircount=0;
} # while the infile has lines in it

