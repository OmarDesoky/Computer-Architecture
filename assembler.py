def twosComplement(string):
    integer = int(string)
    return bin(integer+(1<<16))
def toBinary(string):
	integer = int(string)
	if(integer>=0):
		return str(bin(integer)).lstrip("-0b").zfill(16)
	else:
		return str(twosComplement(string)).lstrip("-0b").rjust(16,"1") 
def intToBinary(integer):
    if(integer>=0):
        return integer
    else:
        return integer+(1<<16)


# creating OP-CODE for the branch instructions


class Branch:
    def __init__(self,off):
        self.offset = off
        self.BR = intToBinary(0b1010000000000000 | off)
        self.BEQ = intToBinary(0b1010000100000000 | off)
        self.BNE = intToBinary(0b1010001000000000 | off)
        self.BLO = intToBinary(0b1010001100000000 | off)
        self.BLS = intToBinary(0b1010010000000000 | off)
        self.BHI = intToBinary(0b1010010100000000 | off)
        self.BHS = intToBinary(0b1010011000000000 | off)



class NoOperand:
    def __init__(self):
        self.NOP = 0b1110100000000000
        self.HLT = 0b1110000000000000


class Jsr:
    def __init__(self):
        self.JSR = 0b1111000000000000
        self.RTS = 0b1111010000000000
        self.INTERRUPT = 0b1111100000000000
        self.IRET = 0b1111110000000000


def set_2operands(operand):
    if len(operand) != 2:
        raise Exception('Syntax Error, Invalid arguments to 2 operand instruction')
    else:
        new_ir = 0

        # source and destination addressing modes
        if operand[0].find('@') != -1:
            new_ir = new_ir | 0b100000000000
        if operand[1].find('@') != -1:
            new_ir = new_ir | 0b000000100000
        if operand[0].find('X') != -1:
            new_ir = new_ir | 0b011000000000
        if operand[1].find('X') != -1:
            new_ir = new_ir | 0b000000011000
        if operand[0].find('+') != -1:
            new_ir = new_ir | 0b001000000000
        if operand[0].find('-') != -1:
            new_ir = new_ir | 0b010000000000
        if operand[1].find('+') != -1:
            new_ir = new_ir | 0b000000001000
        if operand[1].find('-') != -1:
            new_ir = new_ir | 0b000000010000

        # source registers
        if operand[0].find("R0") != -1:
            new_ir = new_ir | 0b000000000000
        elif operand[0].find("R1") != -1:
            new_ir = new_ir | 0b000001000000
        elif operand[0].find("R2") != -1:
            new_ir = new_ir | 0b000010000000
        elif operand[0].find("R3") != -1:
            new_ir = new_ir | 0b000011000000
        elif operand[0].find("R4") != -1:
            new_ir = new_ir | 0b000100000000
        elif operand[0].find("R5") != -1:
            new_ir = new_ir | 0b000101000000
        elif operand[0].find("R6") != -1:
            new_ir = new_ir | 0b000110000000
        elif operand[0].find("R7") != -1:
            new_ir = new_ir | 0b000111000000

        # destination registers
        if operand[1].find("R0") != -1:
            new_ir = new_ir | 0b000000000000
        elif operand[1].find("R1") != -1:
            new_ir = new_ir | 0b000000000001
        elif operand[1].find("R2") != -1:
            new_ir = new_ir | 0b000000000010
        elif operand[1].find("R3") != -1:
            new_ir = new_ir | 0b000000000011
        elif operand[1].find("R4") != -1:
            new_ir = new_ir | 0b000000000100
        elif operand[1].find("R5") != -1:
            new_ir = new_ir | 0b000000000101
        elif operand[1].find("R6") != -1:
            new_ir = new_ir | 0b000000000110
        elif operand[1].find("R7") != -1:
            new_ir = new_ir | 0b000000000111
    return new_ir


def set_1operand(operand):
    if len(operand) != 1:
        raise Exception('Syntax Error, Invalid arguments to 1 operand instruction')
    else:
        new_ir = 0

        if operand[0].find('@') != -1:
            new_ir = new_ir | 0b000000100000
        if operand[0].find('+') != -1:
            new_ir = new_ir | 0b000000001000
        if operand[0].find('-') != -1:
            new_ir = new_ir | 0b000000010000
        if operand[0].find('X') != -1:
            new_ir = new_ir | 0b000000011000

        if operand[0].find("R0") != -1:
            new_ir = new_ir | 0b000000000000
        elif operand[0].find("R1") != -1:
            new_ir = new_ir | 0b000000000001
        elif operand[0].find("R2") != -1:
            new_ir = new_ir | 0b000000000010
        elif operand[0].find("R3") != -1:
            new_ir = new_ir | 0b000000000011
        elif operand[0].find("R4") != -1:
            new_ir = new_ir | 0b000000000100
        elif operand[0].find("R5") != -1:
            new_ir = new_ir | 0b000000000101
        elif operand[0].find("R6") != -1:
            new_ir = new_ir | 0b000000000110
        elif operand[0].find("R7") != -1:
            new_ir = new_ir | 0b000000000111
    return new_ir


def set_ir(string, offset, labelAddress):
    ir = 0
    string = string.upper().split()
    operands = []
    if len(string) > 1:                          # if instruction has operands
        string[1] = string[1].replace(" ", "")    # remove spaces
        operands = string[1].split(",")          # split operands
    branch = Branch((0b0000000011111111 & intToBinary(offset)))
    noOperand = NoOperand()
    jsr = Jsr()
    operation = string[0]
    if operation == "SUB":
        ir = ir | 0x00000000
        ir = ir | set_2operands(operands)
    elif operation == "ADD":
        ir = ir | 0x00001000
        ir = ir | set_2operands(operands)
    elif operation == "ADC":
        ir = ir | 0x00002000
        ir = ir | set_2operands(operands)
    elif operation == "MOV":
        ir = ir | 0x00003000
        ir = ir | set_2operands(operands)
    elif operation == "SBC":
        ir = ir | 0x00004000
        ir = ir | set_2operands(operands)
    elif operation == "AND":
        ir = ir | 0x00005000
        ir = ir | set_2operands(operands)
    elif operation == "OR":
        ir = ir | 0x00006000
        ir = ir | set_2operands(operands)
    elif operation == "XNOR":
        ir = ir | 0x00007000
        ir = ir | set_2operands(operands)
    elif operation == "CMP":
        ir = ir | 0x00008000
        ir = ir | set_2operands(operands)
    # one operand instructions
    elif operation == "INC":
        ir = ir | 0x0000C000
        ir = ir | set_1operand(operands)
    elif operation == "DEC":
        ir = ir | 0x0000C040
        ir = ir | set_1operand(operands)
    elif operation == "CLR":
        ir = ir | 0x0000C080
        ir = ir | set_1operand(operands)
    elif operation == "INV":
        ir = ir | 0x0000C0C0
        ir = ir | set_1operand(operands)
    elif operation == "LSR":
        ir = ir | 0x0000C100
        ir = ir | set_1operand(operands)
    elif operation == "ROR":
        ir = ir | 0x0000C140
        ir = ir | set_1operand(operands)
    elif operation == "RRC":
        ir = ir | 0x0000C180
        ir = ir | set_1operand(operands)
    elif operation == "ASR":
        ir = ir | 0x0000C1C0
        ir = ir | set_1operand(operands)
    elif operation == "LSL":
        ir = ir | 0x0000C200
        ir = ir | set_1operand(operands)
    elif operation == "ROL":
        ir = ir | 0x0000C240
        ir = ir | set_1operand(operands)
    elif operation == "RLC":
        ir = ir | 0x0000C280
        ir = ir | set_1operand(operands)
    # Branch instructions
    elif operation == "BR":
        ir = ir | branch.BR
    elif operation == "BEQ":
        ir = ir | branch.BEQ
    elif operation == "BNE":
        ir = ir | branch.BNE
    elif operation == "BLO":
        ir = ir | branch.BLO
    elif operation == "BLS":
        ir = ir | branch.BLS
    elif operation == "BHI":
        ir = ir | branch.BHI
    elif operation == "BHS":
        ir = ir | branch.BHS
    # No operand
    elif operation == "NOP":
        ir = ir | noOperand.NOP
    elif operation == "HLT":
        ir = ir | noOperand.HLT
    # JSR instructions
    elif operation == "JSR":
        ir = ir | jsr.JSR
    elif operation == "RTS":
        ir = ir | jsr.RTS
    elif operation == "INTERRUPT":
        ir = ir | jsr.INTERRUPT
    elif operation == "IRET":
        ir = ir | jsr.IRET
    return ir
