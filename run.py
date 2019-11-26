import os
from assembler import set_ir
from mapper import *

dataSegment = 0
codeSegment = 500
dataStart = 0
variablesValues = {}
variablesAddresses = {}
inputList = []
currentAddress = 0

def read():
	global inputList
	global variablesAddresses
	global variablesValues
	global dataStart
	path = os.listdir('./inputs')	
	path = os.path.join('inputs','sample.txt')
	with open(path,"r") as f:
		inputList = f.read().splitlines()
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
	incrementor = 0
	for inputNumber,input in enumerate(inputList[:dataStart]):
		nFound = rnumberFind(input,3)
		nIndex = nFound[0]
		#print(nFound)
		vIndex = -1
		for key in variablesValues.keys():
			vIndex = input.rfind(key,3)
			if(vIndex != -1):
				pass
		if(vIndex == nIndex == -1):
			continue
		index = vIndex if vIndex > nIndex else nIndex
		if(nIndex>vIndex):
			inputList[inputNumber+incrementor]=inputList[inputNumber+incrementor][0:nFound[0]]+inputList[inputNumber+incrementor][nFound[0]:].replace(("#"+str(nFound[1])),"(R7)+")
			inputList.insert(inputNumber+incrementor+1,str(nFound[1]))
			incrementor+=1
		else:
			pass
		
		
	
		#look for 2nd
		#nFound = rnumberFind(input,3,index)
		#nIndex = nFound[0]
		#for key in variablesValues.keys():
		#	vIndex = input.rfind(key,3,index)
		#	if(vIndex != -1):
		#		pass
		#		index = vIndex if vIndex > nIndex else nIndex
		#if(vIndex == nIndex == -1):
		#	continue
		#if(nIndex>vIndex):
		#	inputList[inputNumber+incrementor]=inputList[inputNumber+incrementor][0:nFound[0]]+inputList[inputNumber+incrementor][nFound[0]:].replace(("#"+str(nFound[1])),"(R7)+")
		#	inputList.insert(inputNumber+incrementor+1,str(nFound[1]))
		#	incrementor+=1
		#else:
		#	pass
	

def write():
	global inputList
	global dataStart
	global currentAddress
	path = os.listdir('./outputs')
	path = os.path.join('outputs','output.txt')
	file = open(path,'w')
	
	for input in inputList[:dataStart]:
		if(input.isnumeric()):
			file.write(input+"\n")
		else:
			file.write(str(set_ir(input,currentAddress))+"\n")
		currentAddress+=1
	file.close()

if __name__ == "__main__":
	read()
	print(inputList)
	write()