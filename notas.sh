#!/bin/bash
read -p 'Introduce nota ISO : ' NOTAISO
read -p 'Introduce nota PARE : ' NOTAPARE
read -p 'Introduce nota BD : ' NOTABD
suma=$[ $NOTAISO + $NOTAPARE + $NOTABD ]
media=$( echo " scale=2; $suma/3 " | bc -l )
echo " la media es $media "

