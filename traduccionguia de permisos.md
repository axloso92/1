# Guía de permisos de archivos de Linux y UNIX

Esta guía asume que el lector tiene una familiaridad básica con un shell de UNIX.
Cuando empiece a ver términos como octal, binario, bits pegajosos, establecer UID, configurar GID y ACL, aprender cómo funcionan los permisos de archivo UNIX puede sonar confuso. No es tan mal después de un poco de práctica. En mi opinión, es más fácil que los permisos de Windows. No es necesario entender octal y binario. Podría hacer las cosas un poco más intuitivas, pero no es necesario entender los conceptos.
Antes de comenzar, a veces verá permisos de archivos denominados modo de archivo. Cuando se trata de Linux y UNIX, los términos modo de archivo y permisos son sinónimos.

#Propiedad
Cada archivo en un sistema similar a UNIX es propiedad de un usuario y tiene un grupo. El usuario propietario y el grupo junto con los permisos se utilizan para determinar quién puede hacer qué con un archivo.
Cada usuario en un sistema similar a UNIX tiene al menos un grupo al que pertenece, denominado grupo principal. Un usuario puede ser un miembro de grupos adicionales, llamados grupos suplementarios. Estos grupos se utilizan para determinar el acceso a archivos y carpetas.
Abra un terminal y ejecute el comando ls -l. Aquí está la salida de ls -l en una de mis máquinas:


| total | 4 |
|---------|----|-----|----|----|-----|------|
drwxr-xr-x | 2 | nobody | tyler | 4096 | Aug 18 05:16 | dir1
-rw-r--r-- |1 | | tyler| root |0 Aug 18 05:16 |file1
-rw-r--r-- |1 | |root |games |0 Aug 18 05:16 |file2

Las partes resaltadas muestran lo que es relevante para los permisos, el resto se puede ignorar. Las columnas resaltadas son los permisos, usuario, grupo y nombre de archivo, respectivamente. En el ejemplo anterior, dir1 es propiedad del usuario nobody y group tyler. Las cadenas de permiso suelen tener cuatro partes, especial, usuario, grupo y otros. Usted puede ver a. o un + en la cadena de permisos en su sistema. Esto significa que el archivo tiene una etiqueta SELinux y / o una ACL puede afectar a quién puede hacer lo que con un archivo.


# Permisos

La cadena de permisos para dir1 en el ejemplo anterior es 'drwxr-xr-x'. Vamos a romper esto en sus partes individuales:

| Parte  | Explicación |
 ------------|--------------------|
drwxr-xr-x |La primera posición muestra el tipo de archivo.
drwxr-xr-x | Los permisos que se aplican al propietario del archivo.
drwxr-xr-x |Los permisos que se aplican al grupo del archivo.
drwxr-xr-x | Los permisos que se aplican a todos los demás.


omencemos con el tipo de archivo. En este caso es d, lo que significa que este archivo es un directorio. Los directorios, junto con los archivos regulares, son los tipos más comunes de archivos que encontrará. Los archivos regulares se representan con un '-'. Revise la documentación de su sistema operativo para obtener una lista completa de todos los tipos.
Observe que hay tres conjuntos de tres caracteres que componen el resto de la cadena de permisos. Estos representan los cuatro (no, que no es un error tipográfico) conjuntos de permisos.

La sección owner es rwx, group is r-x, y todos los demás también son r-x. Las posiciones en cada conjunto de caracteres son importantes. El carácter izquierdo indica si el archivo se puede leer o no, el centro indica si se puede escribir, y el derecho si es ejecutable. En cada conjunto, una letra indica que algo está permitido, y un '-' si no está permitido. Por ejemplo, el 'w' en la cadena del propietario de rwx significa que el propietario puede escribir en el archivo. El '-' en la posición media del grupo y las cadenas de todos nos dicen que los miembros del grupo del archivo y todos los demás no están autorizados a escribir en el archivo. 

El permiso de ejecución le indica si está o no permitido ejecutar un programa o una secuencia de comandos, o utilizar un directorio. Generalmente si usted tiene el sistema de la ejecución, usted deseará el sistema de la lectura. Hay casos de esquina en los que se desea ejecutar pero no se lee. Por ejemplo, es posible que desee que un usuario pueda acceder a un directorio, pero no desea que vean el contenido de uno o más directorios de la ruta. 

Usted se está preguntando probablemente donde está el cuarto sistema especial. En la salida de ls, las posiciones de ejecución se sustituyen por una 's', 'S', 't' o 'T'. Una letra mayúscula significa que el permiso especial está activado, pero el permiso de ejecución no lo es. Una letra minúscula significa que los permisos especiales de permiso y ejecución están activados.


#Permisos especiales



Los permisos especiales se establecen como id de usuario (setuid), set group id (setgid) y el bit pegajoso. Setuid le permite ejecutar un archivo como el propietario en lugar del usuario en el que ha iniciado sesión. Lo mismo se aplica a setgid. El bit pegajoso impide que los usuarios eliminen cosas en un directorio, incluso si tienen acceso de escritura al directorio. Setgid en directorios establecerá el grupo de todos los archivos creados en el directorio al grupo de directorio. Setuid PUEDE hacer lo mismo con el propietario, pero la mayoría de los sistemas operativos no lo hacen.

#Representación numérica 

Usted no necesita saber octal y binario para entender esto. Usted sólo tiene que ser capaz de agregar a un nivel de primer grado. A menudo verá permisos representados como un número como 755 o 0755. Los números representan los cuatro conjuntos de permisos mencionados: especial, propietario, grupo y otros, respectivamente. Si no hay permisos especiales activados, puede omitirse. A cada permiso se le asigna un número. La tabla siguiente muestra las asignaciones de números.

|PERMISOS   |	NUMERO |
|--------------------|-------------------|
lectura |	4
escritura |	2
ejecución | 1

|PERMISOS	| NUMERO|
|-----------------------|-----------------|
Obtener Usuario ID	| 4
obtener Grupo ID	| 2
Sticky Bit	| 1

La versión numérica se calcula sumando las posiciones que están encendidas para cada conjunto y concatándolas. Digamos que tenemos una cadena de permisos rw-r-r-. No se establecen permisos especiales, el primer número es 0. El conjunto de propietarios ha leído y escrito. Puesto que la lectura es 4 y la escritura es 2, 4 + 2 = 6. Esto deja con 06 hasta ahora. El grupo y todos los demás conjuntos sólo han leído, por lo que son los dos 4. Ahora tenemos 0644. No tan mal, ¿verdad?

rwS-w-r-t es un ejemplo complicado con permisos especiales que probablemente nunca verás en la práctica. El setuid y el bit pegajoso se establecen, que son 4 y 1. Los permisos especiales de este archivo son 5. Como el 'S' es capital, el propietario sólo tiene que leer y escribir, que suman hasta 6, resultando en 56 así lejos. El grupo sólo tiene escritura, por lo que ahora estamos en 562. El t es minúscula, lo que significa que todo el mundo tiene ejecutar activado. 4 + 1 es 5, por lo que finalmente llegar a un modo de 5625.


#Cambio de permisos


Tres comandos se utilizan comúnmente para controlar la propiedad y los permisos. Son **chmod, chown, y chgrp**. En la parte inferior de esta sección, hay una tabla con ejemplos de cómo usar estos comandos para complementar las explicaciones.

El comando **chgrp** es muy simple. Simplemente escriba chrgp, opcionalmente algunas opciones, el nombre del grupo al que desea cambiar el grupo, seguido de nombre de archivo, en ese orden.
chgrp newgroup filename <El comando chown es casi identico. La única diferencia es que chown también puede cambiar el grupo también. Utilice el formato user: group para cambiar el grupo. Si omite el usuario y sólo especifica un grupo con: grupo, solo se cambiará el grupo. chown newowner nombre de archivo

El comando chmod se utiliza para cambiar los permisos de un archivo. Chmod puede usar símbolos que representan los cambios que se van a realizar, o la versión numérica descrita anteriormente. Cuál usted utiliza es enteramente preferencia. La versión numérica se explica por sí misma. Sólo tienes que escribir chmod, opcionalmente algunas opciones, el número que representa lo que desea que los permisos para ser, y luego el nombre del archivo, en ese orden.


chmod 644 nombre de archivo


La forma simbólica sigue el mismo orden, pero en lugar del modo se especifican los cambios a realizar. Usted especifica a qué conjunto desea que se aplique el permiso, '+' o '-' para indicar si desea otorgar o revocar el permiso y, a continuación, qué permisos modificar.



**Juego de permisos**

a - todos los conjuntos

u - usuario (propietario)

g - grupo

o - otros

**Permiso**

r - leer

w - escribe

x - ejecutar

s - setuid / setgid

t - bit pegajoso


#Cambiando Recursivamente Permisos

Supongamos que desea cambiar los permisos de un directorio y todos los archivos en él. Si hay un montón de archivos y / o subdirectorios, esto sería tedioso para hacer a mano. Los tres comandos cubiertos tienen una opción -R que hace esto por usted. CUIDADO con esto. En algunos sistemas chown / chmod / chgrp. * Se expandirá tiene .. como parte de la expansión glob, lo que significa que el comando subirá un directorio y luego hará los cambios allí también. Por ejemplo, si estás en / tmp, y hacer un chown -R tasha. *, Chown subirá un nivel y cambiar el propietario de cada archivo en su sistema y dependiendo de la configuración de compartir, NFS comparte a tasha! Una vez más, tenga cuidado con el -R.



#Referencia de comandos con ejemplos




|COMMAND	 | DESCRIPTION | EXAMPLES
|------------------------|------------------------|---------------------|
chmod    |	Changes a file’s permissions.    |	chmod 755 file1    chmod g+w file2
chown |	Changes a file’s owner. It can also change a file’s group |	chown bob myfile chown -R bob:group1 file2 chown :newgroup somefile
chgrp	| Changes a file’s group.	| chgrp biggroup bigfile



#Permisos predeterminados

Cuando crea un nuevo archivo o directorio, puede preguntarse cuáles serán los permisos o de dónde provienen. El umask responde a ambas preguntas. Para averiguar cuál es su umask, ejecute el comando umask. Restar ese número de 777. Si está creando un directorio, el modo será 777 menos la umask. Si está creando un archivo regular, los permisos serán 777 menos el umask, con el permiso de ejecución desactivado.


tyler@desktop:~/umask$ umask
0022

tyler@desktop:~/umask$ mkdir dir1

tyler@desktop:~/umask$ touch file1

tyler@desktop:~/umask$ ls -l

total 4

drwxr-xr-x 2 tyler tyler 4096 Aug 25 05:02 dir1

-rw-r--r-- 1 tyler tyler 0 Aug 25 05:02 file1



Mi umask es 0022. Reste de 777 y obtenga 755. Observe que el modo del dir1 recién creado es 755. El modo de file1 es 644. Recuerde, cuando se crean archivos regulares, el permiso de ejecución está desactivado.
Puedes cambiar tu umask. Para cambiar su umask, ejecute el comando umask seguido de lo que desea que sea. A mucha gente le gusta poner esto en los scripts de inicio de su shell.


#Práctica

Recomiendo altamente experimentar con permisos del archivo y del directorio. Un poco de práctica, especialmente con los permisos especiales, recorrerá un largo camino. Cree un directorio y algunos archivos en ese directorio. Cambiar permisos, propietarios (requiere root) y grupos. Cambie de usuario e intente acceder a ellos. Después de jugar con los permisos y los comandos utilizados para administrarlos un poco, usted debe tener una buena comprensión de cómo funcionan.


#Otras lecturas
Recomiendo el aprendizaje de listas de control de acceso (ACL). Las ACL están básicamente dando a un usuario o grupo su propio conjunto de permisos encima de los que ve con ls -l. Su sistema operativo puede tener algún tipo de sistema de control de acceso obligatorio (MAC) como el SELinux de Linux y las extensiones de confianza de Solaris. Si su sistema tiene cualquier tipo de MAC, al menos debería ser consciente de ello. Los ajustes de MAC y las ACL son un buen lugar para buscar si se encuentra con un comportamiento relacionado con el permiso que no tiene sentido. Si utiliza FreeBSD, tenga en cuenta que los indicadores de archivo pueden afectar al comportamiento del archivo.

