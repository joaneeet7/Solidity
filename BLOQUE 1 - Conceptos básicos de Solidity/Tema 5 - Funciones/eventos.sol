pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Eventos{
    
    //Declararmos los eventos a utilizar
    event nombre_evento1 (string _nombrePersona);
    event nombre_evento2 (string _nombrePersona, uint _edadPersona);
    event nombre_evento3(string, uint, address, bytes32);
    event abortarmision();
    
    function EmitirEvento1(string memory _nombrePersona) public{
        emit nombre_evento1(_nombrePersona);
    }
    
    function EmitirEvento2(string memory _nombrePersona, uint _edad) public{
        emit nombre_evento2(_nombrePersona, _edad);
    }
    
    function EmitirEvento3(string memory _nombrePersona, uint _edad) public{
        bytes32 hash_id = keccak256(abi.encodePacked(_nombrePersona, _edad, msg.sender)); 
        emit nombre_evento3(_nombrePersona, _edad, msg.sender, hash_id);
    }
    
    function AbortarMision() public {
        emit abortarmision();
    }
}