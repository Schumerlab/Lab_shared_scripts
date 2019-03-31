#perl! -w

if(@ARGV<1){
    print "perl rm_list.pl list_of_files_to_remove\n"; exit;
}#print usage

my $list=shift(@ARGV); chomp $list;
open IN, $list or die "cannot fine $list\n";

while(my $line=<IN>){

    chomp $line;
    system("rm $line");

}#for all entries
