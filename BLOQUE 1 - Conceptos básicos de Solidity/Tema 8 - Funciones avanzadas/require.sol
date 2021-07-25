pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Require{
    
    function password(string _name) public pure returns(string) {
        require(keccak256(abi.encodePacked(_name))==keccak256(abi.encodePacked("12345")), "Contraseña incorrecta");
        return "Contraseña correcta";
    }
    
    uint ultimo_pago =0;
    uint cartera = 0;
    
    function pagar(uint _cantidad) public returns(uint){
        
        require(now > ultimo_pago+10 seconds,"Aun no puedes pagar");
        cartera=cartera+_cantidad;
        ultimo_pago=now;
        return cartera;
    }
    
    
    string [] nombres;
    
    function nuevoNombre(string _nombre) public{
        
        for(uint i=0; i<nombres.length; i++){
            require(keccak256(abi.encodePacked(_nombre))!=keccak256(abi.encodePacked(nombres[i])), "Ya esta en la lista");
        }
        nombres.push(_nombre);
    }
    
    
}