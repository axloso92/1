#!/bin/bash
read -n 5 -p "Introduce tu codigo postal : " cp
echo
case $cp in
	110*)
		echo "Gomez Farias" ;;
	120*)
		echo "En tu cora <3 " ;;
	130*)
		echo "Leyes de Reforma" ;;
	140*)   
		echo "iztapalapa" ;;
	150*)
		echo "polanquito" ;;
	 *)
		echo "No contemplado" ;;
esac
