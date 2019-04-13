#perl! -w

if(@ARGV<2){
    print "perl genotypes_to_rqtl_April2019_v4.pl genotypes_file_matched phenotypes_file_matched\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "wrong format for genotypes file\n";

my $phenos=shift(@ARGV); chomp $phenos;
open PHENO, $phenos or die "wrong format for phenotype file\n";

my @allphenos=();
while(my $phenoline=<PHENO>){
    chomp $phenoline;
    my @phenoelements=split(/\t/,$phenoline);
    push(@allphenos,$phenoelements[1]);
}#process phenos

my $outfile="$infile".".rqtl.csv";
open OUT, ">$outfile";

my $firstline = <IN>; chomp $firstline; 
my $header=$firstline;
$header =~ s/\t/,/g;
$header =~ s/id,//g;
print OUT "pheno,"."$header\n";

my @raw_markers=split(/\t/,$firstline);
for my $k (1..scalar(@raw_markers)-1){

    if($k eq 1){
	print OUT ",";
    }
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

    if($l eq 1){
        print OUT ",";
    }

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

my $genotype=""; my $line_count=0;
while(my $line = <IN>){

    chomp $line; $line_count++;
    my @fields1 = split(/\t/, $line);

    my $current=$allphenos[$line_count];
    print OUT "$current".",";

    #print "$current".","."\n";

    for my $i (1 .. scalar(@fields1)-1){
	$genotype="NA";
	if($fields1[$i] eq 2){$genotype="A";}
	if($fields1[$i] eq 1){$genotype="H";}
	if($fields1[$i] eq 0){$genotype="B";}
	if($fields1[$i] eq "NA"){$genotype="-";}

	if($i != (scalar(@fields1)-1)){
	    print OUT "$genotype".",";
	    #print "$genotype".",";
        } else{
            print OUT "$genotype\n";
	    #print "$genotype\n";
        }#last line in row                                                    
    } # for all elements of the row                                            

}
