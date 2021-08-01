pragma solidity >=0.4.4 <0.7.0;

contract Banco{
    
    struct cliente{
        string nombre;
        uint dinero;
    }
    
    mapping(string => cliente) clientes; 
    
    function nuevoCliente(string memory _nombre) public {
        clientes[_nombre] = cliente(_nombre, 0);
    }
    
}

contract Cliente is Banco{
    
    function AltaCliente(string memory _nombre) public{
        nuevoCliente(_nombre);
    }
    
    function IngresarDinero(string memory _nombre, uint _cantidad) public {
        clientes[_nombre].dinero = clientes[_nombre].dinero + _cantidad;
    }
    
    function RetirarDinero(string memory _nombre, uint _cantidad) public returns(bool, uint){
       
        bool flag=true;
        
        if(clientes[_nombre].dinero-_cantidad>0){
            clientes[_nombre].dinero = clientes[_nombre].dinero + _cantidad;
        }else{
            flag=false;
        }
        
        return(flag, clientes[_nombre].dinero);
    }
    
}
