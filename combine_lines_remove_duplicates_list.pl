#perl! -w

#adapted from FAS scriptome: takes in a list of files and merges their contents while removing duplicates

if(@ARGV<2){
    print "perl combine_lines_remove_duplicates_list.pl list_of_files outfile_name\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list of files\n";

my $outfile=shift(@ARGV); chomp $outfile;

my $string="";
while(my $line=<IN>){
    chomp $line;
    $string="$string"." "."$line";
}#generate string

my $perlcmd="perl \-e \' \$count\=0\; while \(\<\>\) \{ if \(\! \(\$save\{\$\_\}\+\+\)\) \{ print \$\_\; \$count\+\+\; \} \} warn \"\\n\\nRead \$\. lines\.\\nTook union and removed duplicates, yielding \$count lines\.\\n\" \'";

system("$perlcmd $string > $outfile");

