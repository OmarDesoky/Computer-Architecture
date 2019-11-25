def setIR(str):
    #str = "MoV r1,R2"
    IR = 0
    str = str.upper()

    temp = ""
    for i in range(len(str)):

        if str[i] == " ":
            if temp == "MOV":
                IR = IR | 0x00000000
            elif temp == "ADD":
                IR = IR | 0x00001000
            elif temp == "ADC":
                IR = IR | 0x00002000
            elif temp == "SUB":
                IR = IR | 0x00003000
            elif temp == "SBC":
                IR = IR | 0x00004000
            elif temp == "AND":
                IR = IR | 0x00005000
            elif temp == "OR":
                IR = IR | 0x00006000
            elif temp == "XNOR":
                IR = IR | 0x00007000
            elif temp == "CMP":
                IR = IR | 0x00008000

            elif temp == "INC":
                IR = IR | 0x0000C000
            elif temp == "DEC":
                IR = IR | 0x0000C040
            elif temp == "CLR":
                IR = IR | 0x0000C080
            elif temp == "INV":
                IR = IR | 0x0000C0C0
            elif temp == "LSR":
                IR = IR | 0x0000C100
            elif temp == "RDR":
                IR = IR | 0x0000C140
            elif temp == "RRC":
                IR = IR | 0x0000C180
            elif temp == "ASR":
                IR = IR | 0x0000C1C0
            elif temp == "LSL":
                IR = IR | 0x0000C200
            elif temp == "ROL":
                IR = IR | 0x0000C240
            elif temp == "RLC":
                IR = IR | 0x0000C280
            temp = ""
        else:
            temp.join(str[i])

    print(str)
    print(IR)