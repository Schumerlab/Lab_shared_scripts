#perl! -w

if(@ARGV<1){
    print "perl convert_birchmanni10x_mapping_output_manhattan_plot_input.pl mapping_results.txt\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;

my $outfile="$infile"."_formanhattan";

system("cp $infile $outfile");

print "copied to $outfile\n";

my @chroms=("ScPPXeE.359.HRSCAF.537","ScPPXeE.326.HRSCAF.486","ScPPXeE.377.HRSCAF.557","ScPPXeE.331.HRSCAF.491","ScPPXeE.167.HRSCAF.256","ScPPXeE.441.HRSCAF.869","ScPPXeE.386.HRSCAF.569","ScPPXeE.427.HRSCAF.677","ScPPXeE.75.HRSCAF.118","ScPPXeE.302.HRSCAF.452","ScPPXeE.436.HRSCAF.810","ScPPXeE.431.HRSCAF.766","ScPPXeE.397.HRSCAF.586","ScPPXeE.219.HRSCAF.334","ScPPXeE.432.HRSCAF.767","ScPPXeE.368.HRSCAF.547","ScPPXeE.438.HRSCAF.817","ScPPXeE.107.HRSCAF.158","ScPPXeE.56.HRSCAF.82","ScPPXeE.428.HRSCAF.694","ScPPXeE.100.HRSCAF.148","ScPPXeE.343.HRSCAF.507","ScPPXeE.173.HRSCAF.267","ScPPXeE.437.HRSCAF.815.");

system("perl -pi -e 's/chrom\.marker/chrom\tmarker/g' $outfile");

my $chrom_num=0;
for my $i (0..scalar(@chroms)-1){
    $chrom_num=$i+1;
    
    my $focal=$chroms[$i]; chomp $focal;
    print "$chrom_num\t$focal\n";

    system("perl -pi -e 's/$focal/$chrom_num\t/g' $outfile");

}#for all chromosomes
