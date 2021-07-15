pragma solidity ^0.4.0;
 pragma experimental ABIEncoderV2;
 
 contract Arrays{
     
     /*
     Un array en solidity se declara del siguiente modo:
     
     <tipo_de_dato>[<longitud>] <nombre_array>;
     
     */
     
     //Array de enteros de longitud 5
     uint[5] array_enteros;
     //Array de enteros de 32 bits
     uint32[6] array_enteros_32_bits;
     //Array de strings de longitud 2
     string[4] array_strings;
     
     //Array de structuras
     struct Persona{
         string name;
         uint age;
     }
     
     Persona[4] array_personas;
     
     /*
     Tambien podemos declarar arrays dinamicos 
     <tipo_de_dato>[] <nombre_array>;
     */
     
     Persona[] array_personas_dinamico;
     uint[] numbers;
     string[] names;
     
     /*
     La funcion <nombre_array>.push() nos sirve para añadir un elemento al final del array 
     */
     
    function modificar_array() public{
        numbers.push(1);
        numbers.push(2);
        numbers.push(3);
        array_personas_dinamico.push(Persona("Juan Gabriel",32));
        array_personas_dinamico.push(Persona("Joan Amengual",22));
        array_personas_dinamico.push(Persona("Joan Pont",22));
    }
    
    function convertir() public view returns(Persona[]){
        return array_personas_dinamico;
    }
     
 }