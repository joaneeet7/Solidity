//Especificamos la version
pragma solidity >=0.4.4 <0.7.0;

contract ValoresDeRetorno{
    
    //Funcion que nos devuelva un saludo
    function saludos() public returns(string){
        return "saludos";
    }
    
    //Esta funcion calcula el resultado de una multiplicacion de dos numeros enteros
    function Multiplicacion(uint _a, uint _b) public returns(uint){
        return _a*_b;
    }
    
    //Esta funcion devuelve true si el numero es par y false en caso contrario
    function par_impar(uint _a) public returns(bool){
        
        bool flag;
        
        if(_a%2==0){
            flag=true;
        }else{
            flag=false;
        }
        
        return flag;
    }
    
    //Realizamos una funcion que nos devuelve el cociente y el residuo de una division
    // ademas de una variable booleana que es true si el residuo es 0 y false en caso contrario
    function division(uint _a, uint _b) public returns(uint, uint, bool){
        uint q = _a/_b;
        uint r = _a % _b;
        bool multiplo=false;
        
        if(r==0){
            multiplo=true;
        }
        
        return (q,r,multiplo);
    }
    
    //Practica para el manejo de los valores devueltos
    
    function numeros() public returns(uint, uint, uint, uint, uint, uint){
        return (1,2,3,4,5,6);
    }
    
    //Asignacion multiple
    
    function todos_los_valores() public{
        
        //Declaramos las variables donde se guardan los valores de retorno de la funcion numeros()
        uint a;
        uint b;
        uint c;
        uint d;
        uint e;
        uint f;
        //Realizar la asignacion multiple
        (a,b,c,d,e,f)=numeros();
    }
    
    function ultimo_valor() public{
        
        (,,,,,uint ultimo)=numeros();
    }
    
    
}