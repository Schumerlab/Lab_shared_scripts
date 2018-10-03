#perl! -w

if(@ARGV<2){
    print "perl phy_to_treemix.pl ordered_phy_infile pops_key_list\n"; exit;
}#print usage

###first file is a phy format sequence file with haplotypes, it MUST be ordered so that individuals appear in the same order as the population file
###the current script *does not* accomodate IUPAC ambiguity codes, use coinflip script to prepared files
###second file is a list, with one line for each population, with the entry matching the number of individuals per population
##for example, if there are three populations, the first having one individual and the rest having two, the file should look like this (minus comments):
#1
#2
#2

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open phy data file\n";

my $pops=shift(@ARGV); chomp $pops;
open ID, $pops or die "cannot open pop ids file\n";

my $total=0; my $num_pops=0; my @indiv_pop_ids=();
while (my $line = <ID>){
    chomp $line;
    $num_pops=$num_pops+1;
    $total=$total+$line;
    for my $p (1..$line){
    push(@ids_per_pop,$num_pops);
    }#track pop ids
    print "pop"."$num_pops"." ";
}#count individuals
print "\n";

for my $i (1..$total){

    my $array_name="array"."$i"; #name array
    @$array_name=(); #initialize array
    my $curr_data=<IN>;
    $curr_data=~ s/ +/\t/g;
    my @temp=split(/\t/,$curr_data);
    my $trim_data=$temp[1]; chomp $trim_data;
    if($trim_data !~ /[ATGC]/){
	my $curr_data=<IN>;
	$curr_data=~ s/ +/\t/g;
	my @temp=split(/\t/,$curr_data);
	$trim_data=$temp[1]; chomp $trim_data;
	#!print "discarding header\n";
    }#discard headers
    @$array_name=split(//,$trim_data);
    #print @$array_name,"\n";

   if ($i == $total){

    for my $j (0..scalar(@$array_name)-1){

	my $string=""; my @curr_bp=(); my @non_n=();
	for my $m (1..$total){
	    
	    my $current_array="array"."$m";
	    my $bp=@$current_array[$j];
	    
	    push(@curr_bp,$bp);
	    if ($bp ne 'N'){
	    push(@non_n,$bp);
	    }#track non-Ns
	    #print "$m\t$string\n";
	}#get bp for all arrays

	my @unique=uniq(@non_n);
	if(scalar(@unique)==2){
	
	    my $base1=$unique[0]; my $base2=$unique[1];
	    my $count_base1=0; my $count_base2=0;
	    my $counter=0; my $curr_pop=""; my $prev_pop=1;
	    for my $l (0..scalar(@curr_bp)-1){
		
		$counter++;

		$curr_pop=$ids_per_pop[$l];
		if($curr_pop ne $prev_pop){
		    print "$count_base1".","."$count_base2"." ";
		    $count_base1=0; $count_base2=0;
		}#zero, print

		my $focal=$curr_bp[$l];
		if($focal eq $base1){
		    $count_base1++;
		}#count
		if($focal eq $base2){
		    $count_base2++;
		}#count 

		$prev_pop=$curr_pop;

	    }#for all basepairs

	    print "$count_base1".","."$count_base2\n";

	}#there are basepairs to track here
	
    }#for all elements 

    }#when at the last element

}#initialize the correct number of arrays

while(my $line2 = <IN>){
    chomp $line2;


}#for all lines




sub uniq {
    my %seen;
    return grep { !$seen{$_}++ } @_;
}
