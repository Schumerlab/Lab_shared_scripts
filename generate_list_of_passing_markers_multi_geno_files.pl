#perl! -w

if(@ARGV<1){
    print "perl generate_list_of_passing_markers_multi_geno_files.pl list_of_marker_files\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list of marker files\n";

my $instances=0;

my @marker_array=();
while(my $line=<IN>){

    $instances++;
    chomp $line;

    open MARKER, "$line" or die "cannot find marker file $line\n";

    while (my $focal=<MARKER>){
	chomp $focal;
	push(@marker_array,$focal);
    }#generate giant array

}#for all focal files


#sort and write to file (to keep a record)
my $log_file="$list"."_marker_number_log"; 
open LOG, ">"."$log_file";
my %number;
++$number{$_} for @marker_array;
print LOG "$_\t$number{$_}\n"
for sort {$a <=> $b} keys %number;

my $mod_file="$log_file"."_sorted";
system("cat $log_file | perl -p -e 's/:/\t/g' | sort -k1,1 -k2n > $mod_file");

open NUMBERS, "$mod_file" or die "cannot open $mod_file\n";
open OUT, ">"."passing_markers_"."$list";
my @all_passing_markers=();
while(my $num=<NUMBERS>){

    chomp $num;
    my @counts=split(/\t/,$num);

    my $occurs=$counts[2]; chomp $occurs;

    if($occurs eq $instances){
	print OUT "$counts[0]".":"."$counts[1]"."\n";
    }#marker passes

}#log and filter
