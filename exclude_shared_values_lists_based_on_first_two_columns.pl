#perl! -w

if(@ARGV<2){
    print "perl exclude_shared_values_lists_based_on_first_two_columns.pl file_to_select_from file_to_exclude_from\n"; exit;
}

my $file1=shift(@ARGV); chomp $file1;
my $file2=shift(@ARGV); chomp $file2;

my $outfile="$file1"."_excluded_overlap_"."$file2";
open OUT, ">"."$outfile";

$printed = 0;
open F2, $file2 or die "cannot find list of file to exclude from\n";
my $focal2="";

while (<F2>) {
    my $current=$_;
    my @splitcurrent=split(/\t/,$current);
    $focal2="$splitcurrent[0]"."_"."$splitcurrent[1]"; chomp $focal2;
   
    $h2{$focal2}++;
};
$count2 = $.;
open F1, $file1 or die "cannot find focal file to select from\n";
my $focal1="";
while (<F1>) {
    my $current=$_;
    my @splitcurrent=split(/\t/,$current);
    $focal1="$splitcurrent[0]"."_"."$splitcurrent[1]"; chomp $focal1;
    #print "$focal1\t$h2{$focal1}\n";
    if (! $h2{$focal1}) {
	print OUT $_;
	$printed++;
	
    }
}
$count1 = $.;
