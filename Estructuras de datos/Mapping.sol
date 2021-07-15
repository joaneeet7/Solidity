pragma solidity ^0.4.0;


contract Mappings{
    
    /*
    Un mapeo es esencialmente una asociación clave-valor para guardar y ver datos. Sirven para organizar datos, del mismo modo que 
    las estructuras.
    
    Declarar un mapping:
    mapping(_keyType, _valueType) <nombre_mappging>;
    
    
    _keyType: Puede tomar cualquier tipo excepto mapping.
    _valueType: Puede tomar cualquier tipo, incluido mapping.
    
    */
   
   mapping(address=>uint) chooseNumber;
   
   function setNumber(uint _number) public{
       chooseNumber[msg.sender]= _number;
   }
   
   function ConsultNumber() public view returns(uint){
       return chooseNumber[msg.sender];
   }
   
   mapping(string=>uint) balances;
   
   function SupplyIncome(uint _income) public{
       balances["Joan"]=_income;
   }
   
   function getIncome() public view returns(uint){
       return balances["Joan"];
   }
}