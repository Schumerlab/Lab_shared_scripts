#perl! -w

if(@ARGV<2){
    print "perl extract_chrom_to_raxml_list.pl genome_list random_select_file outfile_tag_name\n"; exit;
}

my $genomes=shift(@ARGV); chomp $genomes;
open IN, $genomes or die "cannot open genomes list\n";

my @genomes_array=();
while(my $line1=<IN>){
    chomp $line1; 
    push(@genomes_array,$line1);
}


my $chroms=shift(@ARGV); chomp $chroms;
open CHR, $chroms or die "cannot open chromosomes list\n";

my @chroms_array=(); my @start_array=(); my @stop_array=();
while(my $line2=<CHR>){
    chomp $line2;
    my @tmp=split(/\t/,$line2);
    push(@chroms_array,$tmp[0]);
    push(@start_array,$tmp[1]);
    push(@stop_array,$tmp[2]);
}

my $outfile_tag=shift(@ARGV); chomp $outfile_tag;
my @ids=(); my $counter=0; my $name=""; my @file_names=();
for my $i (0..scalar(@genomes_array)-1){
  
	my $curr_genome=$genomes_array[$i];
	my $id=substr($curr_genome,0,4);
	print "named $curr_genome as $id\n";
	
	    push (@ids,$id);
	    #print "$id\n";

    open OUT, ">"."$outfile_tag"."_"."$id";
    $name="$outfile_tag"."_"."$id";

	my $string="";
	for my $k (0..scalar(@start_array)-1){
	    my $chr=$chroms_array[$k];
	    my $startbp=$start_array[$k];
	    my $stopbp=$stop_array[$k];
	my $data_catch=qx(fastahack $curr_genome -r $chr:$startbp..$stopbp); chomp $data_catch;
	    $string="$string"."$data_catch";
	}

	print OUT ">"."$id\n"."$string\n";
       

    push(@file_names,$name);
    
}#do the following for all genomes

open FINAL, ">$outfile_tag"."_concatenated.fasta";
my $tmpname="$outfile_tag"."_concatenated.fasta";
#print "final results printing to $tmpname\n";

for my $j (0..scalar(@ids)-1){

    my $focal_id=$ids[$j];
    print "joining individual $focal_id\n";

    my $string="";
    for my $w (0..scalar(@file_names)-1){

	my $focal_file=$file_names[$w];
	print "processing file $focal_file\n";

	my $raw_data=qx(perl /home/groups/schumer/shared_bin/Lab_shared_scripts/getScaffold_samtools.pl $focal_file $focal_id | tail -n +2 | perl -p -e 's/\n//g'); chomp $raw_data;

	$string="$string"."$raw_data";
	
    }

    print FINAL ">"."$focal_id\n"."$string\n";

}

print "final results printed to $tmpname\n";

