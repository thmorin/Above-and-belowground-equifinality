for f in opt*s
do
  echo "Processing $f"
  sed -i '11s/5,5,1,3/5,5,1,10/' $f
done
