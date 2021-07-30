
pragma solidity >=0.4.4 <0.7.0;

contract eso{
    
    
    
    function BlockCoinbase() public view returns(address){
        return block.coinbase;
    }
    
    function BlockDifficulty() public view returns(uint){
        return block.difficulty;
    }
    
    function BlockGaslimit() public view returns(uint){
        return block.gaslimit;
    }
    
    function BlockNumber() public view returns(uint){
        return block.number;
    }
    
    function BlockTimestamp() public view returns(uint){
        return block.timestamp;
    }
    
    function MsgData() public pure returns(bytes){
        return msg.data;
    }
    
    function MsgGas() public view returns(uint){
        return msg.gas;
    }
    
    function MsgSender() public view returns(address){
        return msg.sender;
    }
    
    function MsgSig() public pure returns(bytes4){
        return msg.sig;
    }
    
    function MsgValue() public view returns(uint){
        return msg.value;
    }
    
    function Now() public view returns(uint){
        return now;
    }
    
    function TxGasPrice() public view returns(uint){
        return tx.gasprice;
    }
    
    function TxOrigin() public view returns(address){
        return tx.origin;
    }
}