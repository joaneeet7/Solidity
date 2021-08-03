//Indicamos la version
pragma solidity >=0.4.4 <0.7.0;

contract funciones_globales{
    
    //Funcion msg.sender
    function MsgSender() public view returns(address){
        return msg.sender;
    }
    
    //funcion now
    function Now() public view returns(uint){
        return now;
    }
    
    //funcion block.coinbase
    function BlockCoinbase() public view returns(address){
        return block.coinbase;
    }
    
    //funcion block.difficulty
    function BlockDifficulty() public view returns(uint){
        return block.difficulty;
    }
    
    //funcion block.number 
    function BlockNumber() public view returns(uint){
        return block.number;
    }
    
    //Funcion msg.sig 
    function MsgSig() public view returns(bytes4){
        return msg.sig;
    }
    
    //funcion tx.gaspricev
    function txGasPrice() public view returns(uint){
        return tx.gasprice;
    }
    
}