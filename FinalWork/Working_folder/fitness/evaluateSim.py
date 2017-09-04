import sys

if len(sys.argv) != 6:
    print("Usage: python3 evaluateSim.py goldenData ramData timingData memData fitnessFile")
else:
    goldenData = sys.argv[1]
    ramData = sys.argv[2]
    timingData = sys.argv[3]
    memData = sys.argv[4]
    fitnessFile = sys.argv[5]

    gd = open(goldenData, "r").read().split('\n')
    rd = open(ramData, "r").read().split('\n')

    flag = False
    for g,r in zip(gd,rd):
        if g != r:
            flag = True

    with open(fitnessFile, "w") as f:
        if flag:
            f.write("0 0 0\n")
        else:
            with open(timingData, "r") as t:
                execTime = int(t.readline().strip().split(' ')[0])
                f.write(str(1.0/execTime) + " ")
            with open(memData, "r") as t:
                accesses = int(t.readline().strip())
                f.write(str(1.0/accesses) + '\n')
            # t = len(open("MIPS/trojanData.txt", "r").read().split('\n'))-1
            # c = int(open("trojanCounter.txt", "r").readline().strip())
            # with open("trojanCounter.txt", "w") as f:
            #    f.write(str(c+t))
