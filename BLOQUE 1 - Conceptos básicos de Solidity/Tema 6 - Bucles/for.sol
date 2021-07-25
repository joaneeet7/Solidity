pragma solidity >=0.4.4 <0.7.0;


contract bucle_for{
    
    //Suma de los 100 numeros a partir de uno dado
    function Suma(uint _k) public pure returns(uint){
        
        uint suma=0;
        for(uint i=_k; i<=100; i++){
           suma=suma+i; 
        }
        return suma;
    }
    //Buscar en array
    address [] elementos;
    
    function asociar() public {
        elementos.push(msg.sender);
    }
    
    function comprobarAsociacion() public view returns(bool, address){
        
        for(uint i=0; i<elementos.length; i++){
            if(msg.sender==elementos[i]){
                return (true, elementos[i]);
            }
        }
        
    }
    
    //Doble for: Suma de los 10 primeros factoriales
    
    function sumaFactorial() public pure returns(uint){
        uint suma=0;
        for (uint i=1; i<=10; i++){
            uint factorial=1;
            for(uint j=2; j<=i; j++){
                factorial = factorial*j;
            }
            suma = suma+factorial;
        }
        
        return suma;
    }
    
    
}