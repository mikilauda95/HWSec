#!/bin/bash

cd fitness
for arg in "$@"
do
  python3 individualSplitter.py ../$arg instructions.txt
  python3 codeShuffler.py startingCode.src instructions.txt modifiedCode.src
  python3 jaccardIndex.py startingCode.src modifiedCode.src ../jacInd.out
  XXcompile
  setmentor
  vsim -c -do "vsim macroentity_tb; run -all; exit"
  XXcheck output
  XXcat fintess
done
cd ..
