#! /bin/bash

# this script prints a description of the original sequences, does a multiple alignment, estimates the best phylogenetic tree and displays this tree

# requires newick utils to be installed: http://cegg.unige.ch/newick_utils

# $1 is the fasta file input $2 is the bootstrapvalue
# input in terminal: Treemaker filename bootstrapvalue
# default bootstrap value = 20
# the name of the output value can be changed in outfile= (line 19)

Treemaker2(){
	#estimates the best tree 
	BOOTS=20 #default value for booting is 20
	if [ $2 ]
	then
		BOOTS=$2
	fi
	phyml -i $1 -d nt -n 1 -b $BOOTS -m HKY85
}

