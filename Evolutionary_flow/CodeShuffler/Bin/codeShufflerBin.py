import sys

NOTHING_PROB = 70
NOP_PROB     = 10
SWAP_PROB    = 10
SUB_PROB     = 10

NOP_CODE = bytes((0, 0, 0, 0))

nothing = NOTHING_PROB
nop_before = nothing + NOP_PROB/2
nop_after = nothing + NOP_PROB
swap_before = nop_after + SWAP_PROB/2
swap_after = nop_after + SWAP_PROB
sub = swap_after + SUB_PROB

inputBin = sys.argv[1]
inputTxt = sys.argv[2]
if len(sys.argv) == 4:
    outputBin = sys.argv[3]
else:
    outputBin = inputBin.split('.')[0] + "Out.bin"

code = open(inputBin, "rb").read()
code = [code[i:i+4] for i in range(0, len(code), 4)]

candidate = open(inputTxt, "r").read().split('\n')

codeOut = code
for i, op in enumerate(candidate):
    if (op != ''):
        op = int(op)
    else:
        break

    if op < nothing:
        pass
    elif op < nop_before:
        codeOut.insert(i+1, NOP_CODE)
    elif op < nop_after:
        codeOut.insert(i, NOP_CODE)
    elif op < swap_before:
        codeOut[i], codeOut[i+1] = codeOut[i+1], codeOut[i]
    elif op < swap_after:
        codeOut[i], codeOut[i-1] = codeOut[i-1], codeOut[i]
    elif op < sub:
        pass
        #codeOut[i] = substitute(codeOut[i])
    else:
        pass


with open(outputBin, "wb") as out:
    for c in codeOut:
        out.write(c)
