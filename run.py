#!/usr/bin/env python
import os


dataSegment = 0
codeSegment = 500
dataStart = 0
variables = {}
def read():
	path = os.listdir('./inputs')
	path = os.path.join('inputs','sample.txt')
	with open(path,"r") as f:
		inputList = f.read().splitlines()
	for i in inputList:
		i = i.upper()
	inputList = [x.upper() for x in inputList]; inputList
	dataStart = inputList.index("HLT")+1
	print(dataStart)
	print(inputList[:])
	for i in inputList[dataStart:]:
		dataString = i[7:].split()
		varName = dataString[0]
		varValue = int(dataString[1])
		variables[varName] = varValue
		print(variables)
	
	




#to test function
read()

