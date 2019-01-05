#perl! -w

#selects items in a file that *do not* match those in a list

if (@ARGV<4){
    print "\n perl script list_to_grep_v grepfile outfile grepw_0_1\n"; exit;
}
#0 for no grep -vw, 1 for yes grep -vw

my $infile1=shift(@ARGV); chomp $infile1;
open IN1, $infile1 or die "could not open list_to_grep_v\n";

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
my $string="";
for $i (0..(scalar(@array)-1)){
    	my $current = $array[$i];

	print "$i\t$current\n";
	if($mode eq 0){
	    if($i eq 0){
		$string="grep -v $current $grepfile";
	    } else{
		$string="$string"." | "."grep -v $current";
	    }
	}#reg grep -v
	if($mode eq 1){
	    if($i eq 0){
                $string="grep -vw $current $grepfile";
            } else{
                $string="$string"." | "."grep -vw $current";
	    }
	}#grep -vw
}

system("$string > $outfile");
