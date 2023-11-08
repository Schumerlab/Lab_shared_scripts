import argparse
import subprocess

parser = argparse.ArgumentParser(description="This script will convert a mappability mask in .fasta format to a .bed file.\nSee the following workflow for generating the mappability mask: https://lh3lh3.users.sourceforge.net/snpable.shtml.\nThis script was adapted from msmc-tools (https://github.com/stschiff/msmc-tools/blob/master/makeMappabilityMask.py)",
	formatter_class = argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument("-m", "--mask", help="name of maskfile.fasta", required=True)
parser.add_argument("-o", "--outfile", help="outfile.bed name", required=True)

args = parser.parse_args()

outfile_name = args.outfile
maskfile = args.mask

# sketchy way to get number of lines in the mask fasta but every other way seems to get in the way of writing to the outfile
# I literally have no idea -- any solution that includes readlines() just breaks
mask_length = str.split(str(subprocess.check_output(['wc','-l',maskfile])))
mask_length = int(mask_length[1])


# initialize or overwrite outfile 
# this will make it such that, if you accidentally run the script twice on the same file, it will overwrite the file instead of appending to it
outfile = open(outfile_name, 'w')
outfile.write('')
outfile.close()

def main():

	with open(maskfile, 'r') as f:

		# track whether the current position is in a chunk of 3s or not - intially set to false
		in_threechunk = False

		# initialize count to track what line number we're on
		count = 0

		#iterate over lines
		for line in f:
			
			# increment count for each line in the fasta (this is just to determine when it reaches the last line of the file)
			count += 1

			# if line is the beginning of a chrom/scaffold
			if line.startswith('>'):

				# if the previous fasta entry ended in a 3chunk, first close the 3chunk and write it to outfile
				if in_threechunk == True:

					in_threechunk = False
					write_3chunk(curr_chrom, threechunk_start, threechunk_end)
					
					# then start tracking a new fasta entry
					curr_chrom = line.split()[0][1:]
					# keep track of current position for a given fasta entry
					pos = 0
					# initialize the start and end coordinates for a chunk of bases with mappability scores == 3
					threechunk_start = 0
					threechunk_end = 0

				# if not in a 3chunk, just start tracking a new fasta entry
				elif in_threechunk == False:
					curr_chrom = line.split()[0][1:]
					# keep track of current position for a given chrom/scaffold
					pos = 0
					# initialize the start and end coordinates for a chunk of bases with mappability scores == 3
					threechunk_start = 0
					threechunk_end = 0

			# for each base in a non-header line
			else:
				
				#keep track of position in line
				c_count = 0

				# iterate over each character in the line (excluding \n's -- hence line.strip())
				for c in line.strip():
					# keep track of line length
					c_count += 1 

					# increment the number of bases in the chromosome
					pos += 1

					# start 3chunk if there's a c == 3
					if c == "3" and in_threechunk == False:
						# set threechunk_start and end to the current position
						threechunk_start = pos
						threechunk_end = pos
						# store the info that we're now in a chunk of threes
						in_threechunk = True
					
					# if we're already in a 3 chunk, just add to the current chunk (for everything but the last fasta entry)
					elif c == "3" and in_threechunk == True:
						threechunk_end += 1

					# when we end a 3 chunk, write the coordinates to the outfile and reset in_threechunk to False
					elif c != "3" and in_threechunk == True:

						write_3chunk(curr_chrom, threechunk_start, threechunk_end)
						in_threechunk = False

					# for the last character in the last line, if it ends in a 3, write the coordinates to the file:
					if c == "3" and in_threechunk == True and count == mask_length and c_count == len(line.strip()):
						write_3chunk(curr_chrom, threechunk_start, threechunk_end)

def write_3chunk(chr, start, end):
	outfile = open(outfile_name, 'a')
	outfile.write('{}\t{}\t{}\n'.format(chr,start,end))    
	outfile.close()

if __name__ == '__main__':
	main()
