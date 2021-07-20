pragma solidity ^0.4.0;

contract Eventos{
    
    /*
    Los eventos son la forma en la que nuestro contrato comunica que algo sucedió en la cadena de bloques a la interfaz de usuario, 
    el cual puede estar 'escuchando' ciertos eventos y hacer algo cuando sucedan.
    
    event <nombre_evento> (<types>);
    
    Emitir un evento:
    
    emit <nombre_evento>(<types>);
    
    */
    
    // Eventos declarados
    event nombre_evento1 (string _nombrePersona);
    event nombre_evento2 (string _nombrePersona, uint _edadPersona);
    event nombre_evento3 (string _nombrePersona, uint _edadPersona, address _direccionPersona);
    event nombre_evento4 (string, uint, address, bytes32);
    event AbortamosMision ();
    
    // Funciones para emitir eventos 
    function EmitirEvento1(string memory _nombrePersona) public {
        emit nombre_evento1(_nombrePersona);
    }
    
    function EmitirEvento2(string memory _nombrePersona, uint _edadPersona) public {
        emit nombre_evento2(_nombrePersona, _edadPersona);
    }
    
    function EmitirEvento3(string memory _nombrePersona, uint _edadPersona) public {
        emit nombre_evento3(_nombrePersona, _edadPersona, msg.sender);
    }
    
    function EmitirEvento4(string memory _nombrePersona, uint _edadPersona) public {
        // Spoiler: Hash de la identidad de la persona
        bytes32 hash_id_persona = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, msg.sender));
        emit nombre_evento4(_nombrePersona, _edadPersona, msg.sender, hash_id_persona);
    }
    
    function AbortarMision() public {
        emit AbortamosMision();
    }
    
}
    