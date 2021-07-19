
/*
Cuando especificamos una versión de la forma "^0.4.0" no se compilará con un compilador con una versión anterior a 0.4.0 ni tampoco 
con una versión posterior a 0.5.0.

Para especificar un rango de versiones lo podemos hacer del siguiente modo: >=0.4.0 <0.7.0

*/

pragma solidity ^0.4.25;


/*
Para crear un contrato debemos usar la palabra contract seguido del nombre del contrato:

"contract <nombre contrato>{
    
}"

*/


//Este es un comentario de una linea

/*
Este es un bloque de comentarios donde podemos poner diversas lineas de comentarios
*/

/*
En Solidity el estandard de comentarios es el formato natspec que tiene el siguiente aspecto:

/// @title titulo del contrato
/// @author autor del contrato
/// @notice explica que hace el contrato o funcion

Comentarios para funciones

///@param explica para que sirve cada parametro
///@return explica el valor de retorno de una funcion
///@dev Explica lo que hace una funcion, incluye detalles adicionales a los desarroladores


*/


contract PrimerContrato{
    
    /*
    El constructor se especifica del siguiente modo:
    
    constructor() public{
        
    }
    
    Debe incluir la informacion necesaria para construir el contrato. Por ejemplo la direccion de la persona que despliegue el contrato 
    para identificar el propietario del contrato.
    si el contrato es muy simple no es necesario su uso.
    Debe incluir la informacion inmutable del contrato
    
    */
    
    
    constructor() public{
        
    }
    
    
    //
    string greeting="hola mundo";
    
    function HolaMundo() view returns(string saludo){
        return greeting;
    }
    
    
}


