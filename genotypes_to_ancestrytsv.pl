#perl! -w

if(@ARGV<1){
    print "perl genotypes_to_ancestrytsv.pl genotypes_file\n"; exit;
}#usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open genotypes file\n";

open OUT1, ">$infile"."_ancestry_par1.tsv";
open OUT2, ">$infile"."_ancestry_par2.tsv";

open OUT3, ">samples_to_include";

my $header=<IN>; chomp $header;

$header=~s/id\t//g;

print OUT1 "\t$header\n";
print OUT2 "\t$header\n";

my $counter=0;
while (my $line=<IN>){
    chomp $line;

    $counter++;

    my @genotypes=split(/\t/,$line);

    print OUT1 "$genotypes[0]","\t";
    print OUT2 "$genotypes[0]","\t";
    print OUT3 "A","\t","$genotypes[0]","\n";

#    print OUT1 "indiv"."$counter\t";
#    print OUT2 "indiv"."$counter\t";
#    print OUT3 "A\tindiv"."$counter\n";

    for my $i (1..scalar(@genotypes)-1){

	my $focal_geno=$genotypes[$i];
	if (($focal_geno eq 'NA')&&($i != (scalar(@genotypes)-1))){
	    print OUT1 "NA\t";
	    print OUT2 "NA\t";
	}
	elsif(($focal_geno == 0)&&($i != (scalar(@genotypes)-1))){
	    print OUT1 "1\t";
	    print OUT2 "0\t";
	}
	elsif(($focal_geno ==1)&&($i != (scalar(@genotypes)-1))){
            print OUT1 "0\t"; 
            print OUT2 "0\t";
	}
	elsif(($focal_geno==2)&&($i != (scalar(@genotypes)-1))){
	print OUT1 "0\t";
	print OUT2 "1\t";
	}
	elsif(($focal_geno eq 'NA')&&($i == (scalar(@genotypes)-1))){
            print OUT1 "NA\n";
            print OUT2 "NA\n";
        }
        elsif(($focal_geno == 0)&&($i == (scalar(@genotypes)-1))){
            print OUT1 "1\n";
            print OUT2 "0\n";
        }
        elsif(($focal_geno ==1)&&($i == (scalar(@genotypes)-1))){
            print OUT1 "0\n";
            print OUT2 "0\n";
        }
        elsif(($focal_geno==2)&&($i == (scalar(@genotypes)-1))){
	    print OUT1 "0\n";
	    print OUT2 "1\n";
        }

    }
    
}

my $file1="$infile"."_ancestry_par1.tsv"; my $file2="$infile"."_ancestry_par2.tsv";

#system("perl -pi -e 's/NA/0.33/g' $file1");
#system("perl -pi -e 's/NA/0.33/g' $file2");
#replace NAs with ambiguous calls that are compatible with php script
