#perl! -w

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list file\n";

while(my $line=<IN>){

    chomp $line;
    my $part1_name="$line"."_part1";
    my $part2_name="$line"."_part2";
    my $bed1="$line".".bed";
    my $bed2="$line".".repeats.bed";
    my $insnp_out="$line".".repeats.insnp";
    $insnp_out =~ s/insnp\.repeats\.insnp/repeats\.insnp/g;

    print "$insnp_out\n";

    system("cut -f 1-2 $line > $part1_name");
    system("cut -f 2-4 $line > $part2_name");

    system("paste $part1_name $part2_name > $bed1");
    system("./bedtools2/bin/intersectBed -a $bed1 -b Xiphophorus_maculatus_LG_REPEATS.rm.gtf | awk \'\$5 \!\= \"N\"\' > $bed2");

    my $command="\'\{\$5=\"N\"\; print\}\'";

#    print "$command\n";

    system("awk $command $bed2 | perl -p -e 's/ +/\t/g' | cut -f 1-2,4-5 > $insnp_out");

}#For all insnp files
