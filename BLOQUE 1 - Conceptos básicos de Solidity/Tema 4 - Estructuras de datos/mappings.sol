// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Mappings{
    
    //Declaramos un mapping para elegir un numero
    mapping (address => uint) public elegirNumero;
    
    function ElegirNumero(uint _numero) public{
        elegirNumero[msg.sender] = _numero;
    }
    
    function consultarNumero() public view returns(uint){
        return elegirNumero[msg.sender];
    }
    
    //Declaramos un mapping que relaciona el nombre de una persona con su cantidad de dinero
    mapping (string => uint) cantidadDinero;
    
    function Dinero(string memory _nombre, uint _cantidad) public{
        cantidadDinero[_nombre] = _cantidad;
    }
    
    function consultarDinero(string memory _nombre) public view returns(uint){
        return cantidadDinero[_nombre];
    }
    
    //Ejemplo de mapping con un tipo de dato complejo
    struct Persona{
        string nombre;
        uint edad;
    }
    
    mapping(uint => Persona) personas;
    
    function dni_Persona(uint _numeroDni, string memory _nombre, uint _edad) public{
        personas[_numeroDni] = Persona(_nombre, _edad);
    }
    
    function VisualizarPersona(uint _dni) public view returns(Persona memory){
        return personas[_dni];
    }
    
}