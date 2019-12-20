def rnumberFind(inputString,start = 0,end = -1):
	if(end == -1):
		end = len(inputString)
	for index,char in reversed(list(enumerate(inputString[start:end],start))):
		if(char.isnumeric()):
			iterator = index
			data = 0
			multiplier = 1
			inputSize = len(inputString)
			indexCondition = False
			if index+1 < inputSize:
				if inputString[index+1] =="(":
					indexCondition = True
			

			if indexCondition:
				while(inputString[iterator].isnumeric() or inputString[iterator] == "-"):
					if(inputString[iterator]== "-"):
						data*=-1
						return [iterator,data,0]
					data+=int(inputString[iterator])*multiplier
					multiplier*=10
					iterator-=1
				if(inputString[iterator] == ' ' or inputString[iterator] == ','):
					return [iterator,data,0]
			else:
				while(inputString[iterator].isnumeric() or inputString[iterator] == "-"):
					if(inputString[iterator]== "-"):
						data*=-1
						return [iterator,data,0]
					data+=int(inputString[iterator])*multiplier
					multiplier*=10
					iterator-=1

				if(inputString[iterator] == '#'):
					return [iterator,data,1]

	return [-1,-1,-1]

def rkeyfind(key, inputString , start = 0, end = -1):
	inputString = str(inputString)
	vIndex = inputString.rfind(key,start)
	if(vIndex == -1):
		return -1
	preVariable = inputString[vIndex-1]
	if(preVariable == "@" or preVariable == "#" or preVariable == " " or preVariable == ","):	
		if(len(key)+vIndex == len(inputString)):
			return vIndex
		elif(inputString[len(key)+vIndex] != ","):
			return -1
		else:
			return vIndex
	else:
		return -1

# def toBinary(string):
# 	integer = int(string)
# 	if(integer>=0):
# 		return str(bin(integer)).lstrip("-0b").zfill(16)
# 	else:
# 		return str(bin(~integer)).lstrip("-0b").rjust(16,"1") #faulty!!
