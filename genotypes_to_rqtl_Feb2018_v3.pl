#perl! -w

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "wrong format for genotypes file\n";

my $outfile="$infile".".rqtl.csv";
open OUT, ">$outfile";

my $firstline = <IN>; chomp $firstline; 
my $header=$firstline;
$header =~ s/\t/,/g;
$header =~ s/id,//g;
print OUT "$header\n";

my @raw_markers=split(/\t/,$firstline);
for my $k (1..scalar(@raw_markers)-1){

    my $currentmarker=$raw_markers[$k];
#    print "$currentmarker\n";
    my @markerdata=split(/\:/,$currentmarker);
    my $group=$markerdata[0]; chomp $group;

    if($k ne (scalar(@raw_markers)-1)){
	print OUT "$group".",";
    }
    else{
	print OUT "$group\n";
    }

}#process markers 

for my $l (1..scalar(@raw_markers)-1){

    my $currentmarker=$raw_markers[$l];
#    print "$currentmarker\n";                                                                                                                     
    my @markerdata=split(/\:/,$currentmarker);
    my $dist=$markerdata[1]; chomp $dist;
    $dist=$dist/1e6;
    if($l ne (scalar(@raw_markers)-1)){
        print OUT "$dist".",";
    }
    else{
        print OUT "$dist\n";
    }

}#process markers  

my $genotype="";
while(my $line = <IN>){

    chomp $line;
    my @fields1 = split(/\t/, $line);
    
    for my $i (1 .. scalar(@fields1)-1){
	$genotype="NA";
	if($fields1[$i] eq 2){$genotype="A";}
	if($fields1[$i] eq 1){$genotype="H";}
	if($fields1[$i] eq 0){$genotype="B";}
	if($fields1[$i] eq "NA"){$genotype="-";}

	if($i != (scalar(@fields1)-1)){
	    print OUT "$genotype".",";
        } else{
            print OUT "$genotype\n";
        }#last line in row                                                    
    } # for all elements of the row                                            

}
