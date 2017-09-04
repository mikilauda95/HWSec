#!/bin/bash

cd fitness
for arg in "$@"
do
  python3 individualSplitter.py ../$arg instructions.txt
  python3 codeShuffler.py startingCode.src instructions.txt modifiedCode.src
  cp modifiedCode.src gasm/
  sh ./script_asm_sim.sh modifiedCode
  cd MIPS
  vsim -c -do "vsim macroentity_tb; run 20000 ns; exit" > /dev/null
  cd ..
  python3 evaluateSim.py goldenData.txt MIPS/ramData.txt MIPS/timingData.txt MIPS/memAccess.txt ../fitness.out
  python3 jaccardIndex.py startingCode.src modifiedCode.src ../fitness.out
done
cd ..

