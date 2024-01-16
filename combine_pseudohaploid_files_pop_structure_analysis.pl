#perl! -w

#script used as part of pseudohap workflow:
#see wiki entry: https://openwetware.org/wiki/Schumer_lab:_Commonly_used_workflows#Pseudohaploid_calls_for_GWAS_or_population_structure_analysis_from_low_coverage_data

if(@ARGV<1){
    print "perl combine_pseudohaploid_files_pop_structure_analysis.pl list_of_pseudo_hap_files\n"; exit;
}

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list of files\n";

my $out="$list"."_data_frame.txt";
open OUT, ">$out";

print "writing data frame to outfile: $out\n";

my $string=""; my $name_string=""; my $counter="";
while(my $line=<IN>){
    $counter++;
    chomp $line;

    my $trim="$line"."_trim";
    
    $trim=~ s/.gz.sam.sorted.bam.unique.realigned.bam.mpileup.vcf//g;
    my $transposed="$trim"."_transposed";

    if($counter eq 1){
	system("cat $line | perl -pe \'s\/\\t\/\:\/\' > $trim");
	system("perl /home/groups/schumer/shared_bin/Lab_shared_scripts/transpose_nameout.pl $trim");
	system("perl -pi -e \'s\/chr\/id\\tchr\/\' $transposed");
	system("perl -pi -e \'s\/\\n\/\\n$trim\\t\/\' $transposed");
	system("head -n 2 $transposed > $trim");
	system("mv $trim $transposed");
  } else{
    system("cut -f 1-2 --complement $line > $trim");
    system("perl /home/groups/schumer/shared_bin/Lab_shared_scripts/transpose_nameout.pl $trim");
    }

    
    my $current=qx(cat $transposed); chomp $current;
    if($counter eq 1){
	print OUT "$current\n";
    }else{
    print OUT "$trim\t$current\n";
    }
}


