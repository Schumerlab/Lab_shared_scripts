#perl! -w

###Matches lab phenotypes file format to genotypes file format, writing out a new matched file for each

###Phenotype format expected:
#header
#indiv1_id\tpheno1\tpheno2\tpheno-n\n
#indiv2_id\tpheno1\tpheno2\tpheno-n\n

###Genotypes format expected:
#header
#indiv1_id\tgeno1\tgeno2\tgeno-n\n
#indiv2_id\tgeno1\tgeno2\tgeno-n\n 

if(@ARGV<2){
    print "perl match_phenotypes_name_list_with_genotypes_file.pl phenotype_file_names_first_column genotypes_file\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open phenotypes file\n";

my $pheno_header=<IN>; chomp $pheno_header;

my $geno=shift(@ARGV); chomp $geno;

my $geno_header=qx(head -n 1 $geno); chomp $geno_header;

open PHENO, ">"."$list"."_matched_to_"."$geno";
open GENO, ">"."$geno"."_matched_to_"."$list";

print GENO "$geno_header\n";
print PHENO "$pheno_header\n";
while(my $line=<IN>){
    chomp $line;
    my @elements=split(/\t/,$line);
    my $name=$elements[0]; chomp $name;

    my $geno_match=qx(grep $name $geno); chomp $geno_match;

    my $new_name=qx(grep $name $geno | cut -f 1); chomp $new_name;

    $line=~ s/$name/$new_name/g;

    print PHENO "$line\n";
    print GENO "$geno_match\n";
}#match all names 
