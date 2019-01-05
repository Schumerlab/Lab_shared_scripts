#perl! -w

use List::MoreUtils qw(uniq);

#takes a list of insnp files and merges them into input for Admixtools
#specify whether the reference allele/individual should be printed 0= no, 1 = yes, assumes the reference individual to be homozygous reference (2)
#NOTE: in its current form, this is meant to be run chromosome by chromosomes
#NOTE: depends on overlap_list_retain_unmatched-for-join-insnp.pl

if(@ARGV<6){
    print "perl join_insnp_files.pl list_of_insnp_files_to_join outfiles_tag add_ref_0_1 thresh_num_indivs distance_filter path_to:overlap_list_retain_unmatched-for-join-insnp.pl\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list of insnp files\n";

my $tag=shift(@ARGV); chomp $tag;

my $addref=shift(@ARGV); chomp $addref;

my $thresh=shift(@ARGV); chomp $thresh;

my $distance_filter=shift(@ARGV); chomp $distance_filter;

my $path=shift(@ARGV); chomp $path;

my @positions=(); my @n_positions=();
my @files=();
while(my $line=<IN>){
    chomp $line;
    my $tmp="$line".".tmp";
    my $awk="awk -v "."OFS="."\'\\t\' "."\'\$1=\$1\"_\"\$2\"_\"\$3\'";
#!    print "$awk\n";
    system("$awk $line > $tmp");
    push(@files,$tmp);
    open INSNP, "$tmp" or die "cannot find insnp file $line\n";

    while(my $line2=<INSNP>){
	chomp $line2;
	my @elements=split(/\t/,$line2);
	my $compound=$elements[0]; chomp $compound;
	my $alt=$elements[3]; chomp $alt;
	if($alt ne 'N'){
	push(@positions, $compound);
	} else{
	push(@n_positions,$compound);
        }#only save non-N bases
    }#process each insnp line

}#process all insnp files

#generate positions to exclude for missing-ness
my %count; my %exclude_positions; my $counter=0;
foreach my $element( @n_positions ) {
    ++$count{$element};
}#count
foreach my $element( keys %count ) {
    #print "$count{$element}","\n";
    my $counts = $count{$element};
    if($counts >= $thresh){
#	print "$element\n";
	$counter++;
        $exclude_positions{key} = $element;
    }#save for later exclusion
}#run through and save relevant entries


print "excluding data from ",$counter," markers\n";

#filter arrays to remove singletons and sort by position
my %count_focal; my @uniq_positions_unsorted=(); my @numeric_positions_unsorted=(); my @uniq_positions=();
foreach my $element2( @positions ) {
    ++$count_focal{$element2};
}#count focal sites
foreach my $element2( keys %count_focal ) {
    #print "$count_focal{$element}","\n";                                                                                                 
    my $counts_focal = $count_focal{$element2};
    if($counts_focal >= 2){
        my @splitdata=split(/_/,$element2);

        push(@numeric_positions_unsorted,$splitdata[1]);
        push(@uniq_positions_unsorted,$element2);

        #print "$splitdata[1]\n";
        #print "$element\n";
    }#save                                                                                
}#run through and save relevant entries                                                                                                  

my @all_pos_sorted = sort { $numeric_positions_unsorted[$a] <=> $numeric_positions_unsorted[$b] } 0 .. $#uniq_positions_unsorted;

@uniq_positions=@uniq_positions_unsorted[@all_pos_sorted];

my @filtered_positions=(); my $prev=0; 
for my $k (0..scalar(@uniq_positions)-1){
    my $curr_bp=$uniq_positions[$k]; chomp $curr_bp;
    if($curr_bp !~ [values %exclude_positions]){
	$curr_bp=~ s/^[^_]*_//g;
	$curr_bp=~ s/_.*//g;
    my $distance=$curr_bp-$prev; chomp $distance;
    #print "$curr_bp\t$distance\n";
    if($distance >= $distance_filter){
	$prev=$curr_bp;
	my $curr_bp=$uniq_positions[$k]; chomp $curr_bp;
	push(@filtered_positions,$curr_bp);
	#print "$distance\n";
    }#check distance
    
    }#ensure non-excluded basepair
}#filter for distance

@uniq_positions=@filtered_positions;

print "processing data from ",scalar(@uniq_positions)," markers\n";

my $aims_file="ancestry_informative_sites_"."$tag";
open SITES, ">"."$aims_file";

open OUT1, ">"."$tag".".geno";
open OUT2, ">"."$tag".".snp";
open OUT3, ">"."$tag".".ind";
#now perform matching step
if($addref eq 1){
    print OUT3 "ref\tU\n";
}#if specified, include reference individual

for my $j (0..scalar(@uniq_positions)-1){
    my $focal=$uniq_positions[$j]; chomp $focal;
    my $focal_mod=$focal; #$focal_mod=~ s/_/\t/g;
    print SITES "$focal_mod\n"; 
}#write out focal positions for easy overlap

my $file_string="";
for my $i (0..scalar(@files)-1){
    my $focal_file=$files[$i]; chomp $focal_file;
    system("perl $path/overlap_list_retain_unmatched-for-join-insnp.pl $aims_file $focal_file");
    my $output="overlap"."$aims_file"."_"."$focal_file";
    
    $file_string="$file_string"." "."$output";
    system("rm $focal_file\n");
    $focal_file=~ s/\.tmp//g;
    $focal_file=~ s/\.sorted.dedup.bam.g.vcf.insnp//g;
    print OUT3 "$focal_file\tU\n";
}#overlap focal positions using other script
my $final_output="$aims_file"."_"."allsinsnps";
system("paste $file_string > $final_output");
system("rm $file_string");

my $aim_tracker=0; my $string=""; my $alt=""; 
open AIMS, "$final_output" or die "cannot open merged AIMS file\n";
while (my $results=<AIMS>){
    chomp $results;

    if($addref eq 1){
        $string="2";
    }#generate the string with the reference basepair, assumed to be homozygous reference, i.e. 2    

    $aim_tracker=$aim_tracker+1;
    my @elements=split(/\t/,$results);
    my $match=$uniq_positions[$aim_tracker];

    for my $a (0..scalar(@elements)-1){
	my $focal_base=$elements[$a]; chomp $focal_base;
            if($focal_base =~/[GATC]/){
                $string="$string"."0";
                $alt=$focal_base;
            }#homozygous alternate 
	    if($focal_base =~/[RYSWKM]/){
                $string="$string"."1";
                if(length($alt) eq 0){
                    $alt=$focal_base;
                }#fill with poly bp                                                                                               
	    }#heterozygous         
	    if($focal_base eq 'X'){
	    $string="$string"."2";
	    }#reference 
	    if($focal_base eq 'N'){
	         $string="$string"."9";
	    }#missing   
    }#process all matches for that site

    if($string =~ /[01]/){
    print OUT1 "$string\n";
    
    my @details=split(/_/,$match);
    my $chrom_string="$details[0]".":"."$details[1]"."\t"."$details[0]"."\t"."0.0"."\t"."$details[1]"."\t"."$details[2]"."\t"."$al\t";
    print OUT2 "$chrom_string\n";
    }#ensure not missing or homozygous reference in everyone  

}#process all sites
