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


def set_ir(str, offset):
    #str = "MoV r1,R2"
    ir = 0
    str = str.upper()
    branch = Branch(offset)
    noOperand = NoOperand()
    jsr = Jsr()
    temp = ""
    for i in range(len(str)):

        if str[i] == " ":
            if temp == "MOV":
                ir = ir | 0x00000000
            elif temp == "ADD":
                ir = ir | 0x00001000
            elif temp == "ADC":
                ir = ir | 0x00002000
            elif temp == "SUB":
                ir = ir | 0x00003000
            elif temp == "SBC":
                ir = ir | 0x00004000
            elif temp == "AND":
                ir = ir | 0x00005000
            elif temp == "OR":
                ir = ir | 0x00006000
            elif temp == "XNOR":
                ir = ir | 0x00007000
            elif temp == "CMP":
                ir = ir | 0x00008000

            elif temp == "INC":
                ir = ir | 0x0000C000
            elif temp == "DEC":
                ir = ir | 0x0000C040
            elif temp == "CLR":
                ir = ir | 0x0000C080
            elif temp == "INV":
                ir = ir | 0x0000C0C0
            elif temp == "LSR":
                ir = ir | 0x0000C100
            elif temp == "RDR":
                ir = ir | 0x0000C140
            elif temp == "RRC":
                ir = ir | 0x0000C180
            elif temp == "ASR":
                ir = ir | 0x0000C1C0
            elif temp == "LSL":
                ir = ir | 0x0000C200
            elif temp == "ROL":
                ir = ir | 0x0000C240
            elif temp == "RLC":
                ir = ir | 0x0000C280
            # Branch instructions
            elif temp == "BR":
                ir = ir | branch.BR
            elif temp == "BEQ":
                ir = ir | branch.BEQ
            elif temp == "BNE":
                ir = ir | branch.BNE
            elif temp == "BLO":
                ir = ir | branch.BLO
            elif temp == "BLS":
                ir = ir | branch.BLS
            elif temp == "BHI":
                ir = ir | branch.BHI
            elif temp == "BHS":
                ir = ir | branch.BHS
            # No operand
            elif temp == "NOP":
                ir = ir | noOperand.NOP
            elif temp == "HLT":
                ir = ir | noOperand.HLT
            # JSR instructions
            elif temp == "JSR":
                ir = ir | jsr.JSR
            elif temp == "RTS":
                ir = ir | jsr.RTS
            elif temp == "INTERRUPT":
                ir = ir | jsr.INTERRUPT
            elif temp == "IRET":
                ir = ir | jsr.IRET
            temp = ""
        else:
            temp.join(str[i])
    return ir
