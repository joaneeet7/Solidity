// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Joan   |    77755N    |      5
//  Alba   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Rafael |    13579U    |      3
//  Pilar  |    98765Z    |      5

contract notas {
    
    // Direcion del profesor 
    address profesor;
    
    // Constructor
    constructor () public{
        profesor = msg.sender;
    }
    
    // Mapping para relacionar el hash de la id del alumno con su nota
    mapping (bytes32 => uint) Notas;
    event alumno_evaluado(bytes32 _idAlumno);
    
    // Funcion para evaluar a los alumnos
    function evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender) {
        // Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Relacion del hash del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        // Emision del evento
        emit alumno_evaluado(hash_idAlumno);
    }
    
    // Funcion para ver las notas     
    function VerNotas(string memory _idAlumno) public view returns (uint256){
        // Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Nota del alumno
        return Notas[hash_idAlumno];
    }
    
    // Modifier para controlar las funciones que unicamente ejecuta el profesor
    modifier UnicamenteProfesor(address _direccion){
        // Requiere que la direccion introducida sea identica a la del profesor
        require (_direccion == profesor, "No tienes permisos para estas funciones.");
        _;
    }
    
    
}
