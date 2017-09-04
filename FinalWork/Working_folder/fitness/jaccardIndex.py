import sys

if len(sys.argv) != 4:
    print("Usage: python3 jaccardIndex.py file1 file2 indexFile")
else:
    file1 = sys.argv[1]
    file2 = sys.argv[2]
    indexFile = sys.argv[3]

    with open(indexFile, "r") as f:
        oldFitness = f.readline().strip()
        if oldFitness == "0 0 0":
            exit()

    set1 = set(open(file1, "r").read().split('\n'))
    set2 = set(open(file2, "r").read().split('\n'))

    intersection = set1.intersection(set2)
    union = set1.union(set2)

	# print(len(intersection))
	# print(len(union))
	# print("Jaccard Index: " + str(float(len(intersection))/float(len(union)))

    with open(indexFile, "w") as f:
        f.write(str(1-float(len(intersection))/float(len(union))) + " " + oldFitness + '\n')
