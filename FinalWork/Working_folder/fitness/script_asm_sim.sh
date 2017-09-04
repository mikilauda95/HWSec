



# compile asm
cd gasm/
./assembler.sh $1
#in the case this scrip generates an error file no other actions are required.
if [ -s errors.txt ]; then
  echo "FILE ERROR EXISTS general script!!"
  exit
fi



