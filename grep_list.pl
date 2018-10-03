#perl! -w

if (@ARGV<4){
    print "\n perl script list_to_grep grepfile outfile grepw_0_1\n"; exit;
}
#0 for no grep -w, 1 for yes grep -w

my $infile1=shift(@ARGV); chomp $infile1;
open IN1, $infile1 or die "could not open list_to_grep\n";

my $grepfile=shift(@ARGV); chomp $grepfile;

my $outfile=shift(@ARGV); chomp $outfile;

my $mode=shift(@ARGV); chomp $mode;

my @array=();

if(-e $outfile){

    print "warning, $outfile exists, removing\n";
    system("rm $outfile");

}#warn, remove

while(my $line=<IN1>){
    (my $names, my $junk)=split(/\t/,$line); chomp $names;
    push(@array, $names);
}
close IN1;

print "grepping lines 1-", scalar(@array)+1,"\n";
my $end= scalar(@array); 
for $i (0..(scalar(@array)-1)){
    	my $current = $array[$i];
	print "$i\t$current\n";
	if($mode eq 0){
        system("grep $current $grepfile >> $outfile");
	}#reg grep
	if($mode eq 1){
	system("grep -w $current $grepfile >> $outfile");
	}#grep -w
}
