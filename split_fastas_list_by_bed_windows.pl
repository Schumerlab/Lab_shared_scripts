#perl! -w

#Note: list file format is the following:
#myinfile1.fa\nmyinfile2.fa

if(@ARGV<2){
    print "\nperl split_fastas_list_by_bed_windows.pl list_of_fasta_and_focal_scaff windows.bed path_to_folder_w_fastahack\n\nlist format: myinfile1.fa\nmyinfile2.fa\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot open list file\n";

my $bed=shift(@ARGV); chomp $bed;

my $path=shift(@ARGV); chomp $path;

if(length($path)>0){
    $path="$path/fastahack";
}else{
    $path="fastahack";
}#set path

my @fasta_files=();
while(my $line1=<IN>){
    chomp $line1;
    push(@fasta_files,$line1);
}#for all lines

#print "@fasta_files"."\n";

for my $i (0..scalar(@fasta_files)-1){

    my $focal_file=$fasta_files[$i];
    open BED, $bed or die "cannot open bed file\n";
#    print "$focal_file\n";

while(my $line2=<BED>){

    chomp $line2;
    my @info=split(/\t/,$line2);
    my $chrom=$info[0];
    my $start=$info[1];
    my $stop=$info[2];
 #   print "$focal_file\t$start\t$stop\n";

    open OUT, ">"."$focal_file"."_"."$start"."_"."$stop".".fa";
    my $seq=qx($path $focal_file -r $chrom:$start..$stop); chomp $seq;

 #   print "$chrom"."_"."$start"."_"."$stop\n";
    print OUT ">"."$chrom"."_"."$start"."_"."$stop\n";
    print OUT "$seq\n";

}#for all bed windows

}#for all files 
