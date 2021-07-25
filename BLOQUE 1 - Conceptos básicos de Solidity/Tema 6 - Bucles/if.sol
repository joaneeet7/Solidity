pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract sentencia_if{
    
    //Numero ganador
    
    function probarSuerte(uint _numero) public pure returns(bool){
        if(_numero==1000){
            return true;
        }else{
            return false;
        }
    }
    
    //Valor absoluto de un numero 
    function valorAbsoluto(int _k) public pure returns(uint){
        if(_k<0){
            return -uint(_k);
        }else{
            return uint(_k);
        }
    }
    
    //Multiplo de 6
    function multiploSeis(uint _i) public pure returns(bool){
        uint dos_ultimas_cifras = _i%100;
        if((_i%2==0)&&(dos_ultimas_cifras%3==0)){
            return true;
        }else{
            return false;
        }
    }
    
    //Votacion de candidatos
    function votar(string memory _voto) public pure returns(string memory){
        
        string memory mensaje;
        
        if(keccak256(abi.encodePacked(_voto))==keccak256(abi.encodePacked("Joan"))){
            mensaje="Has votado a Joan";
        }else{
            if(keccak256(abi.encodePacked(_voto))==keccak256(abi.encodePacked("Gabriel"))){
                mensaje="Has votado a Gabriel";
            }else{
                if(keccak256(abi.encodePacked(_voto))==keccak256(abi.encodePacked("Maria"))){
                    
                }else{
                    mensaje="No hay ningun candidato con ese nombre";
                }
            }
        }
        return mensaje;
    }

}