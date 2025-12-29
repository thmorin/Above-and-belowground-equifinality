for i in opt*s; 
    do sed -i '3s/01011900/01011990/' $i; 
done

rm *.bak
