#perl! -w

#NOTE: assumes our 10x genomes gtf format and that fastahack is globally installed. Path to shared_bin is hard coded for extract_gtf_seqs_mergetranscript_printstdout_10x_assembly.pl , update as needed

if(@ARGV<6){
    print "perl extract_bir_mal_10x_seqs_run_codeml.pl gene_names xbir.gtf xmal.gtf xbir.fa xmal.fa codeml_ctl_base\n"; exit;
}#print usage

my $gene_list=shift(@ARGV); chomp $gene_list;
open IN, $gene_list or die "cannot open list of single copy genes\n";

my $gtf1=shift(@ARGV); chomp $gtf1;

my $gtf2=shift(@ARGV); chomp $gtf2;

my $fasta1=shift(@ARGV); chomp $fasta1;

my $fasta2=shift(@ARGV); chomp $fasta2;

my $codeml=shift(@ARGV); chomp $codeml;

open LOG, ">"."$gene_list"."_results_log";
open RES, ">"."$gene_list"."_results";

print RES "gene\tt\tSsites\tNsites\tdNdS\tdN\tdS\n";

while(my $line=<IN>){

    chomp $line; my $file1="$line"."_sp1.gtf"; my $file2="$line"."_sp2.gtf";

    system("grep -w $line $gtf1 | grep -v start_codon | grep -v stop_codon > $file1");
    system("grep -w $line $gtf2 | grep -v start_codon | grep -v stop_codon > $file2");
    #system("awk \-F\"\\t\" \'\$10 \=\= \"$line\" \{ print\}\' $gtf1 | grep -v start_codon | grep -v stop_codon > $file1");
    #system("awk \-F\"\\t\" \'\$10 \=\= \"$line\" \{ print\}\' $gtf2 | grep -v start_codon | grep -v stop_codon > $file2");

    my $seq1=qx(perl /home/groups/schumer/shared_bin/Lab_shared_scripts/extract_gtf_seqs_mergetranscript_printstdout_10x_assembly.pl $file1 $fasta1 xbir); chomp $seq1;
    my $seq2=qx(perl /home/groups/schumer/shared_bin/Lab_shared_scripts/extract_gtf_seqs_mergetranscript_printstdout_10x_assembly.pl $file2 $fasta2 xmal); chomp $seq2;

    my $seq1_short=substr($seq1,0,-3);
    my $seq2_short=substr($seq2,0,-3);

    #print "$seq1\n";

    open OUT, ">"."$line"."_aligned".".fa";
    print OUT "$seq1_short\n$seq2_short\n";

    my $align="$line"."_aligned".".fa"; my $out="codeml_"."$line".".out";
    my $pep="$align".".pep"; my $pep_out="$pep".".tr_frame1";

    system("python /home/groups/schumer/shared_bin/Lab_shared_scripts/seqs_processor_and_translator_bin_V118_AGCT.py $align $pep DNA 1 1 NOBIN 20");
    
    my $trans1=qx(cat $pep_out | grep -v '>' | head -n 1); chomp $trans1;
    my $trans2=qx(cat $pep_out | grep -v '>' | tail -n 1); chomp $trans2;

    if((length($trans1) eq length($trans2)) && ($trans1 !~ /\*/) && ($trans2 !~ /\*/)){
    system("perl -pi -e 's/seqfile = \.\*/seqfile = $align/g' $codeml");
    system("perl -pi -e 's/outfile = \.\*/outfile = $out/g' $codeml");

    system("codeml $codeml\n\n");

    my $res=qx(tail -n 1 $out); chomp $res;
    $res=~ s/t=//g; $res=~ s/S=//g; $res=~ s/N=//g; $res=~ s/dN =//g; $res=~ s/dS =//g; $res=~ s/dN//g; $res=~ s/\///g; $res=~ s/dS=//g; $res=~ s/d//g; $res=~ s/ +/\t/g; $res=~ s/\t\t/\t/g; $res=~ s/\t\t/\t/g; 

    print RES "$line$res\n";
    system("rm $out");
    
    }#run codeml if appropriate
    else{
	print LOG "length issue with $line\n";
    }

    my $remove="$line"."_*";
    system("rm $remove");
}#For all genes in list
