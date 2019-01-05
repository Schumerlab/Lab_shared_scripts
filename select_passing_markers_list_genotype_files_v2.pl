#perl! -w

if(@ARGV<4){
    print "perl select_passing_markers_multi_geno_files_v2.pl list_of_markers_to_select genotypes_file path_to:transpose_nameout.pl outfile_name\n"; exit;
}#print usage

my $f1=shift(@ARGV); chomp $f1;
open F1, $f1 or die "cannot open file1\n";
my $f2t=shift(@ARGV); chomp $f2t;
my $path=shift(@ARGV); chomp $path;

system("perl $path/transpose_nameout.pl $f2t");

my $f2="$f2t"."_transposed";
open F2, $f2 or die "cannot open file2\n";
my $outfile=shift(@ARGV); chomp $outfile;

my $tmp="tmp_"."$outfile";
open OUT, ">$tmp";

$col1=0;
$col2=0;
my $header=<F2>; chomp $header;
print OUT "\t$header\n";
while (<F2>) {
    s/\r?\n//;
    @F=split /\t/, $_;
    $line2{$F[$col2]} .= "$_\n"
};
$count2 = $.;

while (<F1>) {
    s/\r?\n//;
    @F=split /\t/, $_;
    $x = $line2{$F[$col1]};
    if ($x) {
	$num_changes = ($x =~ s/^/$_\t/gm);
	print OUT $x;
	$merged += $num_changes
    }
}

my $outfile_trans="$tmp"."_trim";
system("cut -f 1 --complement $tmp > $outfile_trans");
system("perl $path/transpose_nameout.pl $outfile_trans");
my $outfile_curr="$outfile_trans"."_transposed";
system("mv $outfile_curr $outfile");
system("rm $tmp $outfile_trans");
