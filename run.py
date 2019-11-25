#!/usr/bin/env python
import os

def read():
	path = os.listdir('./inputs')
	path = os.path.join('inputs','sample.txt')
	with open(path,"r") as f:
		inputList = f.read().splitlines()
	print(inputList)

#to test function
read()

