#perl! -w

#this script will submit 24 jobs of a give slurm script, one for each of the X. birchmanni chromosomes
#simply list the chromosome name currently in the slurm script and the name of the slurm script

if(@ARGV<2){
    print "perl submit_all_10x_chroms_shell.pl starting_chrom slurm.sh\n"; exit;
}

my $group_prev=shift(@ARGV); chomp $group_prev; 
$last=$group_prev;

my $slurm=shift(@ARGV); chomp $slurm;

my @chroms = qw(ScyDAA6-1508-HRSCAF-1794 ScyDAA6-1196-HRSCAF-1406 ScyDAA6-5987-HRSCAF-6712 ScyDAA6-8-HRSCAF-51 ScyDAA6-1107-HRSCAF-1306 ScyDAA6-2393-HRSCAF-2888 ScyDAA6-1592-HRSCAF-1896 ScyDAA6-1439-HRSCAF-1708 ScyDAA6-1854-HRSCAF-2213 ScyDAA6-10-HRSCAF-60 ScyDAA6-11-HRSCAF-73 ScyDAA6-695-HRSCAF-847 ScyDAA6-1934-HRSCAF-2318 ScyDAA6-5078-HRSCAF-5686 ScyDAA6-5984-HRSCAF-6694 ScyDAA6-2469-HRSCAF-2980 ScyDAA6-1473-HRSCAF-1750 ScyDAA6-5983-HRSCAF-6649 ScyDAA6-1859-HRSCAF-2221 ScyDAA6-2-HRSCAF-26 ScyDAA6-7-HRSCAF-50 ScyDAA6-2113-HRSCAF-2539 ScyDAA6-2188-HRSCAF-2635 ScyDAA6-932-HRSCAF-11000);

for my $i (0..scalar(@chroms)-1){

    my $focal=$chroms[$i]; chomp $focal;
    print "$focal\n";

    system("perl -pi -e 's/$group_prev/$focal/g' $slurm");
    system("sbatch $slurm");
    
    $group_prev=$focal;

}

my $focal=$last;
print "$focal\n";
system("perl -pi -e 's/$group_prev/$focal/g' $slurm");
system("sbatch $slurm");

