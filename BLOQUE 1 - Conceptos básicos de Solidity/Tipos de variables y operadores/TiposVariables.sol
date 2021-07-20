pragma solidity ^0.4.0;

contract TiposVariables{
    
    /*
    Variables enteras
    
    uint -> Enteros sin signo
    int -> Enteros con signo
    
    Por defecto, uint y int son variables enteras de 256 bits, se puede especificar el numero de bits requeridos. 
    
    uintx 
    intx   
    
    Donde x varia de 8 a 256 en pasos de 8.
    
    */
    
    uint myNumber;
    uint cota = 5000;
    int myNumber_2;
    
    //uint y int con un numero especifico de bits.
    
    uint8 EnteroDe8Bits;
    uint16 EnteroDe16Bits;
    uint32 EnteroDe32Bits;
    int128 EnteroDe128Bits;
    enum Estado {Encendido, Apagado}

    constructor () public {
        
    }
    
    //Notemos que uint256 es lo mismo que uint. Lo mismo pasa con int256 y int.
    uint32 cota_2 = uint32(cota);
    
    //Fer més exemples
    function convertir() view returns(uint32 num){
        return cota_2;
    }
    
    /*
    Tambien podemos declarar las variables strings y booleanas. 
    */
    
    string greeting = "hola";
    bool flag = true;

    /*

    */
    
}


