//Indicar la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract public_private_internal{
    
    //Modificador public 
    uint public mi_entero = 45;
    string public mi_string = "Joan";
    address public owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    //Modificador private
    uint private mi_entero_privado = 10;
    bool private flag =true;
    
    function test(uint _k) public{
        mi_entero_privado = _k;
    }
    
    //Modificador internal
    bytes32 internal hash = keccak256(abi.encodePacked("hola"));
    address internal direccion = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    
    
    
}