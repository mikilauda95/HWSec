for d in $(ls);
do
  for t in $(ls /$d);
  do
    python trojan.py $d/$t/startingCode.src $d/$t/bestCode.src 3 > $d/$t/mitigation.txt
  done
done
