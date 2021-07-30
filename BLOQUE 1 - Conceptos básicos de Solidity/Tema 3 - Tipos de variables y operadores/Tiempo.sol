pragma solidity ^0.4.0;

contract tiempo{
    //Tiempo
    uint ahora = now;
    uint  mintuo =  1 minutes;
    uint hora = 1 hours;
    uint dia = 1 days;
    uint semana = 1 weeks;
    uint year = 1 years;
    
    //Operaciones con Tiempo
    
    function MasSegundos() public view returns(uint){
        return now + 1 seconds;
    }
    
    function MasHoras() public view returns(uint){
        return now+1 hours;
    }
    
    function MasDias() public view returns(uint){
        return now +1 days;
    }
    
    function MasSemanas() public view returns(uint){
        return now+2 weeks;
    }

}