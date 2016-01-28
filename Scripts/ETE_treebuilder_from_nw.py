#! /usr/bin/env python 

from ete3 import Tree, TreeStyle
import os 

# This opens a shell command in Python, greps all *tree.txt files and puts the file names in a list
FileList = os.popen("ls /home/manager/Project/Data_project | grep tree.txt").read().split()
# String used to add '.svg' to the output file names 
Ext_svg = '.svg'

# Loop that loads a newick formatted tree file and makes a .svg tree picture
for file in FileList:
	t = Tree(file)
	ts = TreeStyle()
	ts.show_branch_support = True
	ts.show_leaf_name = True
	OutFile = file + Ext_svg
	t.render(OutFile,tree_style=ts)
