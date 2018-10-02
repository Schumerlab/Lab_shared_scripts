#!/usr/bin/python

########################
# COPYRIGHT 2005,2006  #
# Alexander Kozik      #
# http://www.atgc.org/ #
# akozik@atgc.org      #
########################

def HelpTranslation():

	print ""
	print "   SEQS PROCESSOR HELP:   "
	print "   -------------------    "

	help_text = """
   Input file must be in FASTA format. Description of output:

   if no translation frame is chosen "0" then four output files will be generated:
   1. *.fasta - contains processed sequences in FASTA format
   2. *.stat  - contains information about GC% content per sequence
   3. *.tab   - tab delimited file with sequences
   4. *.01BIN - binary DNA representation (A-00 T-11 G-01 C-10)

   if first translation frame is chosen "1" then eleven output files will be generated:
   1. *.fasta - contains processed sequences in FASTA format
   2. *.forwrd - forward orientation, all non ATGCN letters replaced by "N"
   3. *.revcom - reverse-compliment orientation based on "forward" sequences
   4. *.stat  - contains information about GC% content per sequence
   5. *.tab   - tab delimited file with sequences
   6. *.tr_frame1 - translated sequences - frame 1
   7. *.tr_longest_frame - extracted longest frame
   8. *.tr_single_frame - extracted sequences with single ORF
   9. *.x0_log - log file with general info and error messages
  10. *.x1_log - log file with statistical info about translation - frame 1
  11. *.01BIN - binary DNA representation (A-00 T-11 G-01 C-10)

   if three translation frames are chosen "3" then sixteen output files will be generated:
   1. *.fasta - contains processed sequences in FASTA format
   2. *.forwrd - forward orientation, all non ATGCN letters replaced by "N"
   3. *.revcom - reverse-compliment orientation based on "forward" sequences
   4. *.stat  - contains information about GC% content per sequence
   5. *.tab   - tab delimited file with sequences
   6. *.tr_frame1 - translated sequences - frame 1
   7. *.tr_frame2 - translated sequences - frame 2
   8. *.tr_frame3 - translated sequences - frame 3
   9. *.tr_longest_frame - extracted longest frame
  10. *.tr_single_frame - extracted sequences with single ORF
  11. *.x0_log - log file with general info and error messages
  12. *.x1_log - log file with statistical info about translation - frame 1
  13. *.x2_log - log file with statistical info about translation - frame 2
  14. *.x3_log - log file with statistical info about translation - frame 3
  15. *.xx_log - log file with statistical info about all three translation ORFs
  16. *.01BIN - binary DNA representation (A-00 T-11 G-01 C-10)

   if six translation frames are chosen "6" then twenty two output files will be generated:
   1. *.fasta - contains processed sequences in FASTA format
   2. *.forwrd - forward orientation, all non ATGCN letters replaced by "N"
   3. *.revcom - reverse-compliment orientation based on "forward" sequences
   4. *.stat  - contains information about GC% content per sequence
   5. *.tab   - tab delimited file with sequences
   6. *.tr_frame1 - translated sequences - frame 1
   7. *.tr_frame2 - translated sequences - frame 2
   8. *.tr_frame3 - translated sequences - frame 3
   9. *.tr_frame4 - translated sequences - frame 4
  10. *.tr_frame5 - translated sequences - frame 5
  11. *.tr_frame6 - translated sequences - frame 6
  12. *.tr_longest_frame - extracted longest frame
  13. *.tr_single_frame - extracted sequences with single ORF
  14. *.x0_log - log file with general info and error messages
  15. *.x1_log - log file with statistical info about translation - frame 1
  16. *.x2_log - log file with statistical info about translation - frame 2
  17. *.x3_log - log file with statistical info about translation - frame 3
  18. *.x4_log - log file with statistical info about translation - frame 4
  19. *.x5_log - log file with statistical info about translation - frame 5
  20. *.x6_log - log file with statistical info about translation - frame 6
  21. *.xx_log - log file with statistical info about all six translation ORFs
  22. *.01BIN - binary DNA representation (A-00 T-11 G-01 C-10)

  Note, log files must be viewed using Excel like spreadsheet editor

"""

	print help_text

def CodonTranslation1():

	### STANDARD TRANSLATION ###

	print ""
	print "TRANSLATION TABLE 1"
	print ""

	time.sleep(2)

	global  gl_Ter 
	global  gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
		gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
		gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
		gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly 
	global  gl_Any

	global  gl_AmAcLib

	gl_Ter = [ "TAA", "TAG", "TGA" ]

	gl_Phe = [ "TTT", "TTC" ]
	gl_Leu = [ "TTA", "TTG", "CTT", "CTC", "CTA", "CTG", "CTN" ]
	gl_Ser = [ "TCT", "TCC", "TCA", "TCG", "TCN", "AGT", "AGC" ]
	gl_Tyr = [ "TAT", "TAC" ]
	gl_Cys = [ "TGT", "TGC" ]

	gl_Trp = [ "TGG" ]
	gl_Pro = [ "CCT", "CCC", "CCA", "CCG", "CCN" ]
	gl_His = [ "CAT", "CAC" ]
	gl_Gln = [ "CAA", "CAG" ]
	gl_Arg = [ "CGT", "CGC", "CGA", "CGG", "CGN", "AGA", "AGG" ]

	gl_Ile = [ "ATT", "ATC", "ATA" ]
	gl_Met = [ "ATG" ]
	gl_Thr = [ "ACT", "ACC", "ACA", "ACG", "ACN" ]
	gl_Asn = [ "AAT", "AAC" ]
	gl_Lys = [ "AAA", "AAG" ]

	gl_Val = [ "GTT", "GTC", "GTA", "GTG", "GTN" ]
	gl_Ala = [ "GCT", "GCC", "GCA", "GCG", "GCN" ]
	gl_Asp = [ "GAT", "GAC" ]
	gl_Glu = [ "GAA", "GAG" ]
	gl_Gly = [ "GGT", "GGC", "GGA", "GGG", "GGN" ]

	gl_Any = [ "AAN", "ATN", "AGN", \
		   "TAN", "TTN", "TGN", \
		   "GAN", \
		   "CAN", \
		   "ANA", "ANT", "ANG", "ANC", \
		   "TNA", "TNT", "TNG", "TNC", \
		   "GNA", "GNT", "GNG", "GNC", \
		   "CNA", "CNT", "CNG", "CNC", \
		   "NAA", "NAT", "NAG", "NAC", \
		   "NTA", "NTT", "NTG", "NTC", \
		   "NGA", "NGT", "NGG", "NGC", \
		   "NCA", "NCT", "NCG", "NCC", \
		   "NNA", "NNT", "NNG", "NNC", \
		   "ANN", "TNN", "GNN", "CNN", \
		   "NAN", "NTN", "NGN", "NCN", \
		   "NNN" ]
	######################################
	gl_AmAcLib =  [ gl_Ter, \
			gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
			gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
			gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
			gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly, \
			gl_Any ]
	######################################

def CodonTranslation2():

	### Vertebrate Mitochondrial ###

	#####################################
	#
	# Differences from the Standard Code:
	#
	#    Code 2             Standard
	#
	# AGA    Ter  *          Arg  R
	# AGG    Ter  *          Arg  R
	# AUA    Met  M          Ile  I
	# UGA    Trp  W          Ter  *
	#
	#####################################

	print ""
	print "TRANSLATION TABLE 2"
	print ""

	time.sleep(2)

	global  gl_Ter 
	global  gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
		gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
		gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
		gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly 
	global  gl_Any

	global  gl_AmAcLib

	gl_Ter = [ "TAA", "TAG", "AGA", "AGG" ]

	gl_Phe = [ "TTT", "TTC" ]
	gl_Leu = [ "TTA", "TTG", "CTT", "CTC", "CTA", "CTG", "CTN" ]
	gl_Ser = [ "TCT", "TCC", "TCA", "TCG", "TCN", "AGT", "AGC" ]
	gl_Tyr = [ "TAT", "TAC" ]
	gl_Cys = [ "TGT", "TGC" ]

	gl_Trp = [ "TGG", "TGA" ]
	gl_Pro = [ "CCT", "CCC", "CCA", "CCG", "CCN" ]
	gl_His = [ "CAT", "CAC" ]
	gl_Gln = [ "CAA", "CAG" ]
	gl_Arg = [ "CGT", "CGC", "CGA", "CGG", "CGN" ]

	gl_Ile = [ "ATT", "ATC" ]
	gl_Met = [ "ATG", "ATA" ]
	gl_Thr = [ "ACT", "ACC", "ACA", "ACG", "ACN" ]
	gl_Asn = [ "AAT", "AAC" ]
	gl_Lys = [ "AAA", "AAG" ]

	gl_Val = [ "GTT", "GTC", "GTA", "GTG", "GTN" ]
	gl_Ala = [ "GCT", "GCC", "GCA", "GCG", "GCN" ]
	gl_Asp = [ "GAT", "GAC" ]
	gl_Glu = [ "GAA", "GAG" ]
	gl_Gly = [ "GGT", "GGC", "GGA", "GGG", "GGN" ]

	gl_Any = [ "AAN", "ATN", "AGN", \
		   "TAN", "TTN", "TGN", \
		   "GAN", \
		   "CAN", \
		   "ANA", "ANT", "ANG", "ANC", \
		   "TNA", "TNT", "TNG", "TNC", \
		   "GNA", "GNT", "GNG", "GNC", \
		   "CNA", "CNT", "CNG", "CNC", \
		   "NAA", "NAT", "NAG", "NAC", \
		   "NTA", "NTT", "NTG", "NTC", \
		   "NGA", "NGT", "NGG", "NGC", \
		   "NCA", "NCT", "NCG", "NCC", \
		   "NNA", "NNT", "NNG", "NNC", \
		   "ANN", "TNN", "GNN", "CNN", \
		   "NAN", "NTN", "NGN", "NCN", \
		   "NNN" ]
	######################################
	gl_AmAcLib =  [ gl_Ter, \
			gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
			gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
			gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
			gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly, \
			gl_Any ]
	######################################

def CodonTranslation3():

	### Yeast Mitochondrial ###

	#####################################
	#
	# Differences from the Standard Code:
	#
	#    Code 3             Standard
	#
	# AUA    Met  M          Ile  I
	# CUU    Thr  T          Leu  L
	# CUC    Thr  T          Leu  L
	# CUA    Thr  T          Leu  L
	# CUG    Thr  T          Leu  L
	# UGA    Trp  W          Ter  *
	#
	# CGA    absent          Arg  R
	# CGC    absent          Arg  R
	#
	#####################################

	print ""
	print "TRANSLATION TABLE 3"
	print ""

	time.sleep(2)

	global  gl_Ter 
	global  gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
		gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
		gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
		gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly 
	global  gl_Any

	global  gl_AmAcLib

	gl_Ter = [ "TAA", "TAG" ]

	gl_Phe = [ "TTT", "TTC" ]
	gl_Leu = [ "TTA", "TTG" ]
	gl_Ser = [ "TCT", "TCC", "TCA", "TCG", "TCN", "AGT", "AGC" ]
	gl_Tyr = [ "TAT", "TAC" ]
	gl_Cys = [ "TGT", "TGC" ]

	gl_Trp = [ "TGG", "TGA" ]
	gl_Pro = [ "CCT", "CCC", "CCA", "CCG", "CCN" ]
	gl_His = [ "CAT", "CAC" ]
	gl_Gln = [ "CAA", "CAG" ]
	# gl_Arg = [ "CGT", "CGC", "CGA", "CGG", "CGN", "AGA", "AGG" ]
	gl_Arg =   [ "CGT",               "CGG", "CGN", "AGA", "AGG" ]

	gl_Ile = [ "ATT", "ATC" ]
	gl_Met = [ "ATG", "ATA" ]
	gl_Thr = [ "ACT", "ACC", "ACA", "ACG", "ACN", "CTT", "CTC", "CTA", "CTG", "CTN" ]
	gl_Asn = [ "AAT", "AAC" ]
	gl_Lys = [ "AAA", "AAG" ]

	gl_Val = [ "GTT", "GTC", "GTA", "GTG", "GTN" ]
	gl_Ala = [ "GCT", "GCC", "GCA", "GCG", "GCN" ]
	gl_Asp = [ "GAT", "GAC" ]
	gl_Glu = [ "GAA", "GAG" ]
	gl_Gly = [ "GGT", "GGC", "GGA", "GGG", "GGN" ]

	gl_Any = [ "AAN", "ATN", "AGN", \
		   "TAN", "TTN", "TGN", \
		   "GAN", \
		   "CAN", \
		   "ANA", "ANT", "ANG", "ANC", \
		   "TNA", "TNT", "TNG", "TNC", \
		   "GNA", "GNT", "GNG", "GNC", \
		   "CNA", "CNT", "CNG", "CNC", \
		   "NAA", "NAT", "NAG", "NAC", \
		   "NTA", "NTT", "NTG", "NTC", \
		   "NGA", "NGT", "NGG", "NGC", \
		   "NCA", "NCT", "NCG", "NCC", \
		   "NNA", "NNT", "NNG", "NNC", \
		   "ANN", "TNN", "GNN", "CNN", \
		   "NAN", "NTN", "NGN", "NCN", \
		   "NNN" ]
	######################################
	gl_AmAcLib =  [ gl_Ter, \
			gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
			gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
			gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
			gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly, \
			gl_Any ]
	######################################

def Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code):

	abc_list =     ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', \
			'J','K','L','M','N','O','P','Q','R','S','T', \
			'U','V','W','X','Y','Z']
	bad_list =     [     'B',      'D', 'E', 'F',      'H', 'I', \
			'J','K','L','M',    'O','P','Q','R','S',     \
			'U','V','W','X','Y','Z'] # REMOVED A T G C N

	global  gl_Ter 
	global  gl_Phe, gl_Leu, gl_Ser, gl_Tyr, gl_Cys, \
		gl_Trp, gl_Pro, gl_His, gl_Gln, gl_Arg, \
		gl_Ile, gl_Met, gl_Thr, gl_Asn, gl_Lys, \
		gl_Val, gl_Ala, gl_Asp, gl_Glu, gl_Gly 
	global  gl_Any

	global  gl_AmAcLib

	global  gl_tr_file1, gl_tr_file2, gl_tr_file3, \
		gl_tr_file4, gl_tr_file5, gl_tr_file6, \
		gl_fw_file7, gl_rc_file8, gl_l0_file9, \
		gl_l1_file9, gl_l2_file9, gl_l3_file9, \
		gl_l4_file9, gl_l5_file9, gl_l6_file9, \
		gl_ls_file9, gl_s_file10, gl_l_file10, \
		tab_out1, tab_out2

	### DEBUGGING ###
	# print proper_id + "   " + "FRAME: " + `trans_fr` + " -=- GENE_CODE: " + `gen_code`

	t = have_seqs			# DNA sequence
	t = string.upper(t)		# all uppercase
	t = re.sub("-", "", t)		# remove all dashes
	t = list(t)			# string -> list of chars
	#########################################################
	###         ONLY A T G C N ARE ALLOWED                ###
	###      EVERYTHING ELSE IS REPLACED BY "N"           ###
	mooba = 0	# COUNTER OF ALL LETTERS
	booba = 0	# COUNTER OF BAD LETTERS
	for item in t:
		if item in bad_list:
			t[mooba] = "N"
			booba = booba + 1
		mooba = mooba + 1
	#########################################################
	t_r = t[:]			# will be reverse string
	t_r.reverse()			# inplace reverse the list
	t   = string.join(t,   '')	# list of strings -> forward string
	t_r = string.join(t_r, '')	# list of strings -> reverse string
	#########################################
	t_r = re.sub("A", "t", t_r)	# A -> t
	t_r = re.sub("T", "a", t_r)	# T -> a
	t_r = re.sub("G", "c", t_r)	# G -> c
	t_r = re.sub("C", "g", t_r)	# C -> g
	###   NOTE THAT "N" REMAINS AS "N"    ###
	#########################################
	t_r = string.upper(t_r)	# back to uppercase
	#########################################
	l = len(t)
	# print l
	l_r = len(t_r)
	gl_fw_file7.write(">" + proper_id + " forward "  + `l`   + " nt" + '\n' + t   + '\n')
	gl_rc_file8.write(">" + proper_id + " rev-comp " + `l_r` + " nt" + '\n' + t_r + '\n')
	tab_out1.write(proper_id + '\t' + `l` + '\t' + t + '\n')
	tab_out2.write(proper_id + '\t' + `l_r` + '\t' + t_r + '\n')
	if booba != 0:
		gl_l0_file9.write(proper_id + '\t' + `booba` + '\t' + "non ATGCN letters" + '\n')

	### TRANSLATION ONE FRAME ###
	if trans_fr == 1:
		k1 = 0
		stop_count = 0
		any_count  = 0
		longest_fr = 0
		longest_orf = ""
		total_size = 0
		frm_number = 0
		my_list = []
		while k1 < l:
			m1 = k1 + 3
			p1 = t[k1:m1]	# triplet frame 1
			if p1 in gl_Any:
				my_list.append("X")
				any_count  =  any_count + 1
			if p1 in gl_Ter:
				my_list.append("*")
				stop_count = stop_count + 1
			if p1 in gl_Phe:
				my_list.append("F")
			if p1 in gl_Leu:
				my_list.append("L")
			if p1 in gl_Ser:
				my_list.append("S")
			if p1 in gl_Tyr:
				my_list.append("Y")
			if p1 in gl_Cys:
				my_list.append("C")
			if p1 in gl_Trp:
				my_list.append("W")
			if p1 in gl_Pro:
				my_list.append("P")
			if p1 in gl_His:
				my_list.append("H")
			if p1 in gl_Gln:
				my_list.append("Q")
			if p1 in gl_Arg:
				my_list.append("R")
			if p1 in gl_Ile:
				my_list.append("I")
			if p1 in gl_Met:
				my_list.append("M")
			if p1 in gl_Thr:
				my_list.append("T")
			if p1 in gl_Asn:
				my_list.append("N")
			if p1 in gl_Lys:
				my_list.append("K")
			if p1 in gl_Val:
				my_list.append("V")
			if p1 in gl_Ala:
				my_list.append("A")
			if p1 in gl_Asp:
				my_list.append("D")
			if p1 in gl_Glu:
				my_list.append("E")
			if p1 in gl_Gly:
				my_list.append("G")
			k1 = k1 + 3
			###########
		my_string = "".join(my_list)
		total_size = len(my_string)
		my_subset = my_string.split('*')
		for fragment in my_subset:
			fragment_len = len(fragment)
			# if fragment_len >= longest_fr:
			if fragment_len > longest_fr:
				longest_fr = fragment_len
				longest_orf = fragment
			if fragment_len != 0:
				frm_number = frm_number + 1
		full_frame = "UNDEFINED"
		if longest_fr >= total_size - 1:
			full_frame = "SINGLE_ORF"
		if longest_fr < total_size - 1:
			full_frame = "MULTIPLE_ORFs"
		gl_tr_file1.write(">" + proper_id + "_fr1" + " translation_frame:1" + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
		gl_tr_file1.write(my_string + '\n')
		gl_l1_file9.write(proper_id + '\t' + "fr_1" + '\t' + `stop_count` + '\t' + `any_count` + \
					'\t' + `longest_fr` + '\t' + `total_size` + '\t' + `frm_number` + '\n')
		gl_l_file10.write(">" + proper_id + "_fr1" + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
		gl_l_file10.write(longest_orf + '\n')
		if full_frame == "SINGLE_ORF":
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff = my_string.count("F")
			count_kkk = my_string.count("K")
			fract_fff = count_fff*1.0/total_size
			fract_kkk = count_kkk*1.0/total_size
			if fract_fff <= 0.70 and fract_kkk <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr1 " + `total_size` + " STOP:" + `stop_count` \
						+ " ANY(X):" + `any_count` + '\n' + my_string + '\n')
			if fract_fff > 0.70:
				fract_fff = str(round(fract_fff,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk > 0.70:
				fract_kkk = str(round(fract_kkk,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk + '\t' + "poly_KKK translation" + '\n')

	### TRANSLATION THREE FRAMES ###
	if trans_fr == 3:
		k1 = 0
		k2 = 1
		k3 = 2
		###############
		stop_count1 = 0
		any_count1  = 0
		longest_fr1 = 0
		longest_orf1 = ""
		total_size1 = 0
		frm_number1 = 0
		my_list1 = []
		###############
		stop_count2 = 0
		any_count2  = 0
		longest_fr2 = 0
		longest_orf2 = ""
		total_size2 = 0
		frm_number2 = 0
		my_list2 = []
		###############
		stop_count3 = 0
		any_count3  = 0
		longest_fr3 = 0
		longest_orf3 = ""
		total_size3 = 0
		frm_number3 = 0
		my_list3 = []
		###############
		while k1 < l:
			m1 = k1 + 3
			m2 = k2 + 3
			m3 = k3 + 3
			p1 = t[k1:m1]	# triplet frame 1
			p2 = t[k2:m2]	# triplet frame 2
			p3 = t[k3:m3]	# triplet frame 3
			#################################
			if p1 in gl_Any:
				my_list1.append("X")
				any_count1  =  any_count1 + 1
			if p1 in gl_Ter:
				my_list1.append("*")
				stop_count1 = stop_count1 + 1
			if p1 in gl_Phe:
				my_list1.append("F")
			if p1 in gl_Leu:
				my_list1.append("L")
			if p1 in gl_Ser:
				my_list1.append("S")
			if p1 in gl_Tyr:
				my_list1.append("Y")
			if p1 in gl_Cys:
				my_list1.append("C")
			if p1 in gl_Trp:
				my_list1.append("W")
			if p1 in gl_Pro:
				my_list1.append("P")
			if p1 in gl_His:
				my_list1.append("H")
			if p1 in gl_Gln:
				my_list1.append("Q")
			if p1 in gl_Arg:
				my_list1.append("R")
			if p1 in gl_Ile:
				my_list1.append("I")
			if p1 in gl_Met:
				my_list1.append("M")
			if p1 in gl_Thr:
				my_list1.append("T")
			if p1 in gl_Asn:
				my_list1.append("N")
			if p1 in gl_Lys:
				my_list1.append("K")
			if p1 in gl_Val:
				my_list1.append("V")
			if p1 in gl_Ala:
				my_list1.append("A")
			if p1 in gl_Asp:
				my_list1.append("D")
			if p1 in gl_Glu:
				my_list1.append("E")
			if p1 in gl_Gly:
				my_list1.append("G")
			##################################
			if p2 in gl_Any:
				my_list2.append("X")
				any_count2  =  any_count2 + 1
			if p2 in gl_Ter:
				my_list2.append("*")
				stop_count2 = stop_count2 + 1
			if p2 in gl_Phe:
				my_list2.append("F")
			if p2 in gl_Leu:
				my_list2.append("L")
			if p2 in gl_Ser:
				my_list2.append("S")
			if p2 in gl_Tyr:
				my_list2.append("Y")
			if p2 in gl_Cys:
				my_list2.append("C")
			if p2 in gl_Trp:
				my_list2.append("W")
			if p2 in gl_Pro:
				my_list2.append("P")
			if p2 in gl_His:
				my_list2.append("H")
			if p2 in gl_Gln:
				my_list2.append("Q")
			if p2 in gl_Arg:
				my_list2.append("R")
			if p2 in gl_Ile:
				my_list2.append("I")
			if p2 in gl_Met:
				my_list2.append("M")
			if p2 in gl_Thr:
				my_list2.append("T")
			if p2 in gl_Asn:
				my_list2.append("N")
			if p2 in gl_Lys:
				my_list2.append("K")
			if p2 in gl_Val:
				my_list2.append("V")
			if p2 in gl_Ala:
				my_list2.append("A")
			if p2 in gl_Asp:
				my_list2.append("D")
			if p2 in gl_Glu:
				my_list2.append("E")
			if p2 in gl_Gly:
				my_list2.append("G")
			##################################
			if p3 in gl_Any:
				my_list3.append("X")
				any_count3  =  any_count3 + 1
			if p3 in gl_Ter:
				my_list3.append("*")
				stop_count3 = stop_count3 + 1
			if p3 in gl_Phe:
				my_list3.append("F")
			if p3 in gl_Leu:
				my_list3.append("L")
			if p3 in gl_Ser:
				my_list3.append("S")
			if p3 in gl_Tyr:
				my_list3.append("Y")
			if p3 in gl_Cys:
				my_list3.append("C")
			if p3 in gl_Trp:
				my_list3.append("W")
			if p3 in gl_Pro:
				my_list3.append("P")
			if p3 in gl_His:
				my_list3.append("H")
			if p3 in gl_Gln:
				my_list3.append("Q")
			if p3 in gl_Arg:
				my_list3.append("R")
			if p3 in gl_Ile:
				my_list3.append("I")
			if p3 in gl_Met:
				my_list3.append("M")
			if p3 in gl_Thr:
				my_list3.append("T")
			if p3 in gl_Asn:
				my_list3.append("N")
			if p3 in gl_Lys:
				my_list3.append("K")
			if p3 in gl_Val:
				my_list3.append("V")
			if p3 in gl_Ala:
				my_list3.append("A")
			if p3 in gl_Asp:
				my_list3.append("D")
			if p3 in gl_Glu:
				my_list3.append("E")
			if p3 in gl_Gly:
				my_list3.append("G")
			##################################
			k1 = k1 + 3
			k2 = k2 + 3	# next triplet frame2
			k3 = k3 + 3	# next triplet frame3
			###########
		my_string1 = "".join(my_list1)
		my_string2 = "".join(my_list2)
		my_string3 = "".join(my_list3)
		#############################
		total_size1 = len(my_string1)
		total_size2 = len(my_string2)
		total_size3 = len(my_string3)
		#############################
		my_subset1 = my_string1.split('*')
		my_subset2 = my_string2.split('*')
		my_subset3 = my_string3.split('*')
		#############################
		## 1
		for fragment1 in my_subset1:
			fragment_len1 = len(fragment1)
			# if fragment_len1 >= longest_fr1:
			if fragment_len1 > longest_fr1:
				longest_fr1 = fragment_len1
				longest_orf1 = fragment1
			if fragment_len1 != 0:
				frm_number1 = frm_number1 + 1
		## 2
		for fragment2 in my_subset2:
			fragment_len2 = len(fragment2)
			# if fragment_len2 >= longest_fr2:
			if fragment_len2 > longest_fr2:
				longest_fr2 = fragment_len2
				longest_orf2 = fragment2
			if fragment_len2 != 0:
				frm_number2 = frm_number2 + 1
		## 3
		for fragment3 in my_subset3:
			fragment_len3 = len(fragment3)
			# if fragment_len3 >= longest_fr3:
			if fragment_len3 > longest_fr3:
				longest_fr3 = fragment_len3
				longest_orf3 = fragment3
			if fragment_len3 != 0:
				frm_number3 = frm_number3 + 1
		#############################
		full_frame1 = "UNDEFINED"
		full_frame2 = "UNDEFINED"
		full_frame3 = "UNDEFINED"
		#############################
		## 1
		if longest_fr1 >= total_size1 - 1:
			full_frame1 = "SINGLE_ORF"
		if longest_fr1 < total_size1 - 1:
			full_frame1 = "MULTIPLE_ORFs"
		## 2
		if longest_fr2 >= total_size2 - 1:
			full_frame2 = "SINGLE_ORF"
		if longest_fr2 < total_size2 - 1:
			full_frame2 = "MULTIPLE_ORFs"
		## 3
		if longest_fr3 >= total_size3 - 1:
			full_frame3 = "SINGLE_ORF"
		if longest_fr3 < total_size3 - 1:
			full_frame3 = "MULTIPLE_ORFs"
		#############################
		## 1
		gl_tr_file1.write(">" + proper_id + "_fr1" + " translation_frame:1" + \
					" STOP:" + `stop_count1` + " ANY(X):" + `any_count1` + \
					" LONGEST:" + `longest_fr1` + " TOTAL_LENGTH:" + `total_size1` + \
					" " + full_frame1 + ":" + `frm_number1` + '\n')
		gl_tr_file1.write(my_string1 + '\n')
		## 2
		gl_tr_file2.write(">" + proper_id + "_fr2" + " translation_frame:2" + \
					" STOP:" + `stop_count2` + " ANY(X):" + `any_count2` + \
					" LONGEST:" + `longest_fr2` + " TOTAL_LENGTH:" + `total_size2` + \
					" " + full_frame2 + ":" + `frm_number2` + '\n')
		gl_tr_file2.write(my_string2 + '\n')
		## 3
		gl_tr_file3.write(">" + proper_id + "_fr3" + " translation_frame:3" + \
					" STOP:" + `stop_count3` + " ANY(X):" + `any_count3` + \
					" LONGEST:" + `longest_fr3` + " TOTAL_LENGTH:" + `total_size3` + \
					" " + full_frame3 + ":" + `frm_number3` + '\n')
		gl_tr_file3.write(my_string3 + '\n')
		#############################
		## LONGEST ##
		llen1 = len(longest_orf1)
		llen2 = len(longest_orf2)
		llen3 = len(longest_orf3)
		lfrm  = " "
		lfrm1 = ""
		lfrm2 = ""
		lfrm3 = ""
		dupl_status = " UNIQ_LONG"
		## 1
		if llen1 >= llen2 and llen1 >= llen3:
			if llen1 == llen2  or llen1 == llen3:
				dupl_status = " DUPL_LONG"
			lfr = "_fr1"
			lfrm1 = "fr_1"
			longest_orf = longest_orf1
			stop_count = stop_count1
			any_count = any_count1
			longest_fr = longest_fr1
			total_size = total_size1
			full_frame = full_frame1
			frm_number = frm_number1
			longest_len = llen1
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 2
		if llen2 >= llen1 and llen2 >= llen3:
			if llen2 == llen1  or llen2 == llen3:
				dupl_status = " DUPL_LONG"
			lfr = "_fr2"
			lfrm2 = "fr_2"
			longest_orf = longest_orf2
			stop_count = stop_count2
			any_count = any_count2
			longest_fr = longest_fr2
			total_size = total_size2
			full_frame = full_frame2
			frm_number = frm_number2
			longest_len = llen2
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 3
		if llen3 >= llen1 and llen3 >= llen2:
			if llen3 == llen1  or llen3 == llen2:
				dupl_status = " DUPL_LONG"
			lfr = "_fr3"
			lfrm3 = "fr_3"
			longest_orf = longest_orf3
			stop_count = stop_count3
			any_count = any_count3
			longest_fr = longest_fr3
			total_size = total_size3
			full_frame = full_frame3
			frm_number = frm_number3
			longest_len = llen3
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		#############################
		gl_l1_file9.write(proper_id + '\t' + "fr_1" + '\t' + `stop_count1` + '\t' + `any_count1` + \
					'\t' + `longest_fr1` + '\t' + `total_size1` + '\t' + `frm_number1` + '\n')
		gl_l2_file9.write(proper_id + '\t' + "fr_2" + '\t' + `stop_count2` + '\t' + `any_count2` + \
					'\t' + `longest_fr2` + '\t' + `total_size2` + '\t' + `frm_number2` + '\n')
		gl_l3_file9.write(proper_id + '\t' + "fr_3" + '\t' + `stop_count3` + '\t' + `any_count3` + \
					'\t' + `longest_fr3` + '\t' + `total_size3` + '\t' + `frm_number3` + '\n')
		#############################
		if dupl_status == " UNIQ_LONG":
			dupl_wr = "UNIQ"
		if dupl_status == " DUPL_LONG":
			dupl_wr = "DUPL"
		lfrm_list = [lfrm1, lfrm2, lfrm3]
		for l_item in lfrm_list:
			if l_item != "":
				# lfrm = lfrm + " " + l_item + " "
				lfrm = lfrm + l_item + " "
		# lfrm = lfrm[1:]
		# lfrm = lfrm[:-1]
		gl_ls_file9.write(proper_id + '\t' + \
				"fr_1" + '\t' + `stop_count1` + '\t' + `any_count1` + \
				'\t' + `longest_fr1` + '\t' + `total_size1` + '\t' + `frm_number1` + '\t' + \
				"fr_2" + '\t' + `stop_count2` + '\t' + `any_count2` + \
				'\t' + `longest_fr2` + '\t' + `total_size2` + '\t' + `frm_number2` + '\t' + \
				"fr_3" + '\t' + `stop_count3` + '\t' + `any_count3` + \
				'\t' + `longest_fr3` + '\t' + `total_size3` + '\t' + `frm_number3` + '\t' + \
				`longest_len` + '\t' + lfrm + '\t' + dupl_wr + '\n')
		#############################
		dupl_frame1 = " ONE_ORF"
		dupl_frame2 = " ONE_ORF"
		dupl_frame3 = " ONE_ORF"
		#############
		## 1
		if full_frame1 == "SINGLE_ORF":
			if full_frame1 == full_frame2:
				dupl_frame1 = " NOT_UNIQ"
			if full_frame1 == full_frame3:
				dupl_frame1 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff1 = my_string1.count("F")
			count_kkk1 = my_string1.count("K")
			fract_fff1 = count_fff1*1.0/total_size1
			fract_kkk1 = count_kkk1*1.0/total_size1
			if fract_fff1 <= 0.70 and fract_kkk1 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr1 " + `total_size1` + " STOP:" + `stop_count1` \
						+ " ANY(X):" + `any_count1` + dupl_frame1 + '\n' + my_string1 + '\n')
			if fract_fff1 > 0.70:
				fract_fff1 = str(round(fract_fff1,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff1 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk1 > 0.70:
				fract_kkk1 = str(round(fract_kkk1,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk1 + '\t' + "poly_KKK translation" + '\n')
		#############
		## 2
		if full_frame2 == "SINGLE_ORF":
			if full_frame2 == full_frame1:
				dupl_frame2 = " NOT_UNIQ"
			if full_frame2 == full_frame3:
				dupl_frame2 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff2 = my_string2.count("F")
			count_kkk2 = my_string2.count("K")
			fract_fff2 = count_fff2*1.0/total_size2
			fract_kkk2 = count_kkk2*1.0/total_size2
			if fract_fff2 <= 0.70 and fract_kkk2 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr2 " + `total_size2` + " STOP:" + `stop_count2` \
						+ " ANY(X):" + `any_count2` + dupl_frame2 + '\n' + my_string2 + '\n')
			if fract_fff2 > 0.70:
				fract_fff2 = str(round(fract_fff2,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff2 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk2 > 0.70:
				fract_kkk2 = str(round(fract_kkk2,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk2 + '\t' + "poly_KKK translation" + '\n')
		#############
		## 3
		if full_frame3 == "SINGLE_ORF":
			if full_frame3 == full_frame1:
				dupl_frame3 = " NOT_UNIQ"
			if full_frame3 == full_frame2:
				dupl_frame3 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff3 = my_string3.count("F")
			count_kkk3 = my_string3.count("K")
			fract_fff3 = count_fff3*1.0/total_size3
			fract_kkk3 = count_kkk3*1.0/total_size3
			if fract_fff3 <= 0.70 and fract_kkk3 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr3 " + `total_size3` + " STOP:" + `stop_count3` \
						+ " ANY(X):" + `any_count3` + dupl_frame3 + '\n' + my_string3 + '\n')
			if fract_fff3 > 0.70:
				fract_fff3 = str(round(fract_fff3,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff3 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk3 > 0.70:
				fract_kkk3 = str(round(fract_kkk3,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk3 + '\t' + "poly_KKK translation" + '\n')
		#############################
	### TRANSLATION SIX FRAMES ###
	if trans_fr == 6:
		k1 = 0
		k2 = 1
		k3 = 2
		###############
		stop_count1 = 0
		any_count1  = 0
		longest_fr1 = 0
		longest_orf1 = ""
		total_size1 = 0
		frm_number1 = 0
		my_list1 = []
		###############
		stop_count2 = 0
		any_count2  = 0
		longest_fr2 = 0
		longest_orf2 = ""
		total_size2 = 0
		frm_number2 = 0
		my_list2 = []
		###############
		stop_count3 = 0
		any_count3  = 0
		longest_fr3 = 0
		longest_orf3 = ""
		total_size3 = 0
		frm_number3 = 0
		my_list3 = []
		###############
		stop_count4 = 0
		any_count4  = 0
		longest_fr4 = 0
		longest_orf4 = ""
		total_size4 = 0
		frm_number4 = 0
		my_list4 = []
		###############
		stop_count5 = 0
		any_count5  = 0
		longest_fr5 = 0
		longest_orf5 = ""
		total_size5 = 0
		frm_number5 = 0
		my_list5 = []
		###############
		stop_count6 = 0
		any_count6  = 0
		longest_fr6 = 0
		longest_orf6 = ""
		total_size6 = 0
		frm_number6 = 0
		my_list6 = []
		###############
		while k1 < l:
			m1 = k1 + 3
			m2 = k2 + 3
			m3 = k3 + 3
			p1 = t[k1:m1]	# triplet frame 1
			p2 = t[k2:m2]	# triplet frame 2
			p3 = t[k3:m3]	# triplet frame 3
			p4 = t_r[k1:m1]	# triplet frame 4
			p5 = t_r[k2:m2]	# triplet frame 5
			p6 = t_r[k3:m3]	# triplet frame 6
			#################################
			if p1 in gl_Any:
				my_list1.append("X")
				any_count1  =  any_count1 + 1
			if p1 in gl_Ter:
				my_list1.append("*")
				stop_count1 = stop_count1 + 1
			if p1 in gl_Phe:
				my_list1.append("F")
			if p1 in gl_Leu:
				my_list1.append("L")
			if p1 in gl_Ser:
				my_list1.append("S")
			if p1 in gl_Tyr:
				my_list1.append("Y")
			if p1 in gl_Cys:
				my_list1.append("C")
			if p1 in gl_Trp:
				my_list1.append("W")
			if p1 in gl_Pro:
				my_list1.append("P")
			if p1 in gl_His:
				my_list1.append("H")
			if p1 in gl_Gln:
				my_list1.append("Q")
			if p1 in gl_Arg:
				my_list1.append("R")
			if p1 in gl_Ile:
				my_list1.append("I")
			if p1 in gl_Met:
				my_list1.append("M")
			if p1 in gl_Thr:
				my_list1.append("T")
			if p1 in gl_Asn:
				my_list1.append("N")
			if p1 in gl_Lys:
				my_list1.append("K")
			if p1 in gl_Val:
				my_list1.append("V")
			if p1 in gl_Ala:
				my_list1.append("A")
			if p1 in gl_Asp:
				my_list1.append("D")
			if p1 in gl_Glu:
				my_list1.append("E")
			if p1 in gl_Gly:
				my_list1.append("G")
			##################################
			if p2 in gl_Any:
				my_list2.append("X")
				any_count2  =  any_count2 + 1
			if p2 in gl_Ter:
				my_list2.append("*")
				stop_count2 = stop_count2 + 1
			if p2 in gl_Phe:
				my_list2.append("F")
			if p2 in gl_Leu:
				my_list2.append("L")
			if p2 in gl_Ser:
				my_list2.append("S")
			if p2 in gl_Tyr:
				my_list2.append("Y")
			if p2 in gl_Cys:
				my_list2.append("C")
			if p2 in gl_Trp:
				my_list2.append("W")
			if p2 in gl_Pro:
				my_list2.append("P")
			if p2 in gl_His:
				my_list2.append("H")
			if p2 in gl_Gln:
				my_list2.append("Q")
			if p2 in gl_Arg:
				my_list2.append("R")
			if p2 in gl_Ile:
				my_list2.append("I")
			if p2 in gl_Met:
				my_list2.append("M")
			if p2 in gl_Thr:
				my_list2.append("T")
			if p2 in gl_Asn:
				my_list2.append("N")
			if p2 in gl_Lys:
				my_list2.append("K")
			if p2 in gl_Val:
				my_list2.append("V")
			if p2 in gl_Ala:
				my_list2.append("A")
			if p2 in gl_Asp:
				my_list2.append("D")
			if p2 in gl_Glu:
				my_list2.append("E")
			if p2 in gl_Gly:
				my_list2.append("G")
			##################################
			if p3 in gl_Any:
				my_list3.append("X")
				any_count3  =  any_count3 + 1
			if p3 in gl_Ter:
				my_list3.append("*")
				stop_count3 = stop_count3 + 1
			if p3 in gl_Phe:
				my_list3.append("F")
			if p3 in gl_Leu:
				my_list3.append("L")
			if p3 in gl_Ser:
				my_list3.append("S")
			if p3 in gl_Tyr:
				my_list3.append("Y")
			if p3 in gl_Cys:
				my_list3.append("C")
			if p3 in gl_Trp:
				my_list3.append("W")
			if p3 in gl_Pro:
				my_list3.append("P")
			if p3 in gl_His:
				my_list3.append("H")
			if p3 in gl_Gln:
				my_list3.append("Q")
			if p3 in gl_Arg:
				my_list3.append("R")
			if p3 in gl_Ile:
				my_list3.append("I")
			if p3 in gl_Met:
				my_list3.append("M")
			if p3 in gl_Thr:
				my_list3.append("T")
			if p3 in gl_Asn:
				my_list3.append("N")
			if p3 in gl_Lys:
				my_list3.append("K")
			if p3 in gl_Val:
				my_list3.append("V")
			if p3 in gl_Ala:
				my_list3.append("A")
			if p3 in gl_Asp:
				my_list3.append("D")
			if p3 in gl_Glu:
				my_list3.append("E")
			if p3 in gl_Gly:
				my_list3.append("G")
			##################################
			if p4 in gl_Any:
				my_list4.append("X")
				any_count4  =  any_count4 + 1
			if p4 in gl_Ter:
				my_list4.append("*")
				stop_count4 = stop_count4 + 1
			if p4 in gl_Phe:
				my_list4.append("F")
			if p4 in gl_Leu:
				my_list4.append("L")
			if p4 in gl_Ser:
				my_list4.append("S")
			if p4 in gl_Tyr:
				my_list4.append("Y")
			if p4 in gl_Cys:
				my_list4.append("C")
			if p4 in gl_Trp:
				my_list4.append("W")
			if p4 in gl_Pro:
				my_list4.append("P")
			if p4 in gl_His:
				my_list4.append("H")
			if p4 in gl_Gln:
				my_list4.append("Q")
			if p4 in gl_Arg:
				my_list4.append("R")
			if p4 in gl_Ile:
				my_list4.append("I")
			if p4 in gl_Met:
				my_list4.append("M")
			if p4 in gl_Thr:
				my_list4.append("T")
			if p4 in gl_Asn:
				my_list4.append("N")
			if p4 in gl_Lys:
				my_list4.append("K")
			if p4 in gl_Val:
				my_list4.append("V")
			if p4 in gl_Ala:
				my_list4.append("A")
			if p4 in gl_Asp:
				my_list4.append("D")
			if p4 in gl_Glu:
				my_list4.append("E")
			if p4 in gl_Gly:
				my_list4.append("G")
			##################################
			if p5 in gl_Any:
				my_list5.append("X")
				any_count5  =  any_count5 + 1
			if p5 in gl_Ter:
				my_list5.append("*")
				stop_count5 = stop_count5 + 1
			if p5 in gl_Phe:
				my_list5.append("F")
			if p5 in gl_Leu:
				my_list5.append("L")
			if p5 in gl_Ser:
				my_list5.append("S")
			if p5 in gl_Tyr:
				my_list5.append("Y")
			if p5 in gl_Cys:
				my_list5.append("C")
			if p5 in gl_Trp:
				my_list5.append("W")
			if p5 in gl_Pro:
				my_list5.append("P")
			if p5 in gl_His:
				my_list5.append("H")
			if p5 in gl_Gln:
				my_list5.append("Q")
			if p5 in gl_Arg:
				my_list5.append("R")
			if p5 in gl_Ile:
				my_list5.append("I")
			if p5 in gl_Met:
				my_list5.append("M")
			if p5 in gl_Thr:
				my_list5.append("T")
			if p5 in gl_Asn:
				my_list5.append("N")
			if p5 in gl_Lys:
				my_list5.append("K")
			if p5 in gl_Val:
				my_list5.append("V")
			if p5 in gl_Ala:
				my_list5.append("A")
			if p5 in gl_Asp:
				my_list5.append("D")
			if p5 in gl_Glu:
				my_list5.append("E")
			if p5 in gl_Gly:
				my_list5.append("G")
			##################################
			if p6 in gl_Any:
				my_list6.append("X")
				any_count6  =  any_count6 + 1
			if p6 in gl_Ter:
				my_list6.append("*")
				stop_count6 = stop_count6 + 1
			if p6 in gl_Phe:
				my_list6.append("F")
			if p6 in gl_Leu:
				my_list6.append("L")
			if p6 in gl_Ser:
				my_list6.append("S")
			if p6 in gl_Tyr:
				my_list6.append("Y")
			if p6 in gl_Cys:
				my_list6.append("C")
			if p6 in gl_Trp:
				my_list6.append("W")
			if p6 in gl_Pro:
				my_list6.append("P")
			if p6 in gl_His:
				my_list6.append("H")
			if p6 in gl_Gln:
				my_list6.append("Q")
			if p6 in gl_Arg:
				my_list6.append("R")
			if p6 in gl_Ile:
				my_list6.append("I")
			if p6 in gl_Met:
				my_list6.append("M")
			if p6 in gl_Thr:
				my_list6.append("T")
			if p6 in gl_Asn:
				my_list6.append("N")
			if p6 in gl_Lys:
				my_list6.append("K")
			if p6 in gl_Val:
				my_list6.append("V")
			if p6 in gl_Ala:
				my_list6.append("A")
			if p6 in gl_Asp:
				my_list6.append("D")
			if p6 in gl_Glu:
				my_list6.append("E")
			if p6 in gl_Gly:
				my_list6.append("G")
			##################################
			k1 = k1 + 3
			k2 = k2 + 3	# next triplet frame2
			k3 = k3 + 3	# next triplet frame3
			###########
		my_string1 = "".join(my_list1)
		my_string2 = "".join(my_list2)
		my_string3 = "".join(my_list3)
		my_string4 = "".join(my_list4)
		my_string5 = "".join(my_list5)
		my_string6 = "".join(my_list6)
		#############################
		total_size1 = len(my_string1)
		total_size2 = len(my_string2)
		total_size3 = len(my_string3)
		total_size4 = len(my_string4)
		total_size5 = len(my_string5)
		total_size6 = len(my_string6)
		#############################
		my_subset1 = my_string1.split('*')
		my_subset2 = my_string2.split('*')
		my_subset3 = my_string3.split('*')
		my_subset4 = my_string4.split('*')
		my_subset5 = my_string5.split('*')
		my_subset6 = my_string6.split('*')
		#############################
		## 1
		for fragment1 in my_subset1:
			fragment_len1 = len(fragment1)
			# if fragment_len1 >= longest_fr1:
			if fragment_len1 > longest_fr1:
				longest_fr1 = fragment_len1
				longest_orf1 = fragment1
			if fragment_len1 != 0:
				frm_number1 = frm_number1 + 1
		## 2
		for fragment2 in my_subset2:
			fragment_len2 = len(fragment2)
			# if fragment_len2 >= longest_fr2:
			if fragment_len2 > longest_fr2:
				longest_fr2 = fragment_len2
				longest_orf2 = fragment2
			if fragment_len2 != 0:
				frm_number2 = frm_number2 + 1
		## 3
		for fragment3 in my_subset3:
			fragment_len3 = len(fragment3)
			# if fragment_len3 >= longest_fr3:
			if fragment_len3 > longest_fr3:
				longest_fr3 = fragment_len3
				longest_orf3 = fragment3
			if fragment_len3 != 0:
				frm_number3 = frm_number3 + 1
		## 4
		for fragment4 in my_subset4:
			fragment_len4 = len(fragment4)
			# if fragment_len4 >= longest_fr4:
			if fragment_len4 > longest_fr4:
				longest_fr4 = fragment_len4
				longest_orf4 = fragment4
			if fragment_len4 != 0:
				frm_number4 = frm_number4 + 1
		## 5
		for fragment5 in my_subset5:
			fragment_len5 = len(fragment5)
			# if fragment_len5 >= longest_fr5:
			if fragment_len5 > longest_fr5:
				longest_fr5 = fragment_len5
				longest_orf5 = fragment5
			if fragment_len5 != 0:
				frm_number5 = frm_number5 + 1
		## 6
		for fragment6 in my_subset6:
			fragment_len6 = len(fragment6)
			# if fragment_len6 >= longest_fr6:
			if fragment_len6 > longest_fr6:
				longest_fr6 = fragment_len6
				longest_orf6 = fragment6
			if fragment_len6 != 0:
				frm_number6 = frm_number6 + 1
		#############################
		full_frame1 = "UNDEFINED"
		full_frame2 = "UNDEFINED"
		full_frame3 = "UNDEFINED"
		full_frame4 = "UNDEFINED"
		full_frame5 = "UNDEFINED"
		full_frame6 = "UNDEFINED"
		#############################
		## 1
		if longest_fr1 >= total_size1 - 1:
			full_frame1 = "SINGLE_ORF"
		if longest_fr1 < total_size1 - 1:
			full_frame1 = "MULTIPLE_ORFs"
		## 2
		if longest_fr2 >= total_size2 - 1:
			full_frame2 = "SINGLE_ORF"
		if longest_fr2 < total_size2 - 1:
			full_frame2 = "MULTIPLE_ORFs"
		## 3
		if longest_fr3 >= total_size3 - 1:
			full_frame3 = "SINGLE_ORF"
		if longest_fr3 < total_size3 - 1:
			full_frame3 = "MULTIPLE_ORFs"
		## 4
		if longest_fr4 >= total_size4 - 1:
			full_frame4 = "SINGLE_ORF"
		if longest_fr4 < total_size4 - 1:
			full_frame4 = "MULTIPLE_ORFs"
		## 5
		if longest_fr5 >= total_size5 - 1:
			full_frame5 = "SINGLE_ORF"
		if longest_fr5 < total_size5 - 1:
			full_frame5 = "MULTIPLE_ORFs"
		## 6
		if longest_fr6 >= total_size6 - 1:
			full_frame6 = "SINGLE_ORF"
		if longest_fr6 < total_size6 - 1:
			full_frame6 = "MULTIPLE_ORFs"
		#############################
		## 1
		gl_tr_file1.write(">" + proper_id + "_fr1" + " translation_frame:1" + \
					" STOP:" + `stop_count1` + " ANY(X):" + `any_count1` + \
					" LONGEST:" + `longest_fr1` + " TOTAL_LENGTH:" + `total_size1` + \
					" " + full_frame1 + ":" + `frm_number1` + '\n')
		gl_tr_file1.write(my_string1 + '\n')
		## 2
		gl_tr_file2.write(">" + proper_id + "_fr2" + " translation_frame:2" + \
					" STOP:" + `stop_count2` + " ANY(X):" + `any_count2` + \
					" LONGEST:" + `longest_fr2` + " TOTAL_LENGTH:" + `total_size2` + \
					" " + full_frame2 + ":" + `frm_number2` + '\n')
		gl_tr_file2.write(my_string2 + '\n')
		## 3
		gl_tr_file3.write(">" + proper_id + "_fr3" + " translation_frame:3" + \
					" STOP:" + `stop_count3` + " ANY(X):" + `any_count3` + \
					" LONGEST:" + `longest_fr3` + " TOTAL_LENGTH:" + `total_size3` + \
					" " + full_frame3 + ":" + `frm_number3` + '\n')
		gl_tr_file3.write(my_string3 + '\n')
		## 4
		gl_tr_file4.write(">" + proper_id + "_fr4" + " translation_frame:4" + \
					" STOP:" + `stop_count4` + " ANY(X):" + `any_count4` + \
					" LONGEST:" + `longest_fr4` + " TOTAL_LENGTH:" + `total_size4` + \
					" " + full_frame4 + ":" + `frm_number4` + '\n')
		gl_tr_file4.write(my_string4 + '\n')
		## 5
		gl_tr_file5.write(">" + proper_id + "_fr5" + " translation_frame:5" + \
					" STOP:" + `stop_count5` + " ANY(X):" + `any_count5` + \
					" LONGEST:" + `longest_fr5` + " TOTAL_LENGTH:" + `total_size5` + \
					" " + full_frame5 + ":" + `frm_number5` + '\n')
		gl_tr_file5.write(my_string5 + '\n')
		## 6
		gl_tr_file6.write(">" + proper_id + "_fr6" + " translation_frame:6" + \
					" STOP:" + `stop_count6` + " ANY(X):" + `any_count6` + \
					" LONGEST:" + `longest_fr6` + " TOTAL_LENGTH:" + `total_size6` + \
					" " + full_frame6 + ":" + `frm_number6` + '\n')
		gl_tr_file6.write(my_string6 + '\n')
		#############################
		## LONGEST ##
		llen1 = len(longest_orf1)
		llen2 = len(longest_orf2)
		llen3 = len(longest_orf3)
		llen4 = len(longest_orf4)
		llen5 = len(longest_orf5)
		llen6 = len(longest_orf6)
		lfrm  = " "
		lfrm1 = ""
		lfrm2 = ""
		lfrm3 = ""
		lfrm4 = ""
		lfrm5 = ""
		lfrm6 = ""
		dupl_status = " UNIQ_LONG"
		## 1
		if llen1 >= llen2 and llen1 >= llen3 and llen1 >= llen4 and llen1 >= llen5 and llen1 >= llen6:
			if llen1 == llen2 or llen1 == llen3 or llen1 == llen4 or llen1 == llen5 or llen1 == llen6:
				dupl_status = " DUPL_LONG"
			lfr = "_fr1"
			lfrm1 = "fr_1"
			longest_orf = longest_orf1
			stop_count = stop_count1
			any_count = any_count1
			longest_fr = longest_fr1
			total_size = total_size1
			full_frame = full_frame1
			frm_number = frm_number1
			longest_len = llen1
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 2
		if llen2 >= llen1 and llen2 >= llen3 and llen2 >= llen4 and llen2 >= llen5 and llen2 >= llen6:
			if llen2 == llen1 or llen2 == llen3 or llen2 == llen4 or llen2 == llen5 or llen2 == llen6:
				dupl_status = " DUPL_LONG"
			lfr = "_fr2"
			lfrm2 = "fr_2"
			longest_orf = longest_orf2
			stop_count = stop_count2
			any_count = any_count2
			longest_fr = longest_fr2
			total_size = total_size2
			full_frame = full_frame2
			frm_number = frm_number2
			longest_len = llen2
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 3
		if llen3 >= llen1 and llen3 >= llen2 and llen3 >= llen4 and llen3 >= llen5 and llen3 >= llen6:
			if llen3 == llen1 or llen3 == llen2 or llen3 == llen4 or llen3 == llen5 or llen3 == llen6:
				dupl_status = " DUPL_LONG"
			lfr = "_fr3"
			lfrm3 = "fr_3"
			longest_orf = longest_orf3
			stop_count = stop_count3
			any_count = any_count3
			longest_fr = longest_fr3
			total_size = total_size3
			full_frame = full_frame3
			frm_number = frm_number3
			longest_len = llen3
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 4
		if llen4 >= llen1 and llen4 >= llen2 and llen4 >= llen3 and llen4 >= llen5 and llen4 >= llen6:
			if llen4 == llen1 or llen4 == llen2 or llen4 == llen3 or llen4 == llen5 or llen4 == llen6:
				dupl_status = " DUPL_LONG"
			lfr = "_fr4"
			lfrm4 = "fr_4"
			longest_orf = longest_orf4
			stop_count = stop_count4
			any_count = any_count4
			longest_fr = longest_fr4
			total_size = total_size4
			full_frame = full_frame4
			frm_number = frm_number4
			longest_len = llen4
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 5
		if llen5 >= llen1 and llen5 >= llen2 and llen5 >= llen3 and llen5 >= llen4 and llen5 >= llen6:
			if llen5 == llen1 or llen5 == llen2 or llen5 == llen3 or llen5 == llen4 or llen5 == llen6:
				dupl_status = " DUPL_LONG"
			lfr = "_fr5"
			lfrm5 = "fr_5"
			longest_orf = longest_orf5
			stop_count = stop_count5
			any_count = any_count5
			longest_fr = longest_fr5
			total_size = total_size5
			full_frame = full_frame5
			frm_number = frm_number5
			longest_len = llen5
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		## 6
		if llen6 >= llen1 and llen6 >= llen2 and llen6 >= llen3 and llen6 >= llen4 and llen6 >= llen5:
			if llen6 == llen1 or llen6 == llen2 or llen6 == llen3 or llen6 == llen4 or llen6 == llen5:
				dupl_status = " DUPL_LONG"
			lfr = "_fr6"
			lfrm6 = "fr_6"
			longest_orf = longest_orf6
			stop_count = stop_count6
			any_count = any_count6
			longest_fr = longest_fr6
			total_size = total_size6
			full_frame = full_frame6
			frm_number = frm_number6
			longest_len = llen6
			gl_l_file10.write(">" + proper_id + lfr + dupl_status + \
					" STOP:" + `stop_count` + " ANY(X):" + `any_count` + \
					" LONGEST:" + `longest_fr` + " TOTAL_LENGTH:" + `total_size` + \
					" " + full_frame + ":" + `frm_number` + '\n')
			gl_l_file10.write(longest_orf + '\n')
		
		#############################
		gl_l1_file9.write(proper_id + '\t' + "fr_1" + '\t' + `stop_count1` + '\t' + `any_count1` + \
					'\t' + `longest_fr1` + '\t' + `total_size1` + '\t' + `frm_number1` + '\n')
		gl_l2_file9.write(proper_id + '\t' + "fr_2" + '\t' + `stop_count2` + '\t' + `any_count2` + \
					'\t' + `longest_fr2` + '\t' + `total_size2` + '\t' + `frm_number2` + '\n')
		gl_l3_file9.write(proper_id + '\t' + "fr_3" + '\t' + `stop_count3` + '\t' + `any_count3` + \
					'\t' + `longest_fr3` + '\t' + `total_size3` + '\t' + `frm_number3` + '\n')
		gl_l4_file9.write(proper_id + '\t' + "fr_4" + '\t' + `stop_count4` + '\t' + `any_count4` + \
					'\t' + `longest_fr4` + '\t' + `total_size4` + '\t' + `frm_number4` + '\n')
		gl_l5_file9.write(proper_id + '\t' + "fr_5" + '\t' + `stop_count5` + '\t' + `any_count5` + \
					'\t' + `longest_fr5` + '\t' + `total_size5` + '\t' + `frm_number5` + '\n')
		gl_l6_file9.write(proper_id + '\t' + "fr_6" + '\t' + `stop_count6` + '\t' + `any_count6` + \
					'\t' + `longest_fr6` + '\t' + `total_size6` + '\t' + `frm_number6` + '\n')
		#############################
		if dupl_status == " UNIQ_LONG":
			dupl_wr = "UNIQ"
		if dupl_status == " DUPL_LONG":
			dupl_wr = "DUPL"
		lfrm_list = [lfrm1, lfrm2, lfrm3, lfrm4, lfrm5, lfrm6]
		for l_item in lfrm_list:
			if l_item != "":
				# lfrm = lfrm + " " + l_item + " "
				lfrm = lfrm + l_item + " "
		# lfrm = lfrm[1:]
		# lfrm = lfrm[:-1]
		gl_ls_file9.write(proper_id + '\t' + \
				"fr_1" + '\t' + `stop_count1` + '\t' + `any_count1` + \
				'\t' + `longest_fr1` + '\t' + `total_size1` + '\t' + `frm_number1` + '\t' + \
				"fr_2" + '\t' + `stop_count2` + '\t' + `any_count2` + \
				'\t' + `longest_fr2` + '\t' + `total_size2` + '\t' + `frm_number2` + '\t' + \
				"fr_3" + '\t' + `stop_count3` + '\t' + `any_count3` + \
				'\t' + `longest_fr3` + '\t' + `total_size3` + '\t' + `frm_number3` + '\t' + \
				"fr_4" + '\t' + `stop_count4` + '\t' + `any_count4` + \
				'\t' + `longest_fr4` + '\t' + `total_size4` + '\t' + `frm_number4` + '\t' + \
				"fr_5" + '\t' + `stop_count5` + '\t' + `any_count5` + \
				'\t' + `longest_fr5` + '\t' + `total_size5` + '\t' + `frm_number5` + '\t' + \
				"fr_6" + '\t' + `stop_count6` + '\t' + `any_count6` + \
				'\t' + `longest_fr6` + '\t' + `total_size6` + '\t' + `frm_number6` + '\t' + \
				`longest_len` + '\t' + lfrm + '\t' + dupl_wr + '\n')
		#############################
		dupl_frame1 = " ONE_ORF"
		dupl_frame2 = " ONE_ORF"
		dupl_frame3 = " ONE_ORF"
		dupl_frame4 = " ONE_ORF"
		dupl_frame5 = " ONE_ORF"
		dupl_frame6 = " ONE_ORF"
		#############
		## 1
		if full_frame1 == "SINGLE_ORF":
			if full_frame1 == full_frame2:
				dupl_frame1 = " NOT_UNIQ"
			if full_frame1 == full_frame3:
				dupl_frame1 = " NOT_UNIQ"
			if full_frame1 == full_frame4:
				dupl_frame1 = " NOT_UNIQ"
			if full_frame1 == full_frame5:
				dupl_frame1 = " NOT_UNIQ"
			if full_frame1 == full_frame6:
				dupl_frame1 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff1 = my_string1.count("F")
			count_kkk1 = my_string1.count("K")
			fract_fff1 = count_fff1*1.0/total_size1
			fract_kkk1 = count_kkk1*1.0/total_size1
			if fract_fff1 <= 0.70 and fract_kkk1 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr1 " + `total_size1` + " STOP:" + `stop_count1` \
						+ " ANY(X):" + `any_count1` + dupl_frame1 + '\n' + my_string1 + '\n')
			if fract_fff1 > 0.70:
				fract_fff1 = str(round(fract_fff1,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff1 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk1 > 0.70:
				fract_kkk1 = str(round(fract_kkk1,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk1 + '\t' + "poly_KKK translation" + '\n')
		#############
		## 2
		if full_frame2 == "SINGLE_ORF":
			if full_frame2 == full_frame1:
				dupl_frame2 = " NOT_UNIQ"
			if full_frame2 == full_frame3:
				dupl_frame2 = " NOT_UNIQ"
			if full_frame2 == full_frame4:
				dupl_frame2 = " NOT_UNIQ"
			if full_frame2 == full_frame5:
				dupl_frame2 = " NOT_UNIQ"
			if full_frame2 == full_frame6:
				dupl_frame2 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff2 = my_string2.count("F")
			count_kkk2 = my_string2.count("K")
			fract_fff2 = count_fff2*1.0/total_size2
			fract_kkk2 = count_kkk2*1.0/total_size2
			if fract_fff2 <= 0.70 and fract_kkk2 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr2 " + `total_size2` + " STOP:" + `stop_count2` \
						+ " ANY(X):" + `any_count2` + dupl_frame2 + '\n' + my_string2 + '\n')
			if fract_fff2 > 0.70:
				fract_fff2 = str(round(fract_fff2,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff2 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk2 > 0.70:
				fract_kkk2 = str(round(fract_kkk2,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk2 + '\t' + "poly_KKK translation" + '\n')
		#############
		## 3
		if full_frame3 == "SINGLE_ORF":
			if full_frame3 == full_frame1:
				dupl_frame3 = " NOT_UNIQ"
			if full_frame3 == full_frame2:
				dupl_frame3 = " NOT_UNIQ"
			if full_frame3 == full_frame4:
				dupl_frame3 = " NOT_UNIQ"
			if full_frame3 == full_frame5:
				dupl_frame3 = " NOT_UNIQ"
			if full_frame3 == full_frame6:
				dupl_frame3 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff3 = my_string3.count("F")
			count_kkk3 = my_string3.count("K")
			fract_fff3 = count_fff3*1.0/total_size3
			fract_kkk3 = count_kkk3*1.0/total_size3
			if fract_fff3 <= 0.70 and fract_kkk3 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr3 " + `total_size3` + " STOP:" + `stop_count3` \
						+ " ANY(X):" + `any_count3` + dupl_frame3 + '\n' + my_string3 + '\n')
			if fract_fff3 > 0.70:
				fract_fff3 = str(round(fract_fff3,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff3 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk3 > 0.70:
				fract_kkk3 = str(round(fract_kkk3,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk3 + '\t' + "poly_KKK translation" + '\n')
		## 4
		if full_frame4 == "SINGLE_ORF":
			if full_frame4 == full_frame1:
				dupl_frame4 = " NOT_UNIQ"
			if full_frame4 == full_frame2:
				dupl_frame4 = " NOT_UNIQ"
			if full_frame4 == full_frame3:
				dupl_frame4 = " NOT_UNIQ"
			if full_frame4 == full_frame5:
				dupl_frame4 = " NOT_UNIQ"
			if full_frame4 == full_frame6:
				dupl_frame4 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff4 = my_string4.count("F")
			count_kkk4 = my_string4.count("K")
			fract_fff4 = count_fff4*1.0/total_size4
			fract_kkk4 = count_kkk4*1.0/total_size4
			if fract_fff4 <= 0.70 and fract_kkk4 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr4 " + `total_size4` + " STOP:" + `stop_count4` \
						+ " ANY(X):" + `any_count4` + dupl_frame4 + '\n' + my_string4 + '\n')
			if fract_fff4 > 0.70:
				fract_fff4 = str(round(fract_fff4,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff4 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk4 > 0.70:
				fract_kkk4 = str(round(fract_kkk4,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk4 + '\t' + "poly_KKK translation" + '\n')
		## 5
		if full_frame5 == "SINGLE_ORF":
			if full_frame5 == full_frame1:
				dupl_frame5 = " NOT_UNIQ"
			if full_frame5 == full_frame2:
				dupl_frame5 = " NOT_UNIQ"
			if full_frame5 == full_frame3:
				dupl_frame5 = " NOT_UNIQ"
			if full_frame5 == full_frame4:
				dupl_frame5 = " NOT_UNIQ"
			if full_frame5 == full_frame6:
				dupl_frame5 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff5 = my_string5.count("F")
			count_kkk5 = my_string5.count("K")
			fract_fff5 = count_fff5*1.0/total_size5
			fract_kkk5 = count_kkk5*1.0/total_size5
			if fract_fff5 <= 0.70 and fract_kkk5 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr5 " + `total_size5` + " STOP:" + `stop_count5` \
						+ " ANY(X):" + `any_count5` + dupl_frame5 + '\n' + my_string5 + '\n')
			if fract_fff5 > 0.70:
				fract_fff5 = str(round(fract_fff5,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff5 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk5 > 0.70:
				fract_kkk5 = str(round(fract_kkk5,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk5 + '\t' + "poly_KKK translation" + '\n')
		## 6
		if full_frame6 == "SINGLE_ORF":
			if full_frame6 == full_frame1:
				dupl_frame6 = " NOT_UNIQ"
			if full_frame6 == full_frame2:
				dupl_frame6 = " NOT_UNIQ"
			if full_frame6 == full_frame3:
				dupl_frame6 = " NOT_UNIQ"
			if full_frame6 == full_frame4:
				dupl_frame6 = " NOT_UNIQ"
			if full_frame6 == full_frame5:
				dupl_frame6 = " NOT_UNIQ"
			### CHECK FOR POLY_A AND POLY_T ( ..FFFFF.. OR ..KKKKK.. ) ###
			count_fff6 = my_string6.count("F")
			count_kkk6 = my_string6.count("K")
			fract_fff6 = count_fff6*1.0/total_size6
			fract_kkk6 = count_kkk6*1.0/total_size6
			if fract_fff6 <= 0.70 and fract_kkk6 <= 0.70:
				gl_s_file10.write(">" + proper_id + "_fr6 " + `total_size6` + " STOP:" + `stop_count6` \
						+ " ANY(X):" + `any_count6` + dupl_frame6 + '\n' + my_string6 + '\n')
			if fract_fff6 > 0.70:
				fract_fff6 = str(round(fract_fff6,2))
				gl_l0_file9.write(proper_id + '\t' + fract_fff6 + '\t' + "poly_FFF translation" + '\n')
			if fract_kkk6 > 0.70:
				fract_kkk6 = str(round(fract_kkk6,2))
				gl_l0_file9.write(proper_id + '\t' + fract_kkk6 + '\t' + "poly_KKK translation" + '\n')
		#############################

	###         END OF TRANSLATION         ###
	##########################################

def Seqs_Nficator(have_seqs):


	non_atgc_list = [ 'B', 'D', 'E', 'F', 'H', 'I', 'J', 'K', 'L', 'M', \
			'O', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'X', 'Y', 'Z' ]

	have_seqs = string.upper(have_seqs)
	for dummy_letter in non_atgc_list:
		have_seqs = re.sub(dummy_letter, "N", have_seqs)

	return have_seqs


def Seqs_Cleaner(in_name, out_name, seq_type, trans_fr, gen_code, bin_mode, seqs_min_len):

	global  gl_tr_file1, gl_tr_file2, gl_tr_file3, \
		gl_tr_file4, gl_tr_file5, gl_tr_file6, \
		gl_fw_file7, gl_rc_file8, gl_l0_file9, \
		gl_l1_file9, gl_l2_file9, gl_l3_file9, \
		gl_l4_file9, gl_l5_file9, gl_l6_file9, \
		gl_ls_file9, gl_s_file10, gl_l_file10, \
		tab_out1, tab_out2

	print ""
	print in_name + ' ' + out_name
	print ""

	in_file  = open(in_name,  "rb")
	out_file = open(out_name + '.fasta', "wb")
	out_stat = open(out_name + '.stat',  "wb")
	out_tab  = open(out_name + '.tab',   "wb")
	if bin_mode == "BIN" and seq_type == "DNA":
		out_bin1 = open(out_name + '.01BIN', "wb")
		out_bin2 = open(out_name + '.02BIN', "wb")
		out_dna1 = open(out_name + '.01DNA', "wb")
		out_dna2 = open(out_name + '.02DNA', "wb")
		out_tab3 = open(out_name + '.01TAB', "wb")

	agct_list   = ["A", "G", "C", "T"]
	binary_list = ["00", "01", "10", "11"]

	if seq_type == "DNA":

		### ACTIVATION OF CODON USAGE TABLE ###
		if trans_fr != 0:
			if gen_code == 1:
				CodonTranslation1()
			if gen_code == 2:
				CodonTranslation2()
			if gen_code == 3:
				CodonTranslation3()
			###########################
			if trans_fr == 1:
				gl_tr_file1 = open(out_name + '.tr_frame1', "wb")
				gl_fw_file7 = open(out_name + '.forwrd', "wb")
				gl_rc_file8 = open(out_name + '.revcom', "wb")
				gl_l0_file9 = open(out_name + '.x0_log', "wb")
				gl_l1_file9 = open(out_name + '.x1_log', "wb")
				gl_s_file10 = open(out_name + '.tr_single_frame', "wb")
				gl_l_file10 = open(out_name + '.tr_longest_frame', "wb")
				tab_out1    = open(out_name + '.tab_frw', "wb")
				tab_out2    = open(out_name + '.tab_rev', "wb")
				# tab_out3    = open(out_name + '.01TAB', "wb")
				gl_l1_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
			if trans_fr == 3:
				gl_tr_file1 = open(out_name + '.tr_frame1', "wb")
				gl_tr_file2 = open(out_name + '.tr_frame2', "wb")
				gl_tr_file3 = open(out_name + '.tr_frame3', "wb")
				gl_fw_file7 = open(out_name + '.forwrd', "wb")
				gl_rc_file8 = open(out_name + '.revcom', "wb")
				gl_l0_file9 = open(out_name + '.x0_log', "wb")
				gl_l1_file9 = open(out_name + '.x1_log', "wb")
				gl_l2_file9 = open(out_name + '.x2_log', "wb")
				gl_l3_file9 = open(out_name + '.x3_log', "wb")
				gl_ls_file9 = open(out_name + '.xx_log', "wb")
				gl_s_file10 = open(out_name + '.tr_single_frame', "wb")
				gl_l_file10 = open(out_name + '.tr_longest_frame', "wb")
				tab_out1    = open(out_name + '.tab_frw', "wb")
				tab_out2    = open(out_name + '.tab_rev', "wb")
				# tab_out3    = open(out_name + '.01TAB', "wb")
				gl_l1_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l2_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l3_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_ls_file9.write("SEQ_ID" + '\t' + \
					"FRAME1" + '\t' + "STOP1" + '\t' + "ANY1" + \
					'\t' + "LONGEST1" + '\t' + "TOTAL1" + '\t' + "ORFs1" + '\t' + \
					"FRAME2" + '\t' + "STOP2" + '\t' + "ANY2" + \
					'\t' + "LONGEST2" + '\t' + "TOTAL2" + '\t' + "ORFs2" + '\t' + \
					"FRAME3" + '\t' + "STOP3" + '\t' + "ANY3" + \
					'\t' + "LONGEST3" + '\t' + "TOTAL3" + '\t' + "ORFs3" + '\t' + \
					"LONGEST" + '\t' + "FRAME" + '\t' + "DUPL" + '\n')
			if trans_fr == 6:
				gl_tr_file1 = open(out_name + '.tr_frame1', "wb")
				gl_tr_file2 = open(out_name + '.tr_frame2', "wb")
				gl_tr_file3 = open(out_name + '.tr_frame3', "wb")
				gl_tr_file4 = open(out_name + '.tr_frame4', "wb")
				gl_tr_file5 = open(out_name + '.tr_frame5', "wb")
				gl_tr_file6 = open(out_name + '.tr_frame6', "wb")
				gl_fw_file7 = open(out_name + '.forwrd', "wb")
				gl_rc_file8 = open(out_name + '.revcom', "wb")
				gl_l0_file9 = open(out_name + '.x0_log', "wb")
				gl_l1_file9 = open(out_name + '.x1_log', "wb")
				gl_l2_file9 = open(out_name + '.x2_log', "wb")
				gl_l3_file9 = open(out_name + '.x3_log', "wb")
				gl_l4_file9 = open(out_name + '.x4_log', "wb")
				gl_l5_file9 = open(out_name + '.x5_log', "wb")
				gl_l6_file9 = open(out_name + '.x6_log', "wb")
				gl_ls_file9 = open(out_name + '.xx_log', "wb")
				gl_s_file10 = open(out_name + '.tr_single_frame', "wb")
				gl_l_file10 = open(out_name + '.tr_longest_frame', "wb")
				tab_out1    = open(out_name + '.tab_frw', "wb")
				tab_out2    = open(out_name + '.tab_rev', "wb")
				# tab_out3    = open(out_name + '.01TAB', "wb")
				gl_l1_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l2_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l3_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l4_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l5_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_l6_file9.write("SEQ_ID" + '\t' + "FRAME" + '\t' + "STOP" + '\t' + "ANY" + \
					'\t' + "LONGEST" + '\t' + "TOTAL" + '\t' + "ORFs" + '\n')
				gl_ls_file9.write("SEQ_ID" + '\t' + \
					"FRAME1" + '\t' + "STOP1" + '\t' + "ANY1" + \
					'\t' + "LONGEST1" + '\t' + "TOTAL1" + '\t' + "ORFs1" + '\t' + \
					"FRAME2" + '\t' + "STOP2" + '\t' + "ANY2" + \
					'\t' + "LONGEST2" + '\t' + "TOTAL2" + '\t' + "ORFs2" + '\t' + \
					"FRAME3" + '\t' + "STOP3" + '\t' + "ANY3" + \
					'\t' + "LONGEST3" + '\t' + "TOTAL3" + '\t' + "ORFs3" + '\t' + \
					"FRAME4" + '\t' + "STOP4" + '\t' + "ANY4" + \
					'\t' + "LONGEST4" + '\t' + "TOTAL4" + '\t' + "ORFs4" + '\t' + \
					"FRAME5" + '\t' + "STOP5" + '\t' + "ANY5" + \
					'\t' + "LONGEST5" + '\t' + "TOTAL5" + '\t' + "ORFs5" + '\t' + \
					"FRAME6" + '\t' + "STOP6" + '\t' + "ANY6" + \
					'\t' + "LONGEST6" + '\t' + "TOTAL6" + '\t' + "ORFs6" + '\t' + \
					"LONGEST" + '\t' + "FRAME" + '\t' + "DUPL" + '\n')
			###########################

		### HEADER OF OUTPUT FILE ###
		out_stat.write("#SEQ_ID" + '\t' + "LENGTH" + '\t' + " A " + '\t' + " T " + '\t' + \
				" G " + '\t' + " C " + '\t' + "AT" + '\t' + "GC" + '\t' \
				+ "ATGC" + '\t' + " N " + '\t' + " X " + '\n')
	if seq_type == "prot":
		trans_fr = 0
		out_stat.write("#SEQ_ID" + '\t' + "LENGTH" + '\t' + \
				" A " + '\t' + " B " + '\t' + \
				" C " + '\t' + " D " + '\t' + \
				" E " + '\t' + " F " + '\t' + \
				" G " + '\t' + " H " + '\t' + \
				" I " + '\t' + " J " + '\t' + \
				" K " + '\t' + " L " + '\t' + \
				" M " + '\t' + " N " + '\t' + \
				" O " + '\t' + " P " + '\t' + \
				" Q " + '\t' + " R " + '\t' + \
				" S " + '\t' + " T " + '\t' + \
				" U " + '\t' + " V " + '\t' + \
				" W " + '\t' + " X " + '\t' + \
				" Y " + '\t' + " Z " + '\t' + \
				" * " + '\t' + "***" + '\t' + '\n')

	fasta_id_array = []
	line_counter = 0
	have_seqs = ""
	proper_id = ""
	my_seqs = []
	tot_len = 0
	a_tot = 0
	b_tot = 0
	c_tot = 0
	d_tot = 0
	e_tot = 0
	f_tot = 0
	g_tot = 0
	h_tot = 0
	i_tot = 0
	j_tot = 0
	k_tot = 0
	l_tot = 0
	m_tot = 0
	n_tot = 0
	o_tot = 0
	p_tot = 0
	q_tot = 0
	r_tot = 0
	s_tot = 0
	t_tot = 0
	u_tot = 0
	v_tot = 0
	w_tot = 0
	x_tot = 0
	y_tot = 0
	z_tot = 0
	stop_tot = 0

	while 1:
		t = in_file.readline()
		if t == '':
			###  SUB_SEQ FUNCTION  ###
			have_seqs = "".join(my_seqs)
			seqs_len = len(have_seqs)
			###   STRING PROCESSING   ###
			abc_up = ""
			if seqs_len != 0:
				have_seqs = "".join(my_seqs)
				seqs_len = len(have_seqs)
				tot_len = tot_len + seqs_len
				if seqs_len == 0:
					seqs_len = 1
				###   STRING PROCESSING   ###
				if seq_type == "DNA":
					have_seqs = Seqs_Nficator(have_seqs)
				abc_up = have_seqs.upper()
				###
				###  BINARY ###
				if bin_mode == "BIN" and seqs_len >= seqs_min_len and seq_type == "DNA":
					out_bin1.write(">" + proper_id + "_R REGULAR BINARY " + `seqs_len` + '\n')
					out_bin2.write(">" + proper_id + "_S SHIFTED BINARY " + `seqs_len` + '\n')
					out_tab3.write(proper_id + '\t')
					bin1_list = list(have_seqs)
					bin2_list = []
					for bin1_item in bin1_list:
						if bin1_item in agct_list:
							if bin1_item == "A":
								out_bin1.write("00")
								out_tab3.write("00" + '\t')
								bin2_list.append("00")
							if bin1_item == "G":
								out_bin1.write("01")
								out_tab3.write("01" + '\t')
								bin2_list.append("01")
							if bin1_item == "C":
								out_bin1.write("10")
								out_tab3.write("10" + '\t')
								bin2_list.append("10")
							if bin1_item == "T":
								out_bin1.write("11")
								out_tab3.write("11" + '\t')
								bin2_list.append("11")
						else:
							out_bin1.write("--")
							out_tab3.write("--" + '\t')
							bin2_list.append("--")
					out_bin1.write('\n')
					out_tab3.write('\n')
					# bin2tr_list = bin2_list[1:-1]
					bin2_list = "".join(bin2_list)
					# bin2tr_list = "".join(bin2tr_list)
					bin2tr_list = bin2_list[1:-1]
					# print bin2_list
					# print bin2tr_list
					out_bin2.write(bin2tr_list + '\n')
					### BIN END ###
					### BIN AGAIN ###
					k1 = 0
					k2 = 0
					l1 = len(bin2_list)
					l2 = len(bin2tr_list)
					out_dna1.write(">" + proper_id + "_R REGULAR DNA " + `seqs_len` + '\n')
					while k1 < l1:
						m1 = k1 + 2
						p1 = bin2_list[k1:m1]	# binary duplet
						if p1 in binary_list:
							if p1 == "00":
								out_dna1.write("A")
							if p1 == "01":
								out_dna1.write("G")
							if p1 == "10":
								out_dna1.write("C")
							if p1 == "11":
								out_dna1.write("T")
						else:
							out_dna1.write("N")
						k1 = k1 + 2
					out_dna1.write('\n')
					out_dna2.write(">" + proper_id + "_S SHIFTED DNA " + `seqs_len` + '\n')
					while k2 < l2:
						m2 = k2 + 2
						p2 = bin2tr_list[k2:m2]	# binary duplet
						if p2 in binary_list:
							if p2 == "00":
								out_dna2.write("A")
							if p2 == "01":
								out_dna2.write("G")
							if p2 == "10":
								out_dna2.write("C")
							if p2 == "11":
								out_dna2.write("T")
						else:
							out_dna2.write("N")
						k2 = k2 + 2
					out_dna2.write('\n')
					###  *******  ###
				###
				a_count = abc_up.count("A")
				a_tot = a_tot + a_count
				###
				b_count = abc_up.count("B")
				b_tot = b_tot + b_count
				###
				c_count = abc_up.count("C")
				c_tot = c_tot + c_count
				###
				d_count = abc_up.count("D")
				d_tot = d_tot + d_count
				###
				e_count = abc_up.count("E")
				e_tot = e_tot + e_count
				###
				f_count = abc_up.count("F")
				f_tot = f_tot + f_count
				###
				g_count = abc_up.count("G")
				g_tot = g_tot + g_count
				###
				h_count = abc_up.count("H")
				h_tot = h_tot + h_count
				###
				i_count = abc_up.count("I")
				i_tot = i_tot + i_count
				###
				j_count = abc_up.count("J")
				j_tot = j_tot + j_count
				###
				k_count = abc_up.count("K")
				k_tot = k_tot + k_count
				###
				l_count = abc_up.count("L")
				l_tot = l_tot + l_count
				###
				m_count = abc_up.count("M")
				m_tot = m_tot + m_count
				###
				n_count = abc_up.count("N")
				n_tot = n_tot + n_count
				###
				o_count = abc_up.count("O")
				o_tot = o_tot + o_count
				###
				p_count = abc_up.count("P")
				p_tot = p_tot + p_count
				###
				q_count = abc_up.count("Q")
				q_tot = q_tot + q_count
				###
				r_count = abc_up.count("R")
				r_tot = r_tot + r_count
				###
				s_count = abc_up.count("S")
				s_tot = s_tot + s_count
				###
				t_count = abc_up.count("T")
				t_tot = t_tot + t_count
				###
				u_count = abc_up.count("U")
				u_tot = u_tot + u_count
				###
				v_count = abc_up.count("V")
				v_tot = v_tot + v_count
				###
				w_count = abc_up.count("W")
				w_tot = w_tot + w_count
				###
				x_count = abc_up.count("X")
				x_tot = x_tot + x_count
				###
				y_count = abc_up.count("Y")
				y_tot = y_tot + y_count
				###
				z_count = abc_up.count("Z")
				z_tot = z_tot + z_count
				###
				stop_count = abc_up.count("*")
				stop_tot = stop_tot + stop_count
				###
				a_fract = round((a_count*100.00/seqs_len),2)
				b_fract = round((b_count*100.00/seqs_len),2)
				c_fract = round((c_count*100.00/seqs_len),2)
				d_fract = round((d_count*100.00/seqs_len),2)
				e_fract = round((e_count*100.00/seqs_len),2)
				f_fract = round((f_count*100.00/seqs_len),2)
				g_fract = round((g_count*100.00/seqs_len),2)
				h_fract = round((h_count*100.00/seqs_len),2)
				i_fract = round((i_count*100.00/seqs_len),2)
				j_fract = round((j_count*100.00/seqs_len),2)
				k_fract = round((k_count*100.00/seqs_len),2)
				l_fract = round((l_count*100.00/seqs_len),2)
				m_fract = round((m_count*100.00/seqs_len),2)
				n_fract = round((n_count*100.00/seqs_len),2)
				o_fract = round((o_count*100.00/seqs_len),2)
				p_fract = round((p_count*100.00/seqs_len),2)
				q_fract = round((q_count*100.00/seqs_len),2)
				r_fract = round((r_count*100.00/seqs_len),2)
				s_fract = round((s_count*100.00/seqs_len),2)
				t_fract = round((t_count*100.00/seqs_len),2)
				u_fract = round((u_count*100.00/seqs_len),2)
				v_fract = round((v_count*100.00/seqs_len),2)
				w_fract = round((w_count*100.00/seqs_len),2)
				x_fract = round((x_count*100.00/seqs_len),2)
				y_fract = round((y_count*100.00/seqs_len),2)
				z_fract = round((z_count*100.00/seqs_len),2)
				stop_fract = round((stop_count*100.00/seqs_len),2)
				###
				at_fract = a_fract + t_fract
				gc_fract = g_fract + c_fract
				atgc_fract = a_fract + t_fract + g_fract + c_fract
				# atgc_fract = round(atgc_fract)
				atgc_fract = round(atgc_fract,2)
				### STRING ###
				a_fract = str(a_fract) 
				b_fract = str(b_fract) 
				c_fract = str(c_fract) 
				d_fract = str(d_fract) 
				e_fract = str(e_fract) 
				f_fract = str(f_fract) 
				g_fract = str(g_fract) 
				h_fract = str(h_fract) 
				i_fract = str(i_fract) 
				j_fract = str(j_fract) 
				k_fract = str(k_fract) 
				l_fract = str(l_fract) 
				m_fract = str(m_fract) 
				n_fract = str(n_fract) 
				o_fract = str(o_fract) 
				p_fract = str(p_fract) 
				q_fract = str(q_fract) 
				r_fract = str(r_fract) 
				s_fract = str(s_fract) 
				t_fract = str(t_fract) 
				u_fract = str(u_fract) 
				v_fract = str(v_fract) 
				w_fract = str(w_fract) 
				x_fract = str(x_fract) 
				y_fract = str(y_fract) 
				z_fract = str(z_fract) 
				stop_fract = str(stop_fract)

				at_fract = str(at_fract)
				gc_fract = str(gc_fract)
				atgc_fract = str(atgc_fract)
				###    TRANSLATION     ###
				if trans_fr == 1 and seqs_len >= seqs_min_len:
					# print "TRANSLATION: " + `trans_fr` + " FRAME  -=- GENE CODE: " + `gen_code`
					Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code)
				if trans_fr == 3 and seqs_len >= seqs_min_len:
					# print "TRANSLATION: " + `trans_fr` + " FRAMES -=- GENE CODE: " + `gen_code`
					Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code)
				if trans_fr == 6 and seqs_len >= seqs_min_len:
					# print "TRANSLATION: " + `trans_fr` + " FRAMES -=- GENE CODE: " + `gen_code`
					Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code)
				### END OF TRANSLATION ###
				if seq_type == "DNA" and seqs_len >= seqs_min_len:
					out_stat.write(proper_id + '\t' + `seqs_len` + '\t' + a_fract + '\t' + t_fract + '\t' + \
							g_fract + '\t' + c_fract + '\t' + at_fract + '\t' + gc_fract + '\t' \
							+ atgc_fract + '\t' + 'N: ' + n_fract + '\t' + 'X: ' + x_fract + '\n')
				if seq_type == "prot" and seqs_len >= seqs_min_len:
					out_stat.write(proper_id + '\t' + `seqs_len` + '\t' + \
							a_fract + '\t' + b_fract + '\t' + \
							c_fract + '\t' + d_fract + '\t' + \
							e_fract + '\t' + f_fract + '\t' + \
							g_fract + '\t' + h_fract + '\t' + \
							i_fract + '\t' + j_fract + '\t' + \
							k_fract + '\t' + l_fract + '\t' + \
							m_fract + '\t' + n_fract + '\t' + \
							o_fract + '\t' + p_fract + '\t' + \
							q_fract + '\t' + r_fract + '\t' + \
							s_fract + '\t' + t_fract + '\t' + \
							u_fract + '\t' + v_fract + '\t' + \
							w_fract + '\t' + x_fract + '\t' + \
							y_fract + '\t' + z_fract + '\t' + \
							stop_fract + '\t' + `stop_count` + '\n')
			### STRING PROCESSING END ###
			# print seqs_len
			if have_seqs != "" and seqs_len >= seqs_min_len:
				out_file.write('>' + proper_id + ' ' + good_name + '\n')
				out_file.write(have_seqs + '\n')
				####  END OF SUB_SEQ  ####
				out_tab.write(proper_id + '\t' + `seqs_len` + '\t' + have_seqs + '\n')
				##########################
				break
		if '\n' in t:
			t = t[:-1]
		if '\r' in t:
			t = t[:-1]

		fasta_match = t[0:1]
		if fasta_match == ">":
			gi_test = t[0:4]
			if gi_test == ">gi|":
				# print gi_test
				descr_line = t
				###   REPLACE ALL TABS WITH WHITESPACES   ###
				descr_line = re.sub('\t', " ", descr_line)
				#############################################
				descr_line = re.sub("^>gi\|", "", descr_line)
				descr_line = re.sub("\|", '\t', descr_line, 1)
				# print line_counter
				line_counter += 1
			else:
				descr_line = t
				###   REPLACE ALL TABS WITH WHITESPACES   ###
				descr_line = re.sub('\t', " ", descr_line)
				#############################################
				descr_line = re.sub("^>", "", descr_line)
				descr_line = re.sub("\|", " ", descr_line, 1)
				descr_line = re.sub(" ", '\t', descr_line, 1)
				# print line_counter
				line_counter = line_counter + 1
			good_head = string.split(descr_line, '\t')[0]
			try:
				long_tail = string.split(descr_line, '\t')[1]
			except:
				long_tail = ""
			###############################
			dupl_status = "GOOD"
			###############################
			if good_head in fasta_id_array:
				dupl_status = "BAD"
				running_text = "\
\n\n  Ooops... ID duplication  \n\n  check input for duplications  \n\n\n ID: " + good_head + "\n\n\n"
				print running_text
				###
				### INSERT TKINTER TEXT MESSAGE BOX
				###
				break
			fasta_id_array.append(good_head)
			print `line_counter` + '\t' + good_head
			if line_counter != 1:
				abc_up = ""
				###  SUB_SEQ FUNCTION  ###
				have_seqs = "".join(my_seqs)
				seqs_len = len(have_seqs)
				tot_len = tot_len + seqs_len
				if seqs_len == 0:
					seqs_len = 1
				###   STRING PROCESSING   ###
				if seq_type == "DNA":
					have_seqs = Seqs_Nficator(have_seqs)
				abc_up = have_seqs.upper()
				###
				###  BINARY ###
				if bin_mode == "BIN" and seqs_len >= seqs_min_len and seq_type == "DNA":
					out_bin1.write(">" + proper_id + "_R REGULAR BINARY " + `seqs_len` + '\n')
					out_bin2.write(">" + proper_id + "_S SHIFTED BINARY " + `seqs_len` + '\n')
					out_tab3.write(proper_id + '\t')
					bin1_list = list(have_seqs)
					bin2_list = []
					for bin1_item in bin1_list:
						if bin1_item in agct_list:
							if bin1_item == "A":
								out_bin1.write("00")
								out_tab3.write("00" + '\t')
								bin2_list.append("00")
							if bin1_item == "G":
								out_bin1.write("01")
								out_tab3.write("01" + '\t')
								bin2_list.append("01")
							if bin1_item == "C":
								out_bin1.write("10")
								out_tab3.write("10" + '\t')
								bin2_list.append("10")
							if bin1_item == "T":
								out_bin1.write("11")
								out_tab3.write("11" + '\t')
								bin2_list.append("11")
						else:
							out_bin1.write("--")
							out_tab3.write("--" + '\t')
							bin2_list.append("--")
					out_bin1.write('\n')
					out_tab3.write('\n')
					# bin2tr_list = bin2_list[1:-1]
					bin2_list = "".join(bin2_list)
					# bin2tr_list = "".join(bin2tr_list)
					bin2tr_list = bin2_list[1:-1]
					# print bin2_list
					# print bin2tr_list
					out_bin2.write(bin2tr_list + '\n')
					### BIN END ###
					### BIN AGAIN ###
					k1 = 0
					k2 = 0
					l1 = len(bin2_list)
					l2 = len(bin2tr_list)
					out_dna1.write(">" + proper_id + "_R REGULAR DNA " + `seqs_len` + '\n')
					while k1 < l1:
						m1 = k1 + 2
						p1 = bin2_list[k1:m1]	# binary duplet
						if p1 in binary_list:
							if p1 == "00":
								out_dna1.write("A")
							if p1 == "01":
								out_dna1.write("G")
							if p1 == "10":
								out_dna1.write("C")
							if p1 == "11":
								out_dna1.write("T")
						else:
							out_dna1.write("N")
						k1 = k1 + 2
					out_dna1.write('\n')
					out_dna2.write(">" + proper_id + "_S SHIFTED DNA " + `seqs_len` + '\n')
					while k2 < l2:
						m2 = k2 + 2
						p2 = bin2tr_list[k2:m2]	# binary duplet
						if p2 in binary_list:
							if p2 == "00":
								out_dna2.write("A")
							if p2 == "01":
								out_dna2.write("G")
							if p2 == "10":
								out_dna2.write("C")
							if p2 == "11":
								out_dna2.write("T")
						else:
							out_dna2.write("N")
						k2 = k2 + 2
					out_dna2.write('\n')
					###  *******  ###
				###
				a_count = abc_up.count("A")
				a_tot = a_tot + a_count
				###
				b_count = abc_up.count("B")
				b_tot = b_tot + b_count
				###
				c_count = abc_up.count("C")
				c_tot = c_tot + c_count
				###
				d_count = abc_up.count("D")
				d_tot = d_tot + d_count
				###
				e_count = abc_up.count("E")
				e_tot = e_tot + e_count
				###
				f_count = abc_up.count("F")
				f_tot = f_tot + f_count
				###
				g_count = abc_up.count("G")
				g_tot = g_tot + g_count
				###
				h_count = abc_up.count("H")
				h_tot = h_tot + h_count
				###
				i_count = abc_up.count("I")
				i_tot = i_tot + i_count
				###
				j_count = abc_up.count("J")
				j_tot = j_tot + j_count
				###
				k_count = abc_up.count("K")
				k_tot = k_tot + k_count
				###
				l_count = abc_up.count("L")
				l_tot = l_tot + l_count
				###
				m_count = abc_up.count("M")
				m_tot = m_tot + m_count
				###
				n_count = abc_up.count("N")
				n_tot = n_tot + n_count
				###
				o_count = abc_up.count("O")
				o_tot = o_tot + o_count
				###
				p_count = abc_up.count("P")
				p_tot = p_tot + p_count
				###
				q_count = abc_up.count("Q")
				q_tot = q_tot + q_count
				###
				r_count = abc_up.count("R")
				r_tot = r_tot + r_count
				###
				s_count = abc_up.count("S")
				s_tot = s_tot + s_count
				###
				t_count = abc_up.count("T")
				t_tot = t_tot + t_count
				###
				u_count = abc_up.count("U")
				u_tot = u_tot + u_count
				###
				v_count = abc_up.count("V")
				v_tot = v_tot + v_count
				###
				w_count = abc_up.count("W")
				w_tot = w_tot + w_count
				###
				x_count = abc_up.count("X")
				x_tot = x_tot + x_count
				###
				y_count = abc_up.count("Y")
				y_tot = y_tot + y_count
				###
				z_count = abc_up.count("Z")
				z_tot = z_tot + z_count
				###
				stop_count = abc_up.count("*")
				stop_tot = stop_tot + stop_count
				###
				a_fract = round((a_count*100.00/seqs_len),2)
				b_fract = round((b_count*100.00/seqs_len),2)
				c_fract = round((c_count*100.00/seqs_len),2)
				d_fract = round((d_count*100.00/seqs_len),2)
				e_fract = round((e_count*100.00/seqs_len),2)
				f_fract = round((f_count*100.00/seqs_len),2)
				g_fract = round((g_count*100.00/seqs_len),2)
				h_fract = round((h_count*100.00/seqs_len),2)
				i_fract = round((i_count*100.00/seqs_len),2)
				j_fract = round((j_count*100.00/seqs_len),2)
				k_fract = round((k_count*100.00/seqs_len),2)
				l_fract = round((l_count*100.00/seqs_len),2)
				m_fract = round((m_count*100.00/seqs_len),2)
				n_fract = round((n_count*100.00/seqs_len),2)
				o_fract = round((o_count*100.00/seqs_len),2)
				p_fract = round((p_count*100.00/seqs_len),2)
				q_fract = round((q_count*100.00/seqs_len),2)
				r_fract = round((r_count*100.00/seqs_len),2)
				s_fract = round((s_count*100.00/seqs_len),2)
				t_fract = round((t_count*100.00/seqs_len),2)
				u_fract = round((u_count*100.00/seqs_len),2)
				v_fract = round((v_count*100.00/seqs_len),2)
				w_fract = round((w_count*100.00/seqs_len),2)
				x_fract = round((x_count*100.00/seqs_len),2)
				y_fract = round((y_count*100.00/seqs_len),2)
				z_fract = round((z_count*100.00/seqs_len),2)
				stop_fract = round((stop_count*100.00/seqs_len),2)
				###
				at_fract = a_fract + t_fract
				gc_fract = g_fract + c_fract
				atgc_fract = a_fract + t_fract + g_fract + c_fract
				# atgc_fract = round(atgc_fract)
				atgc_fract = round(atgc_fract,2)
				### STRING ###
				a_fract = str(a_fract) 
				b_fract = str(b_fract) 
				c_fract = str(c_fract) 
				d_fract = str(d_fract) 
				e_fract = str(e_fract) 
				f_fract = str(f_fract) 
				g_fract = str(g_fract) 
				h_fract = str(h_fract) 
				i_fract = str(i_fract) 
				j_fract = str(j_fract) 
				k_fract = str(k_fract) 
				l_fract = str(l_fract) 
				m_fract = str(m_fract) 
				n_fract = str(n_fract) 
				o_fract = str(o_fract) 
				p_fract = str(p_fract) 
				q_fract = str(q_fract) 
				r_fract = str(r_fract) 
				s_fract = str(s_fract) 
				t_fract = str(t_fract) 
				u_fract = str(u_fract) 
				v_fract = str(v_fract) 
				w_fract = str(w_fract) 
				x_fract = str(x_fract) 
				y_fract = str(y_fract) 
				z_fract = str(z_fract) 
				stop_fract = str(stop_fract) 

				at_fract = str(at_fract)
				gc_fract = str(gc_fract)
				atgc_fract = str(atgc_fract)
				###    TRANSLATION     ###
				if trans_fr == 1 and seqs_len >= seqs_min_len:
					# print "TRANSLATION: " + `trans_fr` + " FRAME  -=- GENE CODE: " + `gen_code`
					Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code)
				if trans_fr == 3 and seqs_len >= seqs_min_len:
					# print "TRANSLATION: " + `trans_fr` + " FRAMES -=- GENE CODE: " + `gen_code`
					Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code)
				if trans_fr == 6 and seqs_len >= seqs_min_len:
					# print "TRANSLATION: " + `trans_fr` + " FRAMES -=- GENE CODE: " + `gen_code`
					Seqs_Translator(proper_id, have_seqs, trans_fr, gen_code)
				### END OF TRANSLATION ###
				if seq_type == "DNA" and seqs_len >= seqs_min_len:
					out_stat.write(proper_id + '\t' + `seqs_len` + '\t' + a_fract + '\t' + t_fract + '\t' + \
							g_fract + '\t' + c_fract + '\t' + at_fract + '\t' + gc_fract + '\t' \
							+ atgc_fract + '\t' + 'N: ' + n_fract + '\t' + 'X: ' + x_fract + '\n')
				if seq_type == "prot" and seqs_len >= seqs_min_len:
					out_stat.write(proper_id + '\t' + `seqs_len` + '\t' + \
							a_fract + '\t' + b_fract + '\t' + \
							c_fract + '\t' + d_fract + '\t' + \
							e_fract + '\t' + f_fract + '\t' + \
							g_fract + '\t' + h_fract + '\t' + \
							i_fract + '\t' + j_fract + '\t' + \
							k_fract + '\t' + l_fract + '\t' + \
							m_fract + '\t' + n_fract + '\t' + \
							o_fract + '\t' + p_fract + '\t' + \
							q_fract + '\t' + r_fract + '\t' + \
							s_fract + '\t' + t_fract + '\t' + \
							u_fract + '\t' + v_fract + '\t' + \
							w_fract + '\t' + x_fract + '\t' + \
							y_fract + '\t' + z_fract + '\t' + \
							stop_fract + '\t' + `stop_count` + '\n')
				### STRING PROCESSING END ###
				# print seqs_len
				if have_seqs != "" and seqs_len >= seqs_min_len:
					out_file.write('>' + proper_id + ' ' + good_name + '\n')
					out_file.write(have_seqs + '\n')
					####  END OF SUB_SEQ  ####
					out_tab.write(proper_id + '\t' + `seqs_len` + '\t' + have_seqs + '\n')
				##########################
			have_seqs = ""
			my_seqs = []
		if fasta_match != ">" and fasta_match != "" and dupl_status == "GOOD":
			proper_id = good_head
			good_name = long_tail
			my_seqs.append(t)

	a_fract_tot = round((a_tot*100.00/tot_len),2)
	b_fract_tot = round((b_tot*100.00/tot_len),2)
	c_fract_tot = round((c_tot*100.00/tot_len),2)
	d_fract_tot = round((d_tot*100.00/tot_len),2)
	e_fract_tot = round((e_tot*100.00/tot_len),2)
	f_fract_tot = round((f_tot*100.00/tot_len),2)
	g_fract_tot = round((g_tot*100.00/tot_len),2)
	h_fract_tot = round((h_tot*100.00/tot_len),2)
	i_fract_tot = round((i_tot*100.00/tot_len),2)
	j_fract_tot = round((j_tot*100.00/tot_len),2)
	k_fract_tot = round((k_tot*100.00/tot_len),2)
	l_fract_tot = round((l_tot*100.00/tot_len),2)
	m_fract_tot = round((m_tot*100.00/tot_len),2)
	n_fract_tot = round((n_tot*100.00/tot_len),2)
	o_fract_tot = round((o_tot*100.00/tot_len),2)
	p_fract_tot = round((p_tot*100.00/tot_len),2)
	q_fract_tot = round((q_tot*100.00/tot_len),2)
	r_fract_tot = round((r_tot*100.00/tot_len),2)
	s_fract_tot = round((s_tot*100.00/tot_len),2)
	t_fract_tot = round((t_tot*100.00/tot_len),2)
	u_fract_tot = round((u_tot*100.00/tot_len),2)
	v_fract_tot = round((v_tot*100.00/tot_len),2)
	w_fract_tot = round((w_tot*100.00/tot_len),2)
	x_fract_tot = round((x_tot*100.00/tot_len),2)
	y_fract_tot = round((y_tot*100.00/tot_len),2)
	z_fract_tot = round((z_tot*100.00/tot_len),2)
	stop_fract_tot = round((stop_tot*100.00/tot_len),2)

	###
	at_fract_tot = a_fract_tot + t_fract_tot
	gc_fract_tot = g_fract_tot + c_fract_tot
	atgc_fract_tot = a_fract_tot + t_fract_tot + g_fract_tot + c_fract_tot
	# atgc_fract_tot = round(atgc_fract_tot)
	atgc_fract_tot = round(atgc_fract_tot,2)
	### STRING ###
	a_fract_tot = str(a_fract_tot) 
	b_fract_tot = str(b_fract_tot) 
	c_fract_tot = str(c_fract_tot) 
	d_fract_tot = str(d_fract_tot) 
	e_fract_tot = str(e_fract_tot) 
	f_fract_tot = str(f_fract_tot) 
	g_fract_tot = str(g_fract_tot) 
	h_fract_tot = str(h_fract_tot) 
	i_fract_tot = str(i_fract_tot) 
	j_fract_tot = str(j_fract_tot) 
	k_fract_tot = str(k_fract_tot) 
	l_fract_tot = str(l_fract_tot) 
	m_fract_tot = str(m_fract_tot) 
	n_fract_tot = str(n_fract_tot) 
	o_fract_tot = str(o_fract_tot) 
	p_fract_tot = str(p_fract_tot) 
	q_fract_tot = str(q_fract_tot) 
	r_fract_tot = str(r_fract_tot) 
	s_fract_tot = str(s_fract_tot) 
	t_fract_tot = str(t_fract_tot) 
	u_fract_tot = str(u_fract_tot) 
	v_fract_tot = str(v_fract_tot) 
	w_fract_tot = str(w_fract_tot) 
	x_fract_tot = str(x_fract_tot) 
	y_fract_tot = str(y_fract_tot) 
	z_fract_tot = str(z_fract_tot) 
	stop_fract_tot = str(stop_fract_tot) 

	at_fract_tot = str(at_fract_tot)
	gc_fract_tot = str(gc_fract_tot)
	atgc_fract_tot = str(atgc_fract_tot)
	###

	if seq_type == "DNA":
		out_stat.write("#TOTAL" + '\t' + `tot_len` + '\t' + a_fract_tot + '\t' + t_fract_tot + '\t' + \
				g_fract_tot + '\t' + c_fract_tot + '\t' + at_fract_tot + '\t' + gc_fract_tot + '\t' \
				+ atgc_fract_tot + '\t' + 'N: ' + n_fract_tot + '\t' + 'X: ' + x_fract_tot + '\n')
	if seq_type == "prot":
		out_stat.write("#TOTAL" + '\t' + `tot_len` + '\t' + \
				a_fract_tot + '\t' + b_fract_tot + '\t' + \
				c_fract_tot + '\t' + d_fract_tot + '\t' + \
				e_fract_tot + '\t' + f_fract_tot + '\t' + \
				g_fract_tot + '\t' + h_fract_tot + '\t' + \
				i_fract_tot + '\t' + j_fract_tot + '\t' + \
				k_fract_tot + '\t' + l_fract_tot + '\t' + \
				m_fract_tot + '\t' + n_fract_tot + '\t' + \
				o_fract_tot + '\t' + p_fract_tot + '\t' + \
				q_fract_tot + '\t' + r_fract_tot + '\t' + \
				s_fract_tot + '\t' + t_fract_tot + '\t' + \
				u_fract_tot + '\t' + v_fract_tot + '\t' + \
				w_fract_tot + '\t' + x_fract_tot + '\t' + \
				y_fract_tot + '\t' + z_fract_tot + '\t' + \
				stop_fract_tot + '\t' + `stop_tot` + '\n')

	in_file.close()
	out_file.close()
	out_stat.close()
	out_tab.close()
	if bin_mode == "BIN":
		out_bin1.close()
		out_bin2.close()
		out_dna1.close()
		out_dna2.close()
		out_tab3.close()

	if trans_fr == 1:
		gl_tr_file1.close()
		gl_fw_file7.close()
		gl_rc_file8.close()
		gl_l0_file9.close()
		gl_l1_file9.close()
		gl_s_file10.close()
		gl_l_file10.close()
		tab_out1.close()
		tab_out2.close()
	if trans_fr == 3:
		gl_tr_file1.close()
		gl_tr_file2.close()
		gl_tr_file3.close()
		gl_fw_file7.close()
		gl_rc_file8.close()
		gl_l0_file9.close()
		gl_l1_file9.close()
		gl_l2_file9.close()
		gl_l3_file9.close()
		gl_ls_file9.close()
		gl_s_file10.close()
		gl_l_file10.close()
		tab_out1.close()
		tab_out2.close()
	if trans_fr == 6:
		gl_tr_file1.close()
		gl_tr_file2.close()
		gl_tr_file3.close()
		gl_tr_file4.close()
		gl_tr_file5.close()
		gl_tr_file6.close()
		gl_fw_file7.close()
		gl_rc_file8.close()
		gl_l0_file9.close()
		gl_l1_file9.close()
		gl_l2_file9.close()
		gl_l3_file9.close()
		gl_l4_file9.close()
		gl_l5_file9.close()
		gl_l6_file9.close()
		gl_ls_file9.close()
		gl_s_file10.close()
		gl_l_file10.close()
		tab_out1.close()
		tab_out2.close()


	print ""
	print "  PROCESSING DONE  "
	print ""

####### MAIN BODY ##############

import math
import re
import sys
import string
import time

if __name__ == "__main__":

	if len(sys.argv) == 2 and sys.argv[1] == "help":
		HelpTranslation()
		sys.exit()
	
	if len(sys.argv) <= 7 or len(sys.argv) > 8:
		print ""
		print "  Program usage: "
		print "  input_file  output_file  DNA/prot  trans_frame[0 1 3 6]  genetic_code[1 2 3]  BIN/NOBIN  seqs_min_len"
		print "  Script counts \"ATGC\" content in FASTA file"
		print "  and translate DNA sequence into protein"
		print "  0 - no translation; 1 - first frame"
		print "  3 - three frames; 6 - all six frame"
		print "  Genetic Code: 1 - Standard; 2 - Vertebrate Mitochondrial; 3 - Yeast Mitochondrial"
		print "  BIN option - to generate 0100111010101001100 style DNA file "
		print ""
		print "  use argument \"help\" - for help"
		print ""
		sys.exit()
	if len(sys.argv) == 8:
		in_name  = sys.argv[1]
		out_name = sys.argv[2]
		seq_type = sys.argv[3]
		trans_fr = sys.argv[4]
		gen_code = sys.argv[5]
		bin_mode = sys.argv[6]
		seqs_min_len = sys.argv[7]
		trans_fr = int(trans_fr)
		gen_code = int(gen_code)
		seqs_min_len = int(seqs_min_len)
		if seqs_min_len < 12:
			print " MIN SEQS LENGTH MUST BE 12 OR GREATER "
			sys.exit()
		if trans_fr != 0 and trans_fr != 1 and trans_fr != 3 and trans_fr != 6:
			print "  TRANSLATION FRAME MUST BE 0 1 3 or 6"
			sys.exit()
		if gen_code != 1 and gen_code != 2 and gen_code != 3:
			print "  GENE CODE MUST BE 1 2 or 3"
			sys.exit()
		if bin_mode != "BIN" and bin_mode != "NOBIN":
			print " BIN/NOBIN argument must be BIN or NOBIN "
			sys.exit()
		if in_name != out_name:
			Seqs_Cleaner(in_name, out_name, seq_type, trans_fr, gen_code, bin_mode, seqs_min_len)
		else:
			print "Output should have different name than Input"
			sys.exit()
######### THE END ############

