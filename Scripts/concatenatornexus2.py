#!/usr/bin/env python

Usage = """
Concatenates nexus files
"""


from Bio.Nexus import Nexus
# The combine function takes a list of tuples [(name, nexus instance)...], 
# if we provide the file names in a list we can use a list comprehension to 
# create these tuples (cited from: http://biopython.org/wiki/Concatenate_nexus)
# The file names should not contain dashes ('-'), because this will not work
 
# This opens a shell command in Python, greps all .nex files and puts the file names in a list
import os
filelist = os.popen('ls /home/manager/Project/Data_project | grep .nex').read().split() 

# This is the nexus module that concatenates the sequences in the files in the file list
nexi = [(fname, Nexus.Nexus(fname)) for fname in filelist]

combined = Nexus.combine(nexi)
combined.write_nexus_data(filename=open('combined.nex', 'w')) 

