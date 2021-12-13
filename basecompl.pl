#!/usr/bin/perl

use strict;
use warnings;

my %seqs;
$/ = "\n>"; # read fasta by sequence, not by lines

while (<>) {
    s/>//g;
    my ($seq_id, @seq) = split (/\n/, $_);
    my $seq = uc(join "", @seq); # rebuild sequence as a single string
    my $len = length $seq;
    my $numA = $seq =~ tr/A//; # removing A's from sequence returns total counts
    my $numC = $seq =~ tr/C//;
    my $numG = $seq =~ tr/G//;
    my $numT = $seq =~ tr/T//;
    print "$seq_id: Size=$len  A=$numA  C=$numC  G=$numG  T=$numT\n";
}
