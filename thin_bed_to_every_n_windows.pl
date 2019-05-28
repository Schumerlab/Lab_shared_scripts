#perl! -w

#purpose: thin a bed file to every n windows where n is a user defined integer
#restarts thinning on window 1 of each chromosome

if(@ARGV<2){
    print "perl thin_to_every_n_windows.pl file.bed retain_every_n\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open $infile\n";

my $retain=shift(@ARGV); chomp $retain;

open OUT, ">"."$infile"."_thinned_by"."$retain".".bed";

my $count=0;
my $index=0;
my $chr_prev="";
while(my $line=<IN>){

    $index++; 

    chomp $line;
    my @elements=split(/\t/,$line);

    my $chr=$elements[0];

    $count++;

    if($index eq 1){
	$chr_prev=$chr;
	$count=$retain;
    }#first line

    if(($count eq $retain) or ($chr ne $chr_prev)){

	print OUT "$line\n";
	$count=0;
    }#check if we should print this line

    $chr_prev=$chr;

}#for all lines
