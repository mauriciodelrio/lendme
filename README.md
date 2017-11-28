LendMe
===================


La solución a los problemas de espacios en la Universidad.

----------
[TOC]

Dependencias necesarias.
-------------

Para correr la aplicación se deben tener instaladas las siguientes dependencias de forma global:

* NVM configurado con:
	* Node 6.11
* Redis
* Postgresql
	* Se puede utilizar como interfaz gráfica PGAdmin4
* Heroku
* Git

Instalación
-------------

Una vez instaladas las dependencias se deben correr los siguientes comandos desde la carpeta raíz del proyecto:

```
npm install
npm start
```
 **Note:** Deben modificar en su reporitorio el string de conexión a BD Postgresql según la confirugración de su máquina.
 
Settings y heroku
-------------

Pueden conectarse directamente con heroku y usar las variables de configuración presentes, deben tener en cuenta que pueden cambiar el host para visualizar la ruta como http pero de forma local.