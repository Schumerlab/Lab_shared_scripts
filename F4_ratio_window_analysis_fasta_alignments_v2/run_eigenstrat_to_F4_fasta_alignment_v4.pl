#perl! -w

if(@ARGV<3){
    print "perl run_eigenstrat_to_F4_fasta_alignment_v3.pl fasta_alignment indiv_file_convertf snp_window_size\n"; exit;
}#print usage

    my $seqfasta=shift(@ARGV); chomp $seqfasta;
    my $indivs=shift(@ARGV); chomp $indivs;
    my $snpwin=shift(@ARGV); chomp $snpwin;

    my $outfile="$seqfasta".".variant.fa";
    my $coords="$seqfasta".".variant.coords";
    my $reformat="$seqfasta".".variant.reformat.coords";
    my $phy="$reformat".".variant.phy";

    system("perl -pi -e 's/ //g' $seqfasta");

    system("Variable_sites_extractor_mod.py -v $seqfasta -o $outfile");
    system("Variable_sites_extractor_mod.py -v -c $seqfasta -o $coords");
    system("cat $coords | tail -n +2 | perl -p -e 's/,/\n/g' > $reformat");
    system("Rscript coords_to_map.R $reformat");

    open LIST, $indivs or die "cannot open individuals file\n";
    my @indivlist=();
    while(my $line=<LIST>){
	chomp $line;
	$line =~ s/ +/\t/g;
	my @elements=split(/\t/,$line);
	my $id=$elements[0];
	print "resorting $id\n";
	push(@indivlist,$elements[0]);
    }#process list

    my $tmp="$outfile".".tmp";
    open OUT, ">$tmp";
    for my $i (0..scalar(@indivlist)-1){
	my $focal=$indivlist[$i];
	my $seq=qx(grep -wA 1 $focal $outfile); chomp $seq;
	print OUT "$seq\n";
    }#reformat outfile

    system("mv $tmp $outfile");
    system("perl Fasta2Phylip.pl $outfile > $phy");
    system("perl -pi -e 's/-//g' $phy");
    system("perl convert_phy_to_plink_F4.pl $phy");

    my $find="REPLACE";
    my $replace="$reformat";
    system("cp parfile_convertf_alignment parfile_convertf_alignment_focal");
    #print "perl -pi -e 's/$find/$replace/g' parfile_convertf_alignment_focal\n";
    system("perl -pi -e 's/$find/$replace/g' parfile_convertf_alignment_focal");
    system("perl -pi -e 's/INDIVSUB/$indivs/g' parfile_convertf_alignment_focal");
    system("convertf -p parfile_convertf_alignment_focal");

    my $in1="$reformat".".ped.eigen";
    my $in2="$reformat".".map.eigen";
    my $in3="$reformat".".indiv.eigen";
    system("perl run_F4_snpwindows_v2_alignment.pl $in1 $in2 $in3 $snpwin");
    
#cleanup
system("rm parfile_convertf_alignment_focal alignment.eigen.indiv alignment.map.eigen.currwindow alignment.ped.eigen.currwindow");
