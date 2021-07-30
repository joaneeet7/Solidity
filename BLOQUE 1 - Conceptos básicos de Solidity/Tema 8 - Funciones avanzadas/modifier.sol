pragma solidity >=0.4.4 <0.7.0;

contract Modifier{
    
    //Ejemplo de solo propietario del contrato puede ejecutar una funcion
    address owner;
    
    constructor() public{
        owner =msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender==owner, "No tienes permisos");
        _;
    }
    
    function ejemplo() public onlyOwner(){
        //Codigo de la funcion a ejecutar solo por el propietario del contrato
    }
    
    //Ejemplo solo personas de alta 
    
    struct cliente{
        address direccion;
        string nombre;
    }
    
    mapping(string=>address) clientes;
    
    function altaCliente(string _nombre) public {
        clientes[_nombre] = msg.sender;
    }
    
    modifier soloClientes(string _nombre){
        require(clientes[_nombre]==msg.sender);
        _;
    }
    
    function ejemplo2(string _nombre) public soloClientes(_nombre){
        //Codigo de la funcion a ejecutar para los clientes
    }
    
    
    //Ejemplo conduccion

    modifier MayorEdad(uint _edadMinima, uint _edadUsuario) {
      require (_edadUsuario >= _edadMinima);
      _;
    }

    // Tienes que ser mayor a 18 años para conducir un coche (en EEUU, al menos).
    // Podemos llamar al modificador de función `olderThan` pasandole argumentos de esta manera:
    function conducir(uint _edad) public MayorEdad(18, _edad){
      //Codigo de la funcion para los mayores de edad
    }
}
