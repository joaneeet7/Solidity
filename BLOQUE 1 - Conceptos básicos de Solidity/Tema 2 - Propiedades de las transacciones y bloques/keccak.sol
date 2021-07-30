pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract hash{
    
    function calcularHash() public pure returns(bytes32){
        return keccak256("Hola");
    }
    
    function calcularHashMultiple() public pure returns(bytes32){
        return keccak256(abi.encodePacked("hola","hola", "3"));
    }
}