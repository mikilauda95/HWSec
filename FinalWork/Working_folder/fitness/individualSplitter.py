import sys

if len(sys.argv) != 3:
    print("Usage: python3 individualSplitter.py DNAfile instructionsFile")
else:
    DNAfile = sys.argv[1]
    instructionsFile = sys.argv[2]

    DNA = open(DNAfile, "r").readline().strip()

    with open(instructionsFile, "w") as f:
        for i,digit in enumerate(DNA):
            f.write(digit)
            if i % 2 == 1:
                f.write('\n')
