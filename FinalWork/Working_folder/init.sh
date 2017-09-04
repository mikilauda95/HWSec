cd fitness
cp startingCode.src gasm
./script_asm_sim.sh startingCode
cd MIPS
./compileAll  > /dev/null
vsim -c -do "vsim macroentity_tb; run 20 us; exit" > /dev/null
cp ramData.txt ../goldenData.txt
cat ../startingCode.src | wc -l
