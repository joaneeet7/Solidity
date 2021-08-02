pragma solidity >=0.4.4 <0.7.0;
import "./Mates.sol";

/*library Mates{
    function division(uint _i, uint _j) public pure returns(uint, uint){
        require(_j>0);
        return _i/_j;
    }
}*/


contract calculos{
    
    using Mates for uint;
    
    function calcular(uint _a, uint _b) public pure returns(uint){
        uint q = _a.division(_b);
        return q;
    }
    
}