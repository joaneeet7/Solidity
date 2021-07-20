pragma solidity ^0.4.0;

contract Funciones{
    
    
    
    /*
    
    Para declarar una funcion en solidity:
   
    function <nombre_funcion>(<argumentos>) {public | private} {
        ...
   }
   
   public:
   
   private:
   
   */
   
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
   
   
   function overflow(uint _cantidad, string _causa) private returns(bool over){
       Causa c=  causas[_causa];
       over=false;
       if(c.cantidad_recaudada+_cantidad<=c.precio_objetivo){
           over=true;
       }
       return over;
   }
   
   
   
   function donar(uint _cantidad, string  _causa) public returns(bool aceptar_donacion){
       
       Causa c = causas[_causa];
       aceptar_donacion=true;
       if(overflow(_cantidad, _causa)){
           c.cantidad_recaudada= c.cantidad_recaudada+_cantidad;
       }else{
           aceptar_donacion=false;
       }
       return aceptar_donacion;
   }
   
   
   function comprobar_cantidad(string _name) public returns(bool flag){
       flag= false;
       Causa c = causas[_name];
       if(c.cantidad_recaudada>=c.precio_objetivo){
           flag= true;
       }
       return flag;
   }
   
}