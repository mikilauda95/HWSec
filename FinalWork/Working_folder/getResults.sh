#!/bin/bash
cp BEST_P1.in results
./generateBestCode.sh
python trojan.py fitness/startingCode.src bestCode.src 3 > results/mitigation.txt
cp bestCode.src results
cp fitness/startingCode.src results
cp statistics.csv results
cat statistics.csv | tr "," "\t" | tr "." "," > results/stats.tsv
cp status.xml results
