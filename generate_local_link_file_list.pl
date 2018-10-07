#perl! -w

#link to files contained in a list

if(@ARGV<1){
    print "perl generate_local_link_file_list.pl infile_list\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list infile\n";

while(my $line=<IN>){

    chomp $line;
    system("ln -s $line ./");

}#for all files in list
