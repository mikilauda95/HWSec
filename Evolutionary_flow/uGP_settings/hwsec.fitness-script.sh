#!/bin/bash

cd fitness
for arg in "$@"
do
  python3 individualSplitter.py ../$arg instructions.txt
  python3 codeShuffler.py startingCode.src instructions.txt modifiedCode.src
  cd MIPS
  vcom -c -do "macroentity_tb; run -all; exit"
  cd ..
  python3 evaluateSim.py goldenData.txt ramData.txt timingData.txt memAccess.txt ../fitness.out
  python3 jaccardIndex.py startingCode.src modifiedCode.src ../fitness.out
done
cd ..
