#perl! -w

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile\n";

open OUT, ">"."$infile"."_ASE_counts";

while(my $line=<IN>){
    if($line !~ '#'){
    chomp $line;
    my @fields=split(/\t/,$line);
    my $info=$fields[7]; chomp $info;
    #print "$info\n";
    my @infoarray=split(/;/,$info);
    my @dp4 = grep /DP4/, @infoarray; chomp $dp4;
    my $alldepths=$dp4[0]; chomp $alldepths;
    $alldepths=~ s/DP4=//g;
    my @indiv_depths=split(/,/,$alldepths);
    my $a1=$indiv_depths[0]+$indiv_depths[1];
    my $a2=$indiv_depths[2]+$indiv_depths[3];
    
    print OUT $fields[0],"\t",$fields[1],"\t",$fields[3],"\t",$fields[4],"\t$a1\t$a2\n";

    }#not header line
}#for all lines
