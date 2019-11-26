# creating OP-CODE for the branch instructions
class Branch:
    def __init__(self,off):
        self.offset = off
        self.BR = bin(0b1010000000000000 | off)
        self.BEQ = bin(0b1010000100000000 | off)
        self.BNE = bin(0b1010001000000000 | off)
        self.BLO = bin(0b1010001100000000 | off)
        self.BLS = bin(0b1010010000000000 | off)
        self.BHI = bin(0b1010010100000000 | off)
        self.BHS = bin(0b1010011000000000 | off)


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


def set_ir(string, offset):
    #string = "MoV r1,R2"
    ir = 0
    string = string.upper().split()
    branch = Branch(offset)
    noOperand = NoOperand()
    jsr = Jsr()
    operation = string[0]
    if operation == "MOV":
        ir = ir | 0x00000000
    elif operation == "ADD":
        ir = ir | 0x00001000
    elif operation == "ADC":
        ir = ir | 0x00002000
    elif operation == "SUB":
        ir = ir | 0x00003000
    elif operation == "SBC":
        ir = ir | 0x00004000
    elif operation == "AND":
        ir = ir | 0x00005000
    elif operation == "OR":
        ir = ir | 0x00006000
    elif operation == "XNOR":
        ir = ir | 0x00007000
    elif operation == "CMP":
        ir = ir | 0x00008000
    elif operation == "INC":
        ir = ir | 0x0000C000
    elif operation == "DEC":
        ir = ir | 0x0000C040
    elif operation == "CLR":
        ir = ir | 0x0000C080
    elif operation == "INV":
        ir = ir | 0x0000C0C0
    elif operation == "LSR":
        ir = ir | 0x0000C100
    elif operation == "RDR":
        ir = ir | 0x0000C140
    elif operation == "RRC":
        ir = ir | 0x0000C180
    elif operation == "ASR":
        ir = ir | 0x0000C1C0
    elif operation == "LSL":
        ir = ir | 0x0000C200
    elif operation == "ROL":
        ir = ir | 0x0000C240
    elif operation == "RLC":
        ir = ir | 0x0000C280
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

set_ir("NOP",2)