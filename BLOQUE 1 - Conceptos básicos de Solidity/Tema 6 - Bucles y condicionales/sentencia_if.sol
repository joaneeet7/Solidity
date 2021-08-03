//Indicar la version
pragma solidity >=0.4.4 <0.7.0;

contract sentencia_if{
    
    //Numero ganador
    function probarSuerte(uint _numero) public pure returns(bool){
        
        bool ganador;
        if(_numero == 100){
            ganador=true;
        }else{
            ganador = false;
        }
        
        return ganador;
        
        /*
        bool ganador = false;
        if(_numero==100){
            ganador =true;
        }
        return ganador;
        */
    }
    
    //Calculamos el valor absoluto de un numero
    
    function valorAbsoluto(int _k) public pure returns(uint){
        
        uint valor_absoluto_numero;
        if(_k<0){
            valor_absoluto_numero = uint(-_k);
        }else{
            valor_absoluto_numero = uint(_k);
        }
        
        return valor_absoluto_numero;
    }
    
    //Devolver true si el numero introducido es par y tiene tres cifras
    
    function parTresCifras(uint _numero) public pure returns(bool){
        bool flag;
        
        if((_numero%2==0)&&(_numero>=100)&&(_numero<999)){
            flag = true;
        }else{
            flag=false;
        }
        
        return flag;
    }
    
    //Votacion
    //Solo hay tres candidatos: Joan, Gabriel y Maria
    
    function votar(string memory _candidato) public pure returns(string memory){
        
        string memory mensaje;
        
        if(keccak256(abi.encodePacked(_candidato))==keccak256(abi.encodePacked("Joan"))){
            mensaje = "Has votado correctamente a Joan";
        }else{
            if(keccak256(abi.encodePacked(_candidato))==keccak256(abi.encodePacked("Gabriel"))){
                mensaje = "Has votado correctamente a Gabriel";
            }else{
                if(keccak256(abi.encodePacked(_candidato))==keccak256(abi.encodePacked("Maria"))){
                    mensaje = "Has votado correctamente a Maria";
                }else{
                    mensaje = "Has votado a un candidato que no está en la lista";
                }
            }
        }
        
        return mensaje;
    }
    
}