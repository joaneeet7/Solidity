pragma solidity ^0.4.0;

contract bytes_address_enum{
    
    bytes32 ejemplo_bytes = keccak256("hola");
    
    address direccion = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address dir = msg.sender;
    
    enum estado {ON, OFF}
    estado state;
    
    function encender() public{
        state = estado.ON;
    }
    
    function apagar() public{
        state = estado.OFF;
    }
    
    function fijarEstado(uint _estado) public{
        state = estado(_estado);
    }
    
    function Estado() public view returns(estado){
        return state;
    }
}