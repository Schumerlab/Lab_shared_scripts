#perl! -w

my $infile1=shift(@ARGV); chomp $infile1;
open IN1, $infile1 or die "cannot open fasta species1\n";

my $infile2=shift(@ARGV); chomp $infile2;
open IN2, $infile2 or die "cannot open fasta species2\n";

my $infile3=shift(@ARGV); chomp $infile3;
open IN3, $infile3 or die "cannot open fasta species3\n";

my $sites1="";
my $sites2="";
my $sites3="";
my $pos=0;
my $lg="";
my $focal1="";
my $focal2="";
my $focal3="";
while((my $line1=<IN1>) && (my $line2=<IN2>) && (my $line3=<IN3>)){
    chomp $line1; chomp $line2; chomp $line3;
    if($line1=~ />/){
	$lg=$line1;
	$lg =~ s/>//g;
	#print "$lg\n";
	$pos=0;
    } else{

    my @elements1=split(//,$line1);
    my @elements2=split(//,$line2);
    my @elements3=split(//,$line3);

    if(scalar(@elements1) != scalar(@elements2)){
	die;
    }
    if(scalar(@elements1) != scalar(@elements3)){
        die;
    }
    
    for my $i (0..scalar(@elements1)-1){
	my @bparray=();

	$pos=$pos+1;

	$focal1=$elements1[$i]; chomp $focal1;
	$focal2=$elements2[$i]; chomp $focal2;
	$focal3=$elements3[$i]; chomp $focal3;

	push(@bparray, $focal1);
	push(@bparray, $focal2);
	push(@bparray, $focal3);
#!	my @sortedbp=sort { lc($a) cmp lc($b) } @bparray;

	if(($focal1 ne $focal2) && ($focal1 !~ /[RYSWKMN]/) && ($focal2 !~ /[RYSWKMN]/)){
	    print "$lg"."\t"."$pos"."\t"."$bparray[0]"."\t"."$bparray[1]\n";

	}elsif(($focal1 ne $focal3) && ($focal1 !~ /[RYSWKMN]/) && ($focal3 !~ /[RYSWKMN]/)){
	    print "$lg"."\t"."$pos"."\t"."$bparray[0]"."\t"."$bparray[2]\n";
	}elsif(($focal2 ne $focal3) && ($focal2 !~ /[RYSWKMN]/) && ($focal3 !~ /[RYSWKMN]/)){
	    print "$lg"."\t"."$pos"."\t"."$bparray[1]"."\t"."$bparray[2]\n";
	}#sites are AIMs in genome

    }#for all sites

    }#non-header line

}#for all lines
