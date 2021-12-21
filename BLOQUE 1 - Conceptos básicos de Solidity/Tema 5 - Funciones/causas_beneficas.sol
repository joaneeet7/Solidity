//Especificamos la version
pragma solidity >=0.4.4 <0.7.0;

contract causasBeneficas{
    
    //Declaraciones necesarios
    struct Causa{
        uint Id;
        string name;
        uint precio_objectivo;
        uint cantidad_recaudada;
    }
    
    uint contador_causas=0;
    mapping (string => Causa) causas;
    
    //Permite dar de alta una nueva causa
    function nuevaCausa(string memory _nombre, uint _precio_objectivo) public payable{
        contador_causas = contador_causas++;
        causas[_nombre] = Causa(contador_causas, _nombre, _precio_objectivo, 0);
    }
    
    //Esta funcion nos devuelve true en caso de que podamos donar a una causa y false en caso contrario
    
    function objetivoCumplido(string memory _nombre, uint _donar) private view returns(bool){
        
        bool flag = false;
        Causa memory causa = causas[_nombre];
        
        if(causa.precio_objectivo >= (causa.cantidad_recaudada+_donar)){
            flag=true;
        }
        return flag;
        
    }
    
    
    //Esta funcion nos permite donar a una causa 
    function donar(string memory _nombre, uint _cantidad) public returns(bool){
        
        bool aceptar_donacion=true;
        
        if(objetivoCumplido(_nombre, _cantidad)){
            causas[_nombre].cantidad_recaudada = causas[_nombre].cantidad_recaudada + _cantidad;
        }else{
            aceptar_donacion = false;
        }
        return aceptar_donacion;
    }
    
    //Esta funcion nos dice si hemos llegado al precio objetivo 
    function comprobar_causa(string memory _nombre) public view returns(bool, uint){
        
        bool limite_alcanzado = false;
        Causa memory causa = causas[_nombre];
        
        if(causa.cantidad_recaudada>=causa.precio_objectivo){
            limite_alcanzado = true;
        }
        
        return (limite_alcanzado, causa.cantidad_recaudada);
        
    }
    
}