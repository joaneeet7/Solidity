pragma solidity ^0.4.0;

contract Funciones{
   
   struct Causa{
       uint Id;
       string name;
       uint precio_objetivo;
       uint cantidad_recaudada;
   }
   
   uint contador=0;
   mapping(string=>Causa) causas;
   
   function nuevaCausa(string _name, uint _price) public{
       contador = contador++;
       causas[_name]=Causa(contador, _name, _price, 0);
   }
   
   function obtener_causa(string _name) private returns(Causa){
       return causas[_name];
   }
   
   function donar(uint _cantidad, string _causa) public{
       Causa c = obtener_causa(_causa);
       c.cantidad_recaudada= c.cantidad_recaudada+_cantidad;
   }
   
   
   function comprobar_cantidad(string _name) public returns(bool flag){
       flag= false;
       Causa c = obtener_causa(_name);
       if(c.cantidad_recaudada>=c.precio_objetivo){
           flag= true;
       }
       return flag;
   }
   
}