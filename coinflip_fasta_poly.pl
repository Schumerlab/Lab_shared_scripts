#perl! -w

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open infile\n";

my $string=""; my $counter=0;
while(my $line=<IN>){

    chomp $line;
    my @elements=split(//,$line);

    $counter++;
    if ($counter == 1){
	print "$line\n";
    }
    else{
    for $i (0..scalar(@elements)-1){

	my $focal=$elements[$i];
	if ($focal =~ /[ATGCN]/){

	    $string="$string"."$focal";
	}
	elsif($focal eq 'M'){
	    my @array=("A","C");
	    my $new_focal=$array[rand @array];
	    $string="$string"."$new_focal";
	}
	elsif($focal eq 'R'){
            my @array=("A","G");
            my $new_focal=$array[rand @array];
            $string="$string"."$new_focal";
        }
        elsif($focal eq 'W'){
            my @array=("A","T");
            my $new_focal=$array[rand @array];
            $string="$string"."$new_focal";
        }
        elsif($focal eq 'S'){
            my @array=("C","G");
            my $new_focal=$array[rand @array];
            $string="$string"."$new_focal";
        }
	elsif($focal eq 'Y'){
            my @array=("C","T");
            my $new_focal=$array[rand @array];
            $string="$string"."$new_focal";
        }
        elsif($focal eq 'K'){
            my @array=("T","G");
            my $new_focal=$array[rand @array];
            $string="$string"."$new_focal";
        }
    }

    print "$string\n";
    $string="";
    }

}
