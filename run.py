import os
from assembler import set_ir
from mapper import *

dataSegmentStart = 0
codeSegmentStart = 500
dataStart = 0
variablesValues = {}
variablesAddresses = {}
labelAddresses = {}
dataList = []
inputList = []
currentAddress = codeSegmentStart

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
	counter = 0
	for i in inputList[dataStart:]:
		dataString = i[7:].split()
		varName = dataString[0]
		varValue = int(dataString[1])
		variablesValues[varName] = varValue
		variablesAddresses[varName] = counter
		dataList.append(int(dataString[1]))
		counter+=1


	size = len(inputList[:dataStart])
	inputNumber = 0
	while inputNumber < size:
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
		for key in variablesValues.keys():
			startSearch = len(inputList[inputNumber].split(",")[0])
			startSearch = startSearch if startSearch > 0 else 3
			vIndex = rkeyfind(key,inputList[inputNumber],startSearch)
			if(vIndex != -1):
				if vIndex+len(key) < len(inputList[inputNumber]):
					if(inputList[inputNumber][vIndex+len(keyFound)] == "("):
						continue
				keyFound = key
				break
		if(vIndex == nIndex == -1):
			inputNumber+=1
			continue
		index = vIndex if vIndex > nIndex else nIndex
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

		for key in variablesValues.keys():
			vIndex = rkeyfind(key,inputList[inputNumber])
			if(vIndex != -1):
				if vIndex < len(inputList[inputNumber])-1:
					if(inputList[inputNumber][vIndex+1] == "("):
						continue
				keyFound = key
				break
		index = vIndex if vIndex > nIndex else nIndex
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
	codeSeg = os.listdir('./outputs')
	codeSeg = os.path.join('outputs','output.txt')
	dataSeg = os.listdir('./outputs')
	dataSeg = os.path.join('outputs','data.txt')
	file = open(codeSeg,'w')
	for input in inputList[:dataStart]:
		labelAddress = -1
		for label in labelAddresses.keys():
			if (rkeyfind(label,input) != -1):
				labelAddress = labelAddresses[label]
				print(labelAddress)
				break
		if(input.isnumeric() or input.lstrip("-+").isnumeric()):
			#file.write(input+"\n")
			file.write(toBinary(input)+"\n")
		else:
			# file.write(str(set_ir(input,currentAddress))+"\n")
			offset = labelAddress-currentAddress-1
			file.write(toBinary(set_ir(input,offset,labelAddress))+"\n")

		currentAddress+=1
	file.close()
	file = open(dataSeg,'w')
	for data in dataList:
			file.write(str(data)+"\n")
	file.close()


if __name__ == "__main__":
	read()
	print(inputList)
	print(labelAddresses)
	write()