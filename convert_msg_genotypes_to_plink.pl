#perl! -w

#script to take an MSG genotypes file and convert it to plink format
if (@ARGV<1){

    print "perl convert_msg_genotypes_to_plink.pl genotypes_file\n"; exit;

}

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile\n";

my $ped="$infile".".ped";
my $map="$infile".".map";

open PED, ">$ped";
open MAP, ">$map";

my $markers=<IN>; chomp $markers;
my @marker_array=split(/\t/,$markers);

my @positions=(); my $counter=0;
for my $i (1..scalar(@marker_array)-1){

    $counter=$counter+1;
    my $focal=$marker_array[$i]; chomp $focal;
    (my $group, my $pos)=split(/:/,$focal); chomp $group; chomp $pos;

    $group=~ s/group//g;

    print MAP "$group\t$counter\t0\t$pos\n";

    push(@positions, $pos); #in case needed later, no current plans to use

}# process markers, generate map file

my $indiv_counter=0;
while(my $line=<IN>){

$indiv_counter=$indiv_counter+1;

my @data=split(/\t/,$line);

print PED $data[0];
print PED " "."$indiv_counter"." 0 0 -9 -9";

my $geno="";
for my $j (0..scalar(@data)-1){

    my $current=$data[$j]; chomp $current;

    if($current eq '2'){
	$geno="2 2";
    }
    if($current eq '0'){
	$geno="1 1";
    }
    if($current eq '1'){
	$geno="2 1";
    }
    if($current eq 'NA'){
	$geno="0 0";
    }

    if($j < (scalar(@data)-1)){

	print PED "$geno ";

    } else{
	print PED "$geno\n";
    }

}#for all elements in data

}#for all the individuals in the file
