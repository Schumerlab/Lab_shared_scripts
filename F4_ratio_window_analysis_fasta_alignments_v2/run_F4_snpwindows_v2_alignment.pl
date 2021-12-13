#perl! -w

my $infile_snps=shift(@ARGV); chomp $infile_snps;
open IN, $infile_snps or die "cannot open snps file\n";

my $infile_map=shift(@ARGV); chomp $infile_map;
open MAP, $infile_map or die "cannot open map file\n";

my $infile_indiv=shift(@ARGV); chomp $infile_indiv;

system("cp $infile_indiv alignment.eigen.indiv");

my $window_size=shift(@ARGV); chomp $window_size;

my $tag=$infile_map; $tag=~ s/\.variant.reformat.coords.map.eigen//g;
open OUT1, ">alignment.ped.eigen.currwindow";
open OUT2, ">alignment.map.eigen.currwindow";
open OUT3, ">$tag"."_F4ratio_results_"."$window_size"."snp";
my $start=1; my $stop=$window_size; my $group=1; my $group_prev=1;
my $counter=0; my $snp=""; my $group="";
while((my $line1 = <MAP>) && (my $line2 = <IN>)){
    chomp $line1; chomp $line2;
    my $info=$line1;
    $info=~ s/ +/\t/g;

    $counter++;
    my @elements=split(/\t/,$info);
    $group=$elements[2]; chomp $group;
    $snp=$elements[4]; chomp $snp;

    if(($counter<$stop)&&($group eq $group_prev)){

	print OUT1 "$line2\n";
	print OUT2 "$line1\n";
	
    }
    else{
	#run, store
	
	if($group>22){
	    system("perl -pi -e 's/ $group / 1 /g' alignment.ped.eigen.currwindow");
	    system("perl -pi -e 's/ $group / 1 /g' alignment.map.eigen.currwindow");
	}#deal with hard coding for humans :( 

	my $results =qx(qpF4ratio -p parqpF4ratio_bywindows_alignment_v2 | grep result | perl -p -e 's/ +/\t/g' | cut -f 12); chomp $results;
	#print "$results\n";
	if(length($results)==0){
	    $results="NA";
	}
	if(abs($results)>1){
	    $results="NA";
	}#problem values

	if($group ne $group_prev){
	    print OUT3 "$group\t$start\t$snp\t$results\n";
	    $stop=$window_size;
	    #print "$group\t$stop\n";
	    $counter=0; $start=$snp;
	}#start new counter
	if($group eq $group_prev){
	    print OUT3 "$group\t$start\t$snp\t$results\n";
	    $stop=$window_size;
	    #print "$group\t$stop\n";
	    $counter=0; $start=$snp;
	}#set new window end


	open OUT1, ">alignment.ped.eigen.currwindow";
        open OUT2, ">alignment.map.eigen.currwindow";

        print OUT1 "$line2\n";
        print OUT2 "$line1\n";

    }# do what's needed for the next window

    $group_prev=$group;
}#for all the lines

my $results =qx(qpF4ratio -p parqpF4ratio_bywindows_alignment_v2 | grep result | perl -p -e 's/ +/\t/g' | cut -f 12); chomp $results;
print "$results\n";

if($group ne $group_prev){
    print OUT3 "$group\t$start\t$snp\t$results\n";
    $stop=$window_size;
    #print "$group\t$stop\n";
    $start=$snp;
}#start new counter                                                                                                                                                             
if($group eq $group_prev){
    print OUT3 "$group\t$start\t$snp\t$results\n";
    $stop=$stop+$window_size;
    #print "$group\t$stop\n";
    $start=$snp;
}#set new window end                                                                                                                                                            
