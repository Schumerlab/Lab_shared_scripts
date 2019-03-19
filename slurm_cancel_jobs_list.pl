#perl! -w

#NOTE: slurm jobs list can either be a list of job numbers or a list of slurm file names, e.g.:

#option1:
#slurm-35463367.out
#slurm-35463369.out
#slurm-35463371.out

#option2:
#35463367
#35463369
#35463371

if(@ARGV<1){
    print "perl slurm_cancel_jobs_list.pl cancel_jobs_list\n"; exit;
}#print usage

my $infile=shift(@ARGV); chomp $infile;
open IN, $infile or die "cannot open list of slurm jobs\n";

while(my $line=<IN>){

    chomp $line;
    $line=~ s/slurm-//g;
    $line=~ s/\.out//g;

    system("scancel $line");

}
