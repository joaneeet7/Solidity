// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Contracte_OMS{
    
    // Direccion de la OMS 
    address public OMS;
    // Relacion entre los centros de salud (su direccion) y su validez
    mapping (address => bool) Validacion_CentrosSalud;
    address [] public direcciones_contratos_salud;

    // Eventos
    event Nuevo_Contrato (address _contrato);
    event Nuevo_Centro_Validado (address _direccion);
    
    // Constructor
    constructor () public {
        OMS = msg.sender;
    }
    
    // La OMS da permisos a un centro de salud para crear un contrato propio
    function CentrosSalud (address _centroSalud) public UnicamenteOMS(msg.sender){
        // Se le da un estado de validez al centro de salud para crear su contrato
        Validacion_CentrosSalud[_centroSalud] = true;
        // Emision del evento de un nuevo centro de salud validado
        emit Nuevo_Centro_Validado(_centroSalud);
    }
    
    // El centro de salud crea un nuevo contrato para su propia gestion
    function Factory_CentroSalud () public {
        // Es necesario que previamente el centro este validado por la OMS
        require (Validacion_CentrosSalud[msg.sender] == true, "La OMS no te ha dado validez.");
        // Creacion del contrato para el centro de salud
        address contrato_CentroSalud = address (new CentroSalud(msg.sender));
        // Direccion del contrato guardada en un array
        direcciones_contratos_salud.push(contrato_CentroSalud);
        // Emission del evento del nuevo contrato con su direccion
        emit Nuevo_Contrato(contrato_CentroSalud);
    }
    
    // Restricciones para que unicamente la OMS ejecuta ciertas funciones
    modifier UnicamenteOMS(address _direccion) {
        require (_direccion == OMS, "No tienes permisos para ejecutar esta funcion.");
        _;
    }
    
}

// Contrato del centro de salud
contract CentroSalud{
   
   // Mapping que relaciona una identificacion con un resultado de una PCR
   mapping (bytes32 => bool) Resultado_PCR;
   
   // Direcciones del centro de salud y de su contrato
   address public Direccion_CentroSalud;
   address public Direccion_Contrato;
   
   // Eventos
   event Nuevo_Resultado(string, bool);
   
   // Constructor
   constructor (address _account) public {
       Direccion_CentroSalud = msg.sender;
       Direccion_Contrato = _account;
   }
   
   // Funcion para guardar el resultado de una PCR
   function Resultats_PCR (string memory _idPersona, bool _resultadoPCR) public UnicamenteCentroSalud(msg.sender){
       // Hash de la identificacion de la persona
       bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));
       // Para una identificacion de una persona se asigna un resultado de PCR
       Resultado_PCR[hash_idPersona] = _resultadoPCR;
       // Emision del evento 
       emit Nuevo_Resultado(_idPersona, _resultadoPCR);
   }
   
   // Funcion para ver el resultado de una PCR (ejecutable por cualquier persona)
   function PCR (string memory _idPersona) public view returns (string memory) {
       // Hash de la identificacion de la persona
       bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));
       // Variable auxiliar del resultat de la PCR
       string memory resultadoPCR;
       
       // Devuelve el resultado de la PCR [positivo o negativo]
       if (Resultado_PCR[hash_idPersona] == true){
           resultadoPCR = "Positivo";
       } else{
            resultadoPCR = "Negativo";
       }
       
       // Devuelve el valor del resultado de la PCR
       return resultadoPCR;
   }
    
    // Restriccion para la ejecucion de funciones solo por el centro de salud
    modifier UnicamenteCentroSalud(address _direccion){
        require (_direccion == Direccion_CentroSalud, "No tienes permisos para ejecutar esta funcion.");
        _;
    }
}

