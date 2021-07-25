pragma solidity >=0.4.4 <0.7.0;

contract bucle_while{
    
    //Suma de los numeros impares menores a 100
    function suma_impares() public pure returns(uint){
        
        uint counter =1;
        uint suma;
        
        while(counter<=100){
           if(counter%2!=0){
               suma = suma+counter;
           }
           counter++;
       } 
       return suma;
    }
    
    //Espera de 1 minuto
    uint time;
    
    function fijarTiempo() public {
        time = now;
    }
    
    function espera() public view returns(bool){
        
        while(now<time+ 5 seconds){
            return false;
        }
        
        return true;
    }
    
    
    //Siguiente numero primo
    function siguientePrimo(uint _p) public pure returns(uint){
        
        bool flag =false;
        uint counter=_p+1;
        
        while(flag==false){
            
            //comprobamos si es primo
            bool primo =true;
            uint i=2;
            while(i<counter){
                if(counter%i==0){
                    primo=false;
                    break;
                }
                i++;
            }
            
            if(primo==true){
                flag=true;
            }
            
            counter++;
        }
        return (counter-1);
    }
}