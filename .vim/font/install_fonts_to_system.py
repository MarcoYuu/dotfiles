#!/usr/bin/python

import os
import sys
import glob

font_list = glob.glob('./*.otf')
font_list += glob.glob('./*.ttf')
font_list += glob.glob('./powerline/*/*.otf')
font_list += glob.glob('./powerline/*/*.ttf')

for font in font_list:
	command = 'sudo cp "'+font+'" /usr/local/share/fonts'
	print command
	os.system(command)

os.system('sudo fc-cache -fv')
