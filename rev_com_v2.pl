#!/usr/bin/perl


#       rev_com.pl
#       
#       Copyright 2011 Benjamin Tovar <scenesfromamemory4@gmail.com>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
#
################################################################################
#
# NAME OF THE PROGRAM: rev_com.pl
# DATE: 01/Jun/2011
# AUTHOR: Benjamin Tovar
# COMMENTS: Little script that can be used for the computation of 
# the reverse complement of a DNA string and then export the resulting string
# to a file in Fasta format with fasta headers (even if the original file was not)
#
################################################################################

use warnings;
use strict;

#### script introduction

#!print "\n\n-------------------------------------------------------------\n\n";

#!print "PROGRAM DEFINITION: rev_com.pl <- PERL SCRIPT WRITTEN BY BENJAMIN TOVAR
#!THAT COMPUTES THE REVERSE COMPLEMENT OF DNA STRINGS AND EXPORT THE RESULTS TO AN 
#!OUTPUT FILE IN FASTA FORMAT (EVEN IF THE ORIGINAL FILE WAS NOT)\n\n";

#!print "This program will ask the user to type the name of the file 
#!(if the file name has an extension, write it please) that contains the DNA sequence\n\n";

#### Ask the user for the name of the file

#!print "Please, type the complete name of the file:\n\n";
if(@ARGV<1){
    print "perl rev_com_v2.pl infile.fa\n"; exit;
}#print usage

my $user_in =shift(@ARGV);

### Remove empty spaces

chomp $user_in;

### Open the file

open(INPUT_FILE,$user_in) or die "\n\n WARNING: The file does not exist, please check the spelling, the extension and the existence of the file\n\n";

### Copy the content of the file to an array variable called "@input_file"

my @input_file = <INPUT_FILE>;

### Remove the Fasta header and extract the DNA sequence

my $input_file = extract_sequence_from_fasta_data(@input_file);

### Close the opened file

close INPUT_FILE;

### Compute the reverse DNA string

my $rev_com = reverse ($input_file);

### Compute the complement DNA string

$rev_com =~ tr/ATGCatgc/TACGtacg/;

### Compute the length of the input DNA string

my $length = length ($input_file);

############## RESULTS #################################################

#!print "\n----------- RESULTS --------------\n\n";

print "Input file string of length $length:\n\n";

#!print $input_file,"\n";

print "\nOutput reverse complement of the DNA string:\n\n";

#!print $rev_com, "\n\n";

############## EXPORTING THE RESULTS TO A FILE IN FASTA FORMAT #########

######################## Naming the output file: #######################

### sdfgh

my $fasta_header_name = extract_fasta_header_name(@input_file);

## Remove the input file extension

$user_in =~ s/\..*//; 

# Concatenate the name of the file (without the .fa/.fasta extension) with "-rev_com.fa"

my $rev_com_name = "-revcom.fa";

my $output_name = $user_in . $rev_com_name;

# Name of the output file

my $out = "$output_name";

# Set the file handle "OUTPUT".

open (OUTPUT, ">$out"); 

# Print the results (content) of the variable "$rev_com" (this variable contains the reverse complement string) 
# into a file named "$output_name" and put the Fasta header before the output DNA string with "$fasta_header_name","-reverse_complementary\n"

print OUTPUT "$fasta_header_name","-reverse_complement\n","$rev_com";


print "-------- EXPORT THE RESULTS TO A FILE IN FASTA FORMAT ----------\n";
print "\nThe output string has been exported to the file \"$output_name\"\n\n";

exit;

################################################################################
############################### SUBROUTINES ####################################
################################################################################


################################################################################
# extract_fasta_header_name
# A subroutine to extract the FASTA header of the original input file
# and use it to name the FASTA header of the output file
################################################################################

sub extract_fasta_header_name{

    my(@fasta_file_data) = @_;

    use strict;
    use warnings;

    # Declare and initialize variables
    my $fasta_header_name = '';

    foreach my $line (@fasta_file_data) {
    
        if($line =~ /^>/) {
            
            $fasta_header_name = $line;
    
    # If the file is not in Fasta format, use the name of the file to name the fasta header           
        } else {
        
            $fasta_header_name = ">$user_in";
        
        }
        
    # Remove non-sequence data (in this case, whitespace) from $fasta_header_name string
        $fasta_header_name =~ s/\s//g;
        
    # Export the results of the subroutine to the main program    
        return $fasta_header_name;
        
    }
}

################################################################################
# extract_sequence_from_fasta_data
# A subroutine to extract FASTA sequence data from an array
# taken from James Tisdall's Beginning Perl for Bioinformatics
################################################################################

sub extract_sequence_from_fasta_data {

    my(@fasta_file_data) = @_;

    use strict;
    use warnings;

    # Declare and initialize variables
    my $sequence = '';

    foreach my $line (@fasta_file_data) {

        # discard blank line
        if ($line =~ /^\s*$/) {
            next;

        # discard comment line
        } elsif($line =~ /^\s*#/) {
            next;

        # discard fasta header line
        } elsif($line =~ /^>/) {
            next;

        # keep line, add to sequence string
        } else {
            $sequence .= $line;
        }
    }

    # remove non-sequence data (in this case, whitespace) from $sequence string
    $sequence =~ s/\s//g;

    return $sequence;
}
