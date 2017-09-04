rm a.bin
rm errors.txt
./asmips $1.src 2>errors.txt
if [ -s ./errors.txt ]; then
   echo "FILE ERROR EXISTS!!"
   rm a.bin
   rm a.lst
else
  cp a.bin ../MIPS/abc.bin
  cp a.lst ../MIPS/abc.lst
fi

