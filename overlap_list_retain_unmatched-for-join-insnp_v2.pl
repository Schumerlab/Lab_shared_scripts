#perl! -w

if(@ARGV<3){
    print "perl overlap_list_retain_unmatched.pl list file_to_join outfile_name\n";
}#print usage

###Snippet modifed from the FAS scriptome merge by columns snippet
my $f1=shift(@ARGV); chomp $f1;
my $f2=shift(@ARGV); chomp $f2;
my $out=shift(@ARGV); chomp $out;

#open OUT, ">"."overlap"."$f1"."_"."$f2";
open OUT, ">"."$out";

$col1=0;
$col2=0;

open(F2,$f2);
while (<F2>) {
    s/\r?\n//;
    @F=split /\t/, $_;
    $line2{$F[$col2]} .= "$_\n"
};
$count2 = $.;
open(F1,$f1);
while (<F1>) {
    s/\r?\n//;
    @F=split /\t/, $_;
    $x = $line2{$F[$col1]}; chomp $x;
    if ($x) {

	$x=~ s/\_[a-zA-Z]//g;
	#print "$x\n";
	my @elements_match=split(/\t/,$x);
       
	print OUT "$elements_match[3]\n";
	$merged += $num_changes
    }
    else{
#	print "X\n";
	$_ =~ s/\_[a-zA-Z]//g;
	#print $_,"\t20\t0"."\n";
	print OUT "X"."\n"
    }

}
