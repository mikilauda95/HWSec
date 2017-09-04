#!/bin/bash
cp BEST_P1.in fitness/
cd fitness
python3 individualSplitter.py BEST_P1.in bestDNA.txt
python3 codeShuffler.py startingCode.src bestDNA.txt bestCode.src
mv bestCode.src ../
rm BEST_P1.in
rm bestDNA.txt
cd ..
