import sys
from random import randint

def substitute(line):
    result = []
    label = line.split("\t")[0]
    if ":" in label:
        instr = "".join(line.split(":")[1:]).strip()
    else:
        label = None
        instr = line.strip()

    if ";" in instr:
        comment = "".join(instr.split(";")[1:]).strip()
        instr = instr.split(";")[0].strip()
    else:
        comment = None

    # print(label)
    # print(instr)
    # print(comment)

    operation = instr.split(" ")[0].strip()
    # print(operation)

    operands = "".join(instr.split(" ")[1:]).split(",")
    # print(operands)

    if operation.lower() == "add":
        result.append((label or "") + "\t" + "ADDU" + " " + ", ".join(operands) + "\t; " + (comment or ""))
    elif operation.lower() == "addi":
        result.append((label or "") + "\t" + "ADDIU" + " " + ", ".join(operands) + "\t; " + (comment or ""))
    elif operation.lower() == "addiu":
        result.append((label or "") + "\t" + "ADDI" + " " + ", ".join(operands) + "\t; " + (comment or ""))
    elif operation.lower() == "addu":
        result.append((label or "") + "\t" + "ADD" + " " + ", ".join(operands) + "\t; " + (comment or ""))
    elif operation.lower() == "and":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "ANDI" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "ANDI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
            result.append("\t" + "AND" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
        else:
            result.append((label or "") + "\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "XORI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; ")
            result.append("\t" + "OR" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
            result.append("\t" + "XORI" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; ")
            result.append("\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
            result.append("\t" + "XORI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; ")
    elif operation.lower() == "andi":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "ADD" + " " + operands[0] + ", " + "$0" + ", " + operands[1] + "\t; ")
            result.append("\t" + "ADDI" + " " + operands[1] + ", " + "$0" + ", " + operands[2] + "\t; ")
            result.append("\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
            result.append("\t" + "NOR" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "ADD" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; " + (comment or ""))
            result.append("\t" + "XORI" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; ")
            result.append("\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
            result.append("\t" + "NOR" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; ")
            result.append("\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
    elif operation.lower() == "beq":
        r = randint(0,2)
        if r == 0:
            result.append((label or "") + "\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; " + (comment or ""))
            result.append("\t" + "BEQ" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; ")
        elif r == 1:
            result.append((label or "") + "\t" + "ADDI" + " " + operands[0] + ", " + operands[0] + ", " + "1" + "\t; " + (comment or ""))
            result.append("\t" + "ADDI" + " " + operands[1] + ", " + operands[1] + ", " + "1" + "\t; ")
            result.append("\t" + "BEQ" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
        else:
            result.append((label or "") + "\t" + "ANDI" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "BEQ" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
    elif operation.lower() == "bgez":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "BEQ" + " " + operands[0] + ", " + "$0" + ", " + operands[1] + "\t; " + (comment or ""))
            result.append("\t" + "BGTZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "BEQ" + " " + operands[0] + ", " + "$0" + ", " + operands[1] + "\t; " + (comment or ""))
            result.append("\t" + "BGEZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "bgezal":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "BGEZAL" + " " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "OR" + " " + operands[0] + ", " + operands[0] + ", " + "0" + "\t; " + (comment or ""))
            result.append("\t" + "BGEZAL" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "bgtz":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "BGTZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "OR" + " " + operands[0] + ", " + operands[0] + ", " + "0" + "\t; " + (comment or ""))
            result.append("\t" + "BGTZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "blez":
        r = randint(0,2)
        if r == 0:
            result.append((label or "") + "\t" + "BEQ" + " " + operands[0] + ", " + "$0" + ", " + operands[1] + "\t; " + (comment or ""))
            result.append("\t" + "BLTZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
        elif r == 1:
            result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "BLEZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "OR" + " " + operands[0] + ", " + operands[0] + ", " + "0" + "\t; " + (comment or ""))
            result.append("\t" + "BLEZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "bltz":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "BLTZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "OR" + " " + operands[0] + ", " + operands[0] + ", " + "0" + "\t; " + (comment or ""))
            result.append("\t" + "BLTZ" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "bltzal":
        r = randint(0,1)
        if r == 0:
            result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; " + (comment or ""))
            result.append("\t" + "BLTZAL" + " " + operands[0] + ", " + operands[1] + "\t; ")
        else:
            result.append((label or "") + "\t" + "OR" + " " + operands[0] + ", " + operands[0] + ", " + "0" + "\t; " + (comment or ""))
            result.append("\t" + "BLTZAL" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "bne":
        result.append((label or "") + "\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; " + (comment or ""))
        result.append("\t" + "BNE" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; ")
    elif operation.lower() == "jr":
        result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + operands[0] + "\t; " + (comment or ""))
        result.append("\t" + "JR" + " " + operands[0] + ", " + "$0" + "\t; ")
    elif operation.lower() == "lui":
        result.append((label or "") + "\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + operands[0] + "\t; " + (comment or ""))
        result.append("\t" + "ADDI" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; ")
        result.append("\t" + "SLL" + " " + operands[0] + ", " + operands[0] + ", " + "16" + "\t; ")
    elif operation.lower() == "lw":
        result.append((label or "") + "\t" + "AND" + " " + operands[0] + ", " + operands[0] + ", " + operands[0] + "\t; " + (comment or ""))
        result.append("\t" + "LW" + " " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "mfhi":
        result.append((label or "") + "\t" + "XOR" + " " + operands[0] + ", " + operands[0] + "\t; " + (comment or ""))
        result.append("\t" + "MFHI" + " " + operands[0] + "\t; ")
    elif operation.lower() == "mflo":
        result.append((label or "") + "\t" + "XOR" + " " + operands[0] + ", " + operands[0] + "\t; " + (comment or ""))
        result.append("\t" + "MFLO" + " " + operands[0] + "\t; ")
    elif operation.lower() == "mult":
        result.append((label or "") + "\t" + "MULTU" + " " + ", ".join(operands) + "\t; " + (comment or ""))
    elif operation.lower() == "multu":
        result.append((label or "") + "\t" + "MULT" + " " + ", ".join(operands) + "\t; " + (comment or ""))
    elif operation.lower() == "nor":
        result.append((label or "") + "\t" + "OR" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "XORI" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; ")
    elif operation.lower() == "or":
        result.append((label or "") + "\t" + "NOR" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "XORI" + " " + operands[0] + ", " + operands[0] + ", " + "-1" + "\t; ")
    elif operation.lower() == "ori":
        result.append((label or "") + "\t" + "ADD" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "NOR" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; ")
    elif operation.lower() == "sll":
        result.append((label or "") + "\t" + "ADDI" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "SLLV" + " " + operands[0] + ", " + operands[1] + ", " + operands[0] + "\t; ")
    elif operation.lower() == "sllv":
        result.append((label or "") + "\t" + "ADDI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; " + (comment or ""))
        result.append("\t" + "SLL" + " " + operands[1] + ", " + operands[1] + ", " + "1" + "\t; ")
        result.append("\t" + "SLLV" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
    elif operation.lower() == "slt":
        result.append((label or "") + "\t" + "SUB" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "SRL" + " " + operands[0] + ", " + operands[0] + ", " + "31" + "\t; ")
    elif operation.lower() == "slti":
        result.append((label or "") + "\t" + "ADDI" + " " + operands[0] + ", " + operands[1] + ", " + str(int(operands[2])*(-1)) + "\t; " + (comment or ""))
        result.append("\t" + "SRL" + " " + operands[0] + ", " + operands[0] + ", " + "31" + "\t; ")
    elif operation.lower() == "sltiu":
        result.append((label or "") + "\t" + "ADDIU" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "SLTU" + " " + operands[0] + ", " + operands[1] + ", " + operands[0] + "\t; ")
    elif operation.lower() == "sra":
        result.append((label or "") + "\t" + "ADDI" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "SRAV" + " " + operands[0] + ", " + operands[1] + ", " + operands[0] + "\t; ")
    elif operation.lower() == "srav":
        result.append((label or "") + "\t" + "SRA" + " " + operands[1] + ", " + operands[1] + ", " + "1" + "\t; " + (comment or ""))
        result.append("\t" + "ADDI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; ")
        result.append("\t" + "SRAV" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
    elif operation.lower() == "srl":
        result.append((label or "") + "\t" + "ADDI" + " " + operands[0] + ", " + "$0" + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "SRLV" + " " + operands[0] + ", " + operands[1] + ", " + operands[0] + "\t; ")
    elif operation.lower() == "sub":
        result.append((label or "") + "\t" + "XORI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; " + (comment or ""))
        result.append("\t" + "ADD" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
        result.append("\t" + "ADDI" + " " + operands[0] + ", " + operands[0] + ", " + "1" + "\t; ")
        result.append("\t" + "XORI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; ")
    elif operation.lower() == "subu":
        result.append((label or "") + "\t" + "SUB" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; " + (comment or ""))
    elif operation.lower() == "sw":
        result.append((label or "") + "\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + "$6" + "\t; " + (comment or ""))
        result.append("\t" + "XOR" + " " + "$6" + ", " + "$6" + ", " + operands[0] + "\t; ")
        result.append("\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + "$6" + "\t; ")
        result.append("\t" + "SW" + " " + "$6" + ", " + operands[1] + "\t; ")
        result.append("\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + "$6" + "\t; ")
        result.append("\t" + "XOR" + " " + "$6" + ", " + "$6" + ", " + operands[0] + "\t; ")
        result.append("\t" + "XOR" + " " + operands[0] + ", " + operands[0] + ", " + "$6" + "\t; ")
    elif operation.lower() == "xor":
        result.append((label or "") + "\t" + "XORI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; " + (comment or ""))
        result.append("\t" + "AND" + " " + operands[0] + ", " + operands[1] + ", " + operands[2] + "\t; ")
        result.append("\t" + "XORI" + " " + operands[2] + ", " + operands[2] + ", " + "-1" + "\t; ")
        result.append("\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
        result.append("\t" + "AND" + " " + operands[1] + ", " + operands[1] + ", " + operands[2] + "\t; ")
        result.append("\t" + "OR" + " " + operands[0] + ", " + operands[0] + ", " + operands[1] + "\t; ")
        result.append("\t" + "XORI" + " " + operands[1] + ", " + operands[1] + ", " + "-1" + "\t; ")
    elif operation.lower() == "xori":
        result.append((label or "") + "\t" + "ADDI" + " " + operands[0] + ", " + "R0" + ", " + operands[2] + "\t; " + (comment or ""))
        result.append("\t" + "XOR" + " " + operands[0] + ", " + operands[1] + "," + operands[0] + "\t; ")
    else:
        result.append(line)

    #for l in result:
    #    print(l)
    return result

NOTHING_PROB = 75
NOP_PROB     = 10
SWAP_PROB    = 5
SUB_PROB     = 10

nothing = NOTHING_PROB
nop_before = nothing + NOP_PROB/2
nop_after = nothing + NOP_PROB
swap_before = nop_after + SWAP_PROB/2
swap_after = nop_after + SWAP_PROB
sub = swap_after + SUB_PROB

if not(len(sys.argv) == 3 or len(sys.argv) == 4 or len(sys.argv) == 5):
    print("Usage: python3 codeShuffler.py inputCode instructionsFile outputCode [-v]")
else:
    if (len(sys.argv) > 1):
        inputCode = sys.argv[1]
        inputTxt = sys.argv[2]
        outputCode = sys.argv[3]
        verbose = (sys.argv[-1] == "-v")
    else:
        inputCode = "codeSample.src"
        inputTxt = "shuffleInstructions.txt"
        outputCode = inputCode.split('.')[0] + "Out.src"
        verbose = False

    code = open(inputCode, "r").read().split('\n')
    inputLines = len(code)

    candidate = open(inputTxt, "r").read().split('\n')

    i = 0
    for j in range(len(candidate)):
        if j >= inputLines:
            break
        op = candidate[j]
        if (op != ''):
            op = int(op)
        else:
            break

        if op < nothing:
            if verbose:
                print("Line " + str(j+1) + ": did nothing.")
            pass
        elif op < nop_before:
            if verbose:
                print("Line " + str(j+1) + ": added a NOP before.")
            code.insert(i+1, "\tSLL $0, $0, 0")
            i += 1
        elif op < nop_after:
            if verbose:
                print("Line " + str(j+1) + ": added a NOP after.")
            code.insert(i, "\tSLL $0, $0, 0 ;")
            i += 1
        elif op < swap_before:
            if verbose:
                print("Line " + str(j+1) + ": swapped with previous instruction.")
            code[i], code[i-1] = code[i-1], code[i]
        elif op < swap_after:
            if verbose:
                print("Line " + str(j+1) + ": swapped with next instruction.")
            if i < len(code)-1:
                code[i], code[i+1] = code[i+1], code[i]
        elif op < sub:
            newCode = substitute(code[i])
            if verbose:
                print("Line " + str(j+1) + ": substituted " + code[i] + " with \n" + '\n'.join(newCode))
            code.remove(code[i])
            for newInstruction in newCode:
                code.insert(i, newInstruction)
                i += 1
            i -= 1
        else:
            pass
        j += 1
        i += 1


    with open(outputCode, "w") as out:
        for c in code:
            if c.strip() != "":
                out.write(c + '\n')
