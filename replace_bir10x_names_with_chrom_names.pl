#perl! -w

if(@ARGV<1){
    print "perl replace_bir10x_names_with_chrom_names.pl infile-10x-names\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;

my $outfile="$infile".".chromnames";

system("cp $infile $outfile");

my @chrs=qw(ScyDAA6-1508-HRSCAF-1794 ScyDAA6-1196-HRSCAF-1406 ScyDAA6-5987-HRSCAF-6712 ScyDAA6-8-HRSCAF-51 ScyDAA6-1107-HRSCAF-1306 ScyDAA6-2393-HRSCAF-2888 ScyDAA6-1592-HRSCAF-1896  ScyDAA6-1439-HRSCAF-1708 ScyDAA6-1854-HRSCAF-2213 ScyDAA6-10-HRSCAF-60 ScyDAA6-11-HRSCAF-73 ScyDAA6-695-HRSCAF-847 ScyDAA6-1934-HRSCAF-2318 ScyDAA6-5078-HRSCAF-5686 ScyDAA6-5984-HRSCAF-6694 ScyDAA6-2469-HRSCAF-2980 ScyDAA6-1473-HRSCAF-1750 ScyDAA6-5983-HRSCAF-6649 ScyDAA6-1859-HRSCAF-2221 ScyDAA6-2-HRSCAF-26 ScyDAA6-7-HRSCAF-50 ScyDAA6-2113-HRSCAF-2539 ScyDAA6-2188-HRSCAF-2635 ScyDAA6-932-HRSCAF-1100);

for my $i (0..scalar(@chrs)-1){

    my $focal=$chrs[$i];
    my $groupnum=$i+1;

    my $group="group"."$groupnum";

    system("perl -pi -e 's/$focal/$group/g' $outfile");

}#replace all chromosome names
