pragma solidity ^0.4.0;

contract Returns{
   
   /*
   Para devolver un valor desde una funcion la declaracion es la siguiente:
   
   function <nombre_funcion>(<argumentos>) {public | private} [returns (<return_types>)]{
       
       return [valores_de_retorno];
   }
   
   */
   
   string  hello = "hello";
   
   function greeting() public returns(string){
       
       return hello;
   }
   
   function multiplicar(uint _a, uint _b) public returns(uint){
       return _a*_b;
   }
   
   function par_impar(uint _a) public returns(bool){
       
       if(_a%2==0){
           return true;
       }else{
           return false;
       }
   }
   
   //Tambien se puede devolver más de un valor. Simplemente escribimos cada uno de los tipos de valores a devolver separados por una coma.
   
   function division(uint _a, uint _b) public returns (uint q, uint r, bool multiplo){
       q=_a/_b;
       r= _a%_b;
       multiplo = false;
       if(r==0){
          multiplo==true; 
       }
       return (q,r,multiplo);
   }
   
   function numeros() public returns(uint a, uint b, uint c, uint d, uint e, uint f){
       return (1,2,3,4,5,6);
   }
   
   //Realizar multiples asignaciones
   
   function todos_los_valores() public{
       
       uint a;
       uint b;
       uint c;
       uint d;
       uint e;
       uint f;
       
       (a,b,c,d,e,f)=numeros();
   }
   
   function ultimo_valor() public{
       
       uint ultimo;
       (,,,,,ultimo)=numeros();
   }
   
   
   
}