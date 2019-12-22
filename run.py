import os
from assembler import *
from mapper import *

dataSegmentStart = 0
codeSegmentStart = 500
dataStart = 0
variablesAddresses = {}
labelAddresses = {}
dataList = []
inputList = []
currentAddress = codeSegmentStart

def read():
	global inputList
	global variablesAddresses
	global dataStart
	path = os.listdir('./inputs')	
	path = os.path.join('inputs','inputTEST.txt')
	with open(path,"r") as f:
		inputList = f.read().splitlines()
	inputList = [x.upper() for x in inputList]; inputList
	dataStart = inputList.index("HLT")+1
	counter = dataSegmentStart
	for input in inputList[dataStart:]:
		if input.find(",") == -1:
			dataString = input[7:].split()
			varName = dataString[0]
			varValue = int(dataString[1])
			variablesAddresses[varName] = counter
			dataList.append(varValue)
			counter+=1
		else:
			dataString = input[7:].split()
			varName = dataString[0]
			varValues = dataString[1].split(',')
			for var in varValues:
				variablesAddresses[varName] = counter
				dataList.append(int(var))
				counter+=1


	size = len(inputList[:dataStart])
	inputNumber = 0
	while inputNumber < size:
		if(inputList[inputNumber].lstrip("-").isnumeric()):
			inputNumber+=1
			continue
		if(inputList[inputNumber].find(":") != -1):
			label = inputList[inputNumber].split(":")
			labelAddresses[label[0]] = inputNumber+codeSegmentStart
			inputList[inputNumber] = "NOP"
			continue
		nFound = rnumberFind(inputList[inputNumber],3)
		nIndex = nFound[0]
		nValue = nFound[1]
		nType = nFound[2]
		rel1 = False
		keyFound = 0
		maxVariable = -1
		for key in variablesAddresses.keys():
			vIndex = rkeyfind(key,inputList[inputNumber])
			if(vIndex != -1):
				if vIndex+len(key) < len(inputList[inputNumber]):
					if(inputList[inputNumber][vIndex+len(key)] == "("):
						continue
				if(vIndex > maxVariable):
					keyFound = key
					maxVariable = vIndex
		vIndex = maxVariable
				
		if(vIndex == nIndex == -1):
			inputNumber+=1
			continue
		if(nIndex>vIndex):
			if(nType == 0):
				inputList[inputNumber]=inputList[inputNumber][0:nIndex]+inputList[inputNumber][nIndex:].replace((str(nValue)+"("),"X(")
				inputList.insert(inputNumber+1,str(nFound[1]))
				size+=1
				dataStart+=1
			elif(nType == 1):
				inputList[inputNumber]=inputList[inputNumber][0:nIndex]+inputList[inputNumber][nIndex:].replace(("#"+str(nValue)),"(R7)+")
				inputList.insert(inputNumber+1,str(nFound[1]))
				size+=1
				dataStart+=1
		else:
			preVariable = inputList[inputNumber][vIndex - 1]
			if preVariable == "#":
				inputList[inputNumber]=inputList[inputNumber][0:vIndex-2]+inputList[inputNumber][vIndex-2:].replace(("@#"+str(keyFound)),"@(R7)+")
				inputList.insert(inputNumber+1,str(variablesAddresses[keyFound]))
				size+=1
				dataStart+=1

			elif preVariable == "@":
				inputList[inputNumber]=inputList[inputNumber][0:vIndex-1]+inputList[inputNumber][vIndex-1:].replace(("@"+str(keyFound)),"@X(R7)")
				inputList.insert(inputNumber+1,str(variablesAddresses[keyFound]-codeSegmentStart-inputNumber-2+dataSegmentStart))
				size+=1
				dataStart+=1
				rel1 = True
			elif preVariable == " " or preVariable == ",":
				inputList[inputNumber]=inputList[inputNumber][0:vIndex]+inputList[inputNumber][vIndex:].replace((str(keyFound)),"X(R7)")
				inputList.insert(inputNumber+1,str(variablesAddresses[keyFound]-codeSegmentStart-inputNumber-2+dataSegmentStart))
				size+=1
				dataStart+=1
				rel1 = True


		nFound = rnumberFind(inputList[inputNumber])
		nIndex = nFound[0]
		nType = nFound[2]

		for key in variablesAddresses.keys():
			vIndex = rkeyfind(key,inputList[inputNumber])
			if(vIndex != -1):
				if vIndex < len(inputList[inputNumber])-1:
					if(inputList[inputNumber][vIndex+1] == "("):
						continue
				keyFound = key
				break
		if(vIndex == nIndex == -1):
			inputNumber+=1
			continue
		if(rel1):
			inputList[inputNumber+1] = str(int(inputList[inputNumber+1])-1)
		if(nIndex>vIndex):
			if(nType == 0):
				inputList[inputNumber]=inputList[inputNumber][0:nFound[0]]+inputList[inputNumber][nFound[0]:].replace((str(nFound[1]))+"(","X(")
				inputList.insert(inputNumber+1,str(nFound[1]))
				size+=1
				dataStart+=1
			elif(nType == 1):
				inputList[inputNumber]=inputList[inputNumber][0:nFound[0]]+inputList[inputNumber][nFound[0]:].replace(("#"+str(nFound[1])),"(R7)+")
				inputList.insert(inputNumber+1,str(nFound[1]))
				size+=1
				dataStart+=1
		else:
			preVariable = inputList[inputNumber][vIndex - 1]
			if preVariable == "#":
				inputList[inputNumber]=inputList[inputNumber][0:vIndex-2]+inputList[inputNumber][vIndex-2:].replace(("@#"+str(keyFound)),"@(R7)+")
				inputList.insert(inputNumber+1,str(variablesAddresses[keyFound]))
				size+=1
				dataStart+=1

			elif preVariable == "@":
				inputList[inputNumber]=inputList[inputNumber][0:vIndex-2]+inputList[inputNumber][vIndex-2:].replace(("@"+str(keyFound)),"@X(R7)")
				inputList.insert(inputNumber+1,str(variablesAddresses[keyFound]-codeSegmentStart-inputNumber-2+dataSegmentStart))
				size+=1
				dataStart+=1
			elif preVariable == " " or preVariable == ",":
				inputList[inputNumber]=inputList[inputNumber][0:vIndex]+inputList[inputNumber][vIndex:].replace((str(keyFound)),"X(R7)")
				inputList.insert(inputNumber+1,str(variablesAddresses[keyFound]-codeSegmentStart-inputNumber-2+dataSegmentStart))
				size+=1
				dataStart+=1
		inputNumber+=1



def write():
	global inputList
	global dataStart
	global codeSegmentStart
	global labelAddresses
	currentAddress = codeSegmentStart
	RAM_DATA = os.listdir('./vhdl-code')
	RAM_DATA = os.path.join('vhdl-code','RAM_DATA.txt')
	file = open(RAM_DATA,'w')
	for data in dataList:
			file.write(toBinary(str(data))+"\n")
	for i in range(len(dataList),codeSegmentStart):
			file.write("".zfill(16)+"\n")
	for input in inputList[:dataStart]:
		labelAddress = -1
		for label in labelAddresses.keys():
			if (rkeyfind(label,input) != -1):
				labelAddress = labelAddresses[label]
				break
		if(input.isnumeric() or input.lstrip("-+").isnumeric()):
			#file.write(input+"\n")
			file.write(toBinary(input)+"\n")
		else:
			# file.write(str(set_ir(input,currentAddress))+"\n")
			offset = labelAddress-currentAddress-1
			file.write(toBinary(set_ir(input,offset,labelAddress))+"\n")
		currentAddress+=1
	for i in range(codeSegmentStart+len(inputList[:dataStart]),4096):
		file.write("".zfill(16)+"\n")
	file.close()



if __name__ == "__main__":
	read()
	print(inputList)
	write()