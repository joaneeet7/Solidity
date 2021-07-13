// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  CANDIDATO   |   EDAD   |      ID
// -----------------------------------
//  Toni        |    20    |    12345X
//  Alberto     |    23    |    54321T
//  Joan        |    21    |    98765P
//  Javier      |    19    |    56789W

contract votacion{
    
    // Direccion del propietario
    address owner;
    
    // Constructor
    constructor () public {
        owner = msg.sender;
    }
    
    // Relacion entre el nombre del candidato y el hash de sus datos personales
    mapping (string => bytes32) ID_Candidato;
    // Lista para alamecenar los nombres de los candidatos
    string [] candidatos; 
    
    // Los representantes se presentan como candidatos
    function Representar(string memory _nombrePersona, uint _edadPersona, string memory _idPersona) public {
        // Hash de los datos del candidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _idPersona));
        // Almacenamiento del hash de los datos del candidato ligados a su nombre 
        ID_Candidato[_nombrePersona] = hash_Candidato;
        // Almacenamiento del nombre del candidato
        candidatos.push(_nombrePersona);
    }
    
    // Ver que personas se han presentado 
    function VerCandidatos() public view returns(string [] memory ) {
        // Devuelve la lista de candidatos presentados
        return candidatos;
    }
    
    // Relacion entre el nombre del candidato votado y el numero de votos
    mapping (string => uint) votos_Candidato;
    // Hash de la identidad del votante
    bytes32 [] votantes;
    
    // Los votantes votan a los candidatos
    function Votar(string memory _candidato) public {
        // Hash de los datos del votante
        bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));
        
        // Verificamos si el votante ya ha votado previamente
        for (uint i = 0; i< votantes.length; i++){
            require (votantes[i] != hash_Votante, "Ya has votado previamente.");
        }
        
        // Almacenamiento del hash de la identificacion del votante
        votantes.push(hash_Votante);
        
        // Añadimos un voto al candidato seleccionado 
        votos_Candidato[_candidato]++;
    }

    // Dado el nombre de un candidato se pueden ver sus votos
    function VerVotos(string memory _candidato) public view returns (uint){
        return votos_Candidato[_candidato];
    }
    
    // NO EXPLICAR ESTA FUNCION, ES DE AYUDA
    // Funcion para pasar de uint a string: Necesaria para ver los resultados de la funcion VerResultados()
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    
    // Ver los resultados de todos los candidatos
    function VerResultados() public view returns (string memory){
        string memory resultados = "";
        for (uint i = 0; i< candidatos.length; i++){
            string memory _candidato = candidatos[i];
            resultados = string(abi.encodePacked(resultados, "(", _candidato, ", ", uint2str(VerVotos(_candidato)), ") ------"));
        }
        return resultados;
    }
    
    // Determina el ganador de la votacion
    function Ganador() public view returns (string memory) {
    
    string memory ganador= ""; 
    
    for (uint i = 0; i< candidatos.length; i++){
        
        // TODO: EMPATE ENTRE LOS CANDIDATOS 
        
        // Puntuacion maxima 
        if (votos_Candidato[candidatos[i]] > votos_Candidato[ganador]){
            ganador = candidatos[i];
            }
    }
        
    return ganador;
        
    }
    
}
        



