import os
from assembler import *


dataSegment = 0
codeSegment = 500
dataStart = 0
variablesValues = {}
variablesAddresses = {}
inputList = []


def read():
	global inputList
	global variablesAddresses
	global variablesValues
	global dataStart
	path = os.listdir('./inputs')	
	path = os.path.join('inputs','sample.txt')
	with open(path,"r") as f:
		inputList = f.read().splitlines()
	for i in inputList:
		i = i.upper()
	inputList = [x.upper() for x in inputList]; inputList
	dataStart = inputList.index("HLT")+1
	counter = dataStart
	for i in inputList[dataStart:]:
		dataString = i[7:].split()
		varName = dataString[0]
		varValue = int(dataString[1])
		variablesValues[varName] = varValue
		variablesAddresses[varName] = counter
		counter+=1
	return inputList

		
def write():
	global inputList
	global dataStart
	path = os.listdir('./outputs')
	path = os.path.join('outputs','output.txt')
	file = open(path,'w')
	for i in range(len(inputList[:dataStart])):
		if(inputList[i].isnumeric()):
			file.write(inputList[i])
		else:
			#function call here
			#file.write(setIR(inputList[i]))
			pass
	file.close()

if __name__ == "__main__":
	read()
	write()