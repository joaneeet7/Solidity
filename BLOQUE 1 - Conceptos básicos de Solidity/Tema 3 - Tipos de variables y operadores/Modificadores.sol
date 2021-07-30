pragma solidity ^0.4.0;

contract public_internal_private{
    
    uint public j=5;
    string public greeting ="Saludos";
    address private direccion= msg.sender;
    bytes32 internal hash = keccak256("Joan");
    
}