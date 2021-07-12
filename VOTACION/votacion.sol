// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;


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
    function Votar(string memory _candidato, string memory _IDVotante) public {
        // Hash de los datos del votante
        bytes32 hash_Votante = keccak256(abi.encodePacked(_IDVotante));
        
        // Verificamos si el votante ya ha votado previamente
        for (uint i = 0; i< votantes.length; i++){
            require (keccak256(abi.encodePacked(votantes[i])) != hash_Votante, "Ya has votado previamente.");
        }
        
        // Verificamos si el voto introducido es valido [comparamos strings]
        for (uint i = 0; i< candidatos.length; i++){
            require (keccak256(abi.encodePacked(candidatos[i])) == keccak256(abi.encodePacked(_candidato)), 
                "El candidato introducido no es valido.");
        }
      
        // Almacenamiento del hash de la identificacion del votante
        votantes.push(hash_Votante);
        
        // Añadimos un voto al candidato seleccionado 
        votos_Candidato[_candidato]++;
        
    }
    
    // Determina el ganador de la votacion
    function Ganador() public view returns (string memory){
        // Variable ganador
        string memory ganador;
        // Seleccion del candidato con mayor numero de votos
        for (uint i = 0; i< candidatos.length; i++){
            for (uint x = 0; i< candidatos.length; x++){
                if (votos_Candidato[candidatos[i]] > votos_Candidato[candidatos[x]] ){
                    ganador = candidatos[i];}
            }
            
        }
        
        // Devuelve el nombre del ganador
        return ganador;
    
    }
    
}



