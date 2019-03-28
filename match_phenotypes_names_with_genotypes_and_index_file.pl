#perl! -w

###Matches lab phenotypes file format to genotypes and hybrid index file format, writing out a new matched file for each

###Phenotype format expected:
#header
#indiv1_id\tpheno1\tpheno2\tpheno-n\n
#indiv2_id\tpheno1\tpheno2\tpheno-n\n

###Genotypes format expected:
#header
#indiv1_tn5id\tgeno1\tgeno2\tgeno-n\n
#indiv2_tn5id\tgeno1\tgeno2\tgeno-n\n 

###Hybrid index format expected (output of parsetsv_ancestry_v2.pl)
##header
#indiv1_tn5id\thybrid_index\theterozygosity
#infiv3_tn5id\thybrid_index\theterozygosity

if(@ARGV<3){
    print "perl match_phenotypes_name_list_with_genotypes_file.pl phenotype_file_names_first_column genotypes_file hybrid_index_file_from_parsetsv\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open phenotypes file\n";

my $pheno_header=<IN>; chomp $pheno_header;

my $geno=shift(@ARGV); chomp $geno;

my $geno_header=qx(head -n 1 $geno); chomp $geno_header;

my $index=shift(@ARGV); chomp $index;

my $index_header=qx(head -n 1 $index); chomp $index_header;
open PHENO, ">"."$list"."_matched_to_"."$geno";
open GENO, ">"."$geno"."_matched_to_"."$list";
open INDEX, ">"."$index"."_matched_to_"."$list";

print GENO "$geno_header\n";
print INDEX "$index_header\n";
print PHENO "$pheno_header\n";

while(my $line=<IN>){
    chomp $line;
    my @elements=split(/\t/,$line);
    my $name=$elements[0]; chomp $name;
    $name="$name"."_";
    print "$name\n";
    my $geno_match=qx(grep $name $geno); chomp $geno_match;
    my $index_match=qx(grep $name $index); chomp $index_match;

    my $check_count=qx(grep $name $geno | wc -l | perl -p -e 's/ +/\t/g' | cut -f 1); chomp $check_count;
    my $check_index=qx(grep $name $index | wc -l | perl -p -e 's/ +/\t/g' | cut -f 1); chomp $check_index;
    if(($check_count>1) or ($check_index>1)){
	print "$check_count\t$check_index\t$name\t$geno_match\n";
	die "ERROR: phenotype names do not unique match genotype names\n";
    }

    if(($check_count eq 0) or ($check_index eq 0)){
	print "warning $name not found, check count: $check_count\tcheck index: $check_index\n";
    } else{

    my $new_name=qx(grep $name $geno | cut -f 1); chomp $new_name;

    $line=~ s/$name/$new_name/g;

    print PHENO "$line\n";
    print GENO "$geno_match\n";
    print INDEX "$index_match\n";
    }#check for issues otherwise, print out

}#match all names 
