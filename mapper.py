def rnumberFind(inputString,start = 0,end = -1):
	if(end == -1):
		end = len(inputString)
	for index,char in reversed(list(enumerate(inputString[start:end],start))):
		if(char.isnumeric()):
			iterator = index
			data = 0
			multiplier = 1
			while(inputString[iterator].isnumeric()):
				data+=int(inputString[iterator])*multiplier
				multiplier*=10
				iterator-=1

			if(inputString[iterator] == '#'):
				return [iterator,data]
	return [-1,-1]


