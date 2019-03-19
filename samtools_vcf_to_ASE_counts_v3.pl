#perl! -w

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile\n";

open OUT, ">"."$infile"."_ASE_counts";

while(my $line=<IN>){
    if($line !~ '#'){
    chomp $line;
    my @fields=split(/\t/,$line);
    my $info=$fields[11]; chomp $info;
    #print "$info\n";
    my @infoarray=split(/;/,$info);
    my @dp4 = grep /DP4/, @infoarray; chomp $dp4;
    my $alldepths=$dp4[0]; chomp $alldepths;
    $alldepths=~ s/DP4=//g;
    my @indiv_depths=split(/,/,$alldepths);
    my $a1=$indiv_depths[0]+$indiv_depths[1];
    my $a2=$indiv_depths[2]+$indiv_depths[3];
    
    my $base1=$fields[2]; chomp $base1;
    my $base2=$fields[3]; chomp $base2;
    my $alt=$fields[8]; chomp $alt;
    
    if(($alt eq '.') or ($alt eq $base1) or ($alt eq $base2)){
    print OUT $fields[0],"\t",$fields[1],"\t",$fields[2],"\t",$fields[3],"\t$a1\t$a2\n";
    }#check the agreement with the ref/alt base

    }#not header line
}#for all lines
