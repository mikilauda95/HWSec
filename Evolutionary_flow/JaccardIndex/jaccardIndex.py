import sys

file1 = sys.argv[1]
file2 = sys.argv[2]

set1 = set(open(file1, "r").read().split('\n'))
set2 = set(open(file2, "r").read().split('\n'))

intersection = set1.intersection(set2)
union = set1.union(set2)

print(len(intersection))
print(len(union))
print("Jaccard Index: " + str(float(len(intersection))/float(len(union))))

with open("index.txt", "w") as f:
    f.write(str(float(len(intersection))/float(len(union))))
