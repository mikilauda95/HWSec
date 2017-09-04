import sys

start = sys.argv[1]
best = sys.argv[2]
N = int(sys.argv[3])

with open(start, "r") as f1:
    r = []
    for line in f1:
        if line != "\r\n" and line != "\n":
            label = line.split("\t")[0]
            if ":" in label:
                instr = "".join(line.split(":")[1:]).strip()
            else:
                instr = line.strip()

            if ";" in instr:
                instr = instr.split(";")[0].strip()

            operation = instr.split(" ")[0].strip()
            r.append(operation.lower())
    startingGroups = []
    for i in range(len(r)-N+1):
        startingGroups.append((r[i], r[i+1], r[i+2]))

with open(best, "r") as f2:
    r = []
    for line in f2:
        if line != "\r\n" and line != "\n":
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

            operation = instr.split(" ")[0].strip()
            r.append(operation.lower())
    bestGroups = []
    for i in range(len(r)-N+1):
        bestGroups.append((r[i], r[i+1], r[i+2]))

d = {}

for tup in startingGroups:
    d[tup] = (startingGroups.count(tup), bestGroups.count(tup))

X,Y = reduce(lambda x,y : (x[0]+y[0],x[1]+y[1]) , d.values())
Z = (1 - float(Y)/float(X)) * 100

print("In the initial code, there were " + str(X) + " tuples.")
print("In the final code, only " + str(Y) + " of those tuples are left.")
print("{:.5f}% of possible trojans have been mitigated.".format(Z))
