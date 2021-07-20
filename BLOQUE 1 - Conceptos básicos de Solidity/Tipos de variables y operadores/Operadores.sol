pragma solidity ^0.4.0;



contract Operadores{
    
    /*
    Operaodres aritmeticos
    
    Suma: +
    Resta: -
    Multiplicacion: *
    Division: /
    Exponencial: **
    Modulo: %
    
    */
    
    uint a = 3245;
    uint b = 1257;
    uint q = a/b;
    uint r = a%b;
    
    //Sabemos si dividimos a/b entonces a=b*q+r
    
    
    function test() public view returns(uint num){
        return (b*q+r);
    }
    
    function test2()  public view returns(uint num){
        return (a-b*q);
    }
    
    
    /*
    Operadores booleanos
    
    Negacion !
    And &&
    Or ||
    igualdad ==
    inigualdad !=
    
    */
    
    //Ejemplo operador ==
    function test3() public view returns(bool){
        bool flag = false;
        if(r==(a-b*q)){
           flag=true;
        }
        return flag;
    }
    
    //Ejemplo operador &&
    
    function test4() public view returns(bool){
        bool flag = false;
        uint d = a-b*q;
        uint f = b*q+r;
        
        if((r==d) && (a==f)){
            flag=true;
        }
        return flag;
    }
    
    //Criterio de divisibilidad entre 5: si el numero termina en 0 o en 1257
    
    //Ejemplo operador ||
    function divisibleEnrte5(uint _num) public view returns(bool){
        bool flag = false;
        uint ultima_cifra = _num % 10;
        if((ultima_cifra == 0) || (ultima_cifra ==5)){
            flag = true;
        }
        return flag;
    }
    
     function divisibleEnrte5V2(uint _num) public view returns(bool){
        bool flag = true;
        uint ultima_cifra = _num % 10;
        if((ultima_cifra != 0) && (ultima_cifra !=5)){
            flag = false;
        }
        return flag;
    }
    
    /*
    Comparaciones
    Mayor o igual: >=
    Menor o igual: <=
    Mayor estricto: >
    Menor estricto: <
    Igualdad: ==
    Inigualdad: !=
    */
    
    
    
}


