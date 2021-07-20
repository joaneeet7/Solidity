pragma solidity ^0.4.0;

contract Modificadores{
    
    /*
   Para devolver un valor desde una funcion la declaracion es la siguiente:
   
   function <nombre_funcion>(<argumentos>) {public | private} [view | pure] [returns (<return_types>)]{
       
   }
   
   view: Se pueden ver los datos pero no modificarlos
   
   pure: No se acceden a los datos.
   Esta función no lee desde el estado de la aplicación - el valor devuelto depende por completo de los parámetros que le pasemos.

   
   view nos indica que al ejecutar la función, ningún dato será guardado/cambiado. pure nos indica que la función no sólo no guarda 
   ningún dato en la blockchain, si no que tampoco lee ningún dato de la blockchain. 
   Ambos no cuestan nada de combustible para llamar si son llamados externamente desde afuera del contrato 
   (pero si cuestan combustible si son llamado internamente por otra función).
   
   payable: Son un tipo de función especial que pueden recibir Ether.
   */
   
   
   string[] lista;
   
   function nuevo_alumno(string _nombre) public{
       lista.push(_nombre);
   }
   
   function ver_alumno(uint _posicion) public view returns (string){
       return lista[_posicion];
   }
   
   uint x=10;
   function add(uint _b) public view returns(uint){
       return x+_b;
   }
   
   
   function exponenciacion(uint _a, uint _b) public pure returns(uint){
       return _a**_b;
   }
   
   
   // ------------------------------- FUNCION DE PAGO -------------------------------
   
   mapping (address => cartera) DineroCartera;
   
   struct cartera{
       string nombre_persona;
       address direccion_persona;
       uint dinero_cartera;
   }
   
   function Pagar(string memory _nombrePersona, uint _cantidad) public payable{
      cartera memory mi_cartera;
      mi_cartera = cartera(_nombrePersona,msg.sender, _cantidad);
      DineroCartera[msg.sender] = mi_cartera;
   }
   
   function VerSaldo() public view returns (string memory nombre, address direccion, uint dinero){
        nombre = DineroCartera[msg.sender].nombre_persona;
        direccion = DineroCartera[msg.sender].direccion_persona;
        dinero = DineroCartera[msg.sender].dinero_cartera;
   }
   
   
}