#!/usr/bin/env python
import os


dataSegment = 0
codeSegment = 500
dataStart = 0
variablesValues = {}
variablesAddresses = {}
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
	counter = dataStart
	for i in inputList[dataStart:]:
		dataString = i[7:].split()
		varName = dataString[0]
		varValue = int(dataString[1])
		variablesValues[varName] = varValue
		variablesAddresses[varName] = counter
		counter+=1

#to test function
read()
	
print(variablesAddresses)
print(variablesValues)
