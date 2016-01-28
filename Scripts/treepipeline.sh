#! /bin/bash

# This script makes phylogenetic trees based on maximum likelihood using .fasta files
# it can process both single markers and can concatinate multiple markers to produce a tree based on a longer sequence
# It also allows you to specify bootstrap values
# the file has been specified for algae and seagrasses, but the names can be altered

# Required programs that need to be installed before running the script:
# 	- PhyML
# 	- ClustalW
# 	- ETE toolkit
#	- Biopython

# Further requirements for the script to run:
# the scripts have to be placed in a folder named '~/scripts/'
# the script should run from a folder that contains the input
# the folder with input should contain: all the original fasta files per individual sample (.TXT),
# a fasta file per marker that contains all samples for that marker
# the names of the samples should not be larger than 10 charactrs (these will be truncated)
# the file names should not contain dashes ('-'), because this will give an error with the nexus combine tool
 

# This script has been made by Onno den Boon and Luna van der Loos


################### SCRIPT TO MAKE TREE ###############################

#Print contributors of this script to the screen
echo "######################## THE CONCATENATOR ########################"
echo " This script has been made by Onno den Boon and Luna van der Loos"

# Make a tree for every marker seperately
# The function Treemaker aligns (output = phylip) and calculates the most likely tree
# bootstrap values can be specified with $2
source treemaker.sh						# ...
Treemaker all_COI.fas 20 #for only COI				# ...
Treemaker all_UPA.fas 20 # for only UPA				# ...
Treemaker all_tufA.fas 20 # for only tufA			# Comment out this section to turn off 
Treemaker all_matK.fas 20 # for only matK			# the trees based on individual markers
Treemaker all_rbcL.fas 20 # for only rbcL			# ...
Treemaker all_LSUY.fas 20 #for only LSUY			# ...
Treemaker all_LSUD2D3.fas 20 #for only LSUD2D3			# ...

# To make a tree with all markers combined, a nexus file is required.
# Therefore, align again:
# Align with the Aligner function (aligner.sh). Input = .fas     Output = .nex (nexus)
source aligner.sh
Aligner all_COI.fas
Aligner all_tufA.fas
Aligner all_UPA.fas
Aligner all_matK.fas
Aligner all_rbcL.fas
Aligner all_LSUY.fas
Aligner all_LSUD2D3.fas

# Concatenate the sequences with a python script (concenatenatornexus2.py)
# The path to the folder where this script is running has to be specified in the python script
# As input, it will then take all files that end with .nex
# Output = combined.nex
~/scripts/concatenatornexus2.py

# To be able to calculate the most likely tree (with phyml), a phylip format is required.
# This will be done using the seqmagick tool.
# You have to delete the last 10 lines with information (this needs to be altered if you concatenate more or less markers) for seqmagick to work:
head -n -10 combined.nex > combined_use.nex
# Now use seqmagick to convert to phylip
seqmagick convert --output-format phylip --alphabet dna combined_use.nex combined.phy


# Now the tree of concatenated sequences can be made using the function Treemaker2
# bootstrap value can be specified in $2
source treemaker2.sh
Treemaker2 combined.phy 20

# The .svg images of the trees will be printed with a python script that uses ETE:
# the path to the folder where this script is running has to be specified in the python script
# As input, it will then take all files that end with tree.txt (the output of phyML)
~/scripts/ETE_treebuilder_from_nw.py


# This will tell which trees are made: (comment out the markers that have not been used)
echo "A tree for COI has been made"
echo "A tree for UPA has been made"
echo "A tree for tufA has been made"
echo "A tree for matK has been made"
echo "A tree for rcbL has been made"
echo "A tree for LSUY has been made"
echo "A tree for LSUD2D3 has been made"
echo "A tree of all markers combined has been made :-)"


# This calculates metrics to compare tree topology using ETE
ete3 compare -t all_COI.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt
ete3 compare -t all_UPA.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt
ete3 compare -t all_tufA.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt
ete3 compare -t all_matK.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt
ete3 compare -t all_rbcL.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt
ete3 compare -t all_LSUY.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt
ete3 compare -t all_LSUD2D3.fas.phy_phyml_tree.txt -r combined.phy_phyml_tree.txt --unrooted >> comparetree.txt


############################# INFORMATION #############################
# This will print information about the sequences that have been used for the trees

echo "Information about the sequences used to make the trees:"

# This will take all sequences from the folder where this script is running and copy it to a file
cat *.txt > all_seq.txt

# This will then print information to the screen, using the all_seq.txt file:
echo "Number of sequences: "
grep ">" all_seq.txt | wc -l
echo "Names of markers: "
grep ">" all_seq.txt | cut -f 5,6,7 -d "_" | sort | uniq
echo "Number of markers: "
grep ">" all_seq.txt | cut -f 5,6,7 -d "_" | sort | uniq | wc -l
echo "Number of sequences per marker: "
grep ">" all_seq.txt | cut -f 5,6,7 -d "_" | sort | uniq -c
echo "Number of uniqe samples"
grep ">" all_seq.txt | cut -f 1,2,3 -d "_" | sort | uniq | wc -l
echo "Number of markers used per unique sample names"
grep ">" all_seq.txt | cut -f 1,2,3 -d "_" | sort | uniq -c

echo "######################## the concatenator has finished ########################"

####################### END OF SCRIPT ###########################
