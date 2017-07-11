!#/bin/bash
#Edad para votar
read -p "introduce tu edad : " edad

if [ $edad -lt 18 ]; then
	echo "No puedes votar"
else
	echo "Puedes votar"
fi
