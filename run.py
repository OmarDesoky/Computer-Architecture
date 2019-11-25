import os
inputList = []
from assembler import *
def read():
	path = os.listdir('./inputs')	
	path = os.path.join('inputs','sample.txt')
	with open(path,"r") as f:
		inputList = f.read().splitlines()	
	return inputList

		
def write(inputList):
	path = os.listdir('./outputs')
	path = os.path.join('outputs','output.txt')
	file = open(path,'w')
	for i in range(len(inputList)):
		if(inputList[i].isnumeric()):
			file.write(inputList[i])
		else:
			#function call here
			#file.write(setIR(inputList[i]))
			pass
	file.close()

if __name__ == "__main__":
	inputlist = read()
	write(inputlist)