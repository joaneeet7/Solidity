pragma solidity ^0.4.0;



contract Estructuras{
    
    /*
    Solidity incluye tipos de datos mas complejos: Las estructuras. Para crear una estructura debemos hacerlo del siguiente modo
    
    struct <Nombre_Estructura>{
        <Propiedades de la estructura>
    }
    
    */
   
   //Cliente de alguna página web de pago
   struct cliente{
       uint id;
       string name;
       string dni;
       string mail;
       uint phone_number;
       uint credit_card;
   }
   
   //Amazon
   struct producto{
       string name;
       uint price;
   }
   
   
   //Proyecto de una ONG
    struct ONG{
       address ong;
       uint name;
   }
   
   struct Causa{
       uint Id;
       string name;
       uint price;
   }
   
   
}