pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./OperacionesBasicas.sol";
import "./ERC20.sol";

// Contrato para la Compañia de Seguros
contract InsuranceFactory is OperacionesBasicas{
    
    // Constructor de Insurance Factory
    constructor () public{
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = msg.sender;
        }
        
     /* Una de las estructuras de datos para IF son los clientes donde se guarda su direccion, y
     la autorizacion de este por su policía. Por otra parte, los servicios de los que
     se guarda el nombre de este servicio, el precio en tokens y el estado del servicio. También disponemos de una estructura
     de datos del laboratorio donde se guarda toda la información necesaria de este laboratorio como puede ser
     su direccion y el booleano de si es válido o no lo es. */
        
        //Estructura del cliente
        struct cliente {
            address DireccionCliente;
            bool AutorizacionCliente;
            address DireccionContrato;
        }
        
        //Estructura del servicio
        struct servicio{
            string nombreServicio;
            uint precioTokensServicio;
            bool EstadoServicio;
        }
        
         //Estructura del laboratorio
        struct lab {
            address direccionContratoLab;
            bool ValidacionLab;
        }
        
        // Instancia del contrato token
        ERC20Basic private token;
        
        // Declaraciones de las direcciones
        address Insurance;
        address payable public Aseguradora;
        
        // Array para guardas les direcciones de los asegurados
        address [] DireccionesAsegurados;
        
        //Mapping para relacionar una direccion y una estructura de un cliente
        mapping (address => cliente) public MappingAsegurados;
        
        //Mapping para relacionar un string y un servicio
        mapping (string => servicio) public MappingServicios;
        
        //Array para guardar los nombres de los servicios 
        string [] private nombreServicios;
        
         // Array para guardar las direcciones de los laboratorios 
        address [] DireccionesLaboratorios;
        
        // Modificadores que permiten unicamente realizar funciones a los asegurados
        modifier UnicamenteAsegurado(address _direccionAsegurado){
            // Se requiere que la direccion este autorizada previamente
            FuncionUnicamenteAsegurado(_direccionAsegurado);
            _;
        }
        
        // Funcion para ejecutar una PCR o una RX por un asegurado en un laboratorio
        function FuncionUnicamenteAsegurado(address _direccionAsegurado) public view{
            require (MappingAsegurados[_direccionAsegurado].AutorizacionCliente == true, "Direccion no autorizada");
        }
        
        // Restricciones para que unicamente se ejecuten funciones por la compañia de seguros
        modifier UnicamenteAseguradora(address _direccionAsseguradora){
            // Es requreix que l'adreça de l'asseguradora sigui l'unicada autoritzada
            require (Aseguradora == _direccionAsseguradora, "Adreça no autoritzada");
            _;
        }
        
        // Restricciones para que unicamente el asegurado o la compañia de seguros ejecute funciones
        modifier Asegurado_o_Aseguradora(address _direccionAsegurado, address _direccionEntrante){
            require ((MappingAsegurados[_direccionEntrante].AutorizacionCliente == true 
                && _direccionAsegurado == _direccionEntrante) || Aseguradora == _direccionEntrante, 
                    "Unicamente compañia de seguros y asegurados");
            _;
        }
        
        // Eventos
        event EventoComprado (uint256);
        event EventoServicioProporcionado (address, string, uint256);
        event LaboratorioCreado (address, address);
        event AseguradoCreado (address, address);
        event EventoBajaCliente(address);
        event EventoNuevoServicio(string, uint256);
        event EventoBajaServicio(string);
        
        // Mapping para relacionar direcciones con laboratorios
        mapping (address => lab) public MappingLab;
        
        /*Funcion para llevar a cabo la creación de un contrato por un laboratorio.
        Esta función la podrá ejecutar cualquier persona */
        function creacionLab() public {
            // Se guarda la direccion del laboratorio en un array
            DireccionesLaboratorios.push(msg.sender);
            // Se crea un contrato para un laboratorio 
            address direccionLab = address(new Laboratorio(msg.sender, Insurance));
            /* Creación de la estructura del Laboratorio:
                 Asignación de la dirección del contrato del laboratorio a la estructura del laboratorio respectivo.
                 Asignación de la validacion positiva como laboratorio. */
            lab memory Laboratorio = lab(direccionLab, true);
            // Se guarda la esctructura de datos del laboratorio
            MappingLab[msg.sender] = Laboratorio;
            // Evento de la creacion del laboratorio
            emit LaboratorioCreado(msg.sender, direccionLab);
         }
        
         /* Funcion para llevar a cabo la creación de un contrato por un asegurado.
         Esta función la podrá ejecutar cualquier dirección. */
        function creacionContratoAsegurado() public {
            // Guarda la direccion del asegurado en un array
            DireccionesAsegurados.push(msg.sender);
            // Generacion de un contrato para el asegurado
            address direccionAsegurado = address(new InsuranceHealthRecord(msg.sender, token, Insurance, Aseguradora));
             // Almacenamiento de la informacion del aseguradora (cliente) en una estructura de datos
             MappingAsegurados[msg.sender] = cliente(msg.sender,true,direccionAsegurado);
             // Evento para informar del nuevo asegurado
             emit AseguradoCreado(msg.sender,direccionAsegurado);
        }
        
        // Función que devuelve el array de las direcciones de los laboratorios
        function Laboratorios() public view UnicamenteAseguradora(msg.sender) returns(address [] memory){
        return DireccionesLaboratorios;
        }
        
        // Función que devuelve el array de las direcciones de los Asegurados
        function Asegurados() public view UnicamenteAseguradora(msg.sender) returns(address [] memory){
        return DireccionesAsegurados;
        }
        
        // Función para ver el historial de un asegurado
        function consultarHistorialAsegurado(address _direccionAsegurado, address _direccionConsultor) public view Asegurado_o_Aseguradora(_direccionAsegurado, _direccionConsultor) returns(string memory){
            string memory historial = "";
            address direccionContratoAsegurado = MappingAsegurados[_direccionAsegurado].DireccionContrato;
            for(uint i = 0; i < nombreServicios.length; i++){
                if(MappingServicios[nombreServicios[i]].EstadoServicio && InsuranceHealthRecord(direccionContratoAsegurado).ServicioEstadoAsegurado(nombreServicios[i]) == true){
                    (string memory nombreServicio,uint precioServicio) = InsuranceHealthRecord(direccionContratoAsegurado).HistorialAsegurado(nombreServicios[i]);            
                    historial = string(abi.encodePacked(historial, "(", nombreServicio, ", ", uint2str(precioServicio), ") ------"));
                }
            }
            return historial;
        }        
        
        // Dar de baja a un asegurado
        function darBajaCliente(address _direccionAsegurado) public UnicamenteAseguradora(msg.sender) returns (string memory){
            // La autorizacion del aseguradora se anula
            MappingAsegurados[_direccionAsegurado].AutorizacionCliente = false;
            // Es crida al metode selfdestruct del client i es dona de baixa el client relacionat a l'adreça entrada per parametre
            InsuranceHealthRecord(MappingAsegurados[_direccionAsegurado].DireccionContrato).darBaja;
            // Emision del evento
            emit EventoBajaCliente(_direccionAsegurado);
        }
            
        // Funció  per a la creació d'un nou servei de l'asseguradora
        function nouServei(string memory _nombreServicio, uint256 _precioServicio) public UnicamenteAseguradora(msg.sender){
            // Relacion con el nombre del nuevo servicio y la estructura definida del servicio (nombre, precio y estado)
            MappingServicios[_nombreServicio] = servicio(_nombreServicio,_precioServicio,true);
            // Se guarda el nombre del servicio en el array
            nombreServicios.push(_nombreServicio);
            // Evento de un nuevo servicio
            emit EventoNuevoServicio(_nombreServicio,_precioServicio);
        }
        
        // L'asseguradora dona de baixa un servei donat d'alta anteriorment
        function darBajaServicio(string memory _nombreServicio) public UnicamenteAseguradora(msg.sender){
            // El servicio debe haberse dado de alta antes para darlo de baja
            require(ServicioEstado(_nombreServicio) == true, "No se ha dado de alta el servicio.");
            // El estado del servicio pasa a estar de baja
            MappingServicios[_nombreServicio].EstadoServicio = false; 
            // Evento para emitir la baja del servicio
            emit EventoBajaServicio(_nombreServicio);
        }
        
        // Funcion para obtener el precio de un servicio si éste se encuentra activo
        function getPrecioServicio(string memory _nombreServicio) public view returns (uint256 tokens){
            // Se requiere que el servicio que pedimos esté dado de alta
            require(MappingServicios[_nombreServicio].EstadoServicio == true, "Servicio no disponible");
            // Devuelve el precio del servicio con la ayuda del mapping que relacionan el nombre con su estructura de datos
            return MappingServicios[_nombreServicio].precioTokensServicio;
        }
        
        // Función para devolver el estado del servicio (puede ser: true o false)
        function ServicioEstado(string memory _nombreServicio) public view returns (bool){
            return MappingServicios[_nombreServicio].EstadoServicio;
        }
        
        
        // Función para devolver todos los servicios activos de la aseguradora
        function ConsultarServiciosActivos() public view returns (string [] memory) {
        // Array para almacenar los servicios activos de la aseguradora
        string [] memory ServiciosActivos =  new string[](nombreServicios.length);
        uint contador = 0;
        // Procedimiento para ver qué servicios se encuentran activos del array de 'nombreServicios'
            for (uint i = 0; i< nombreServicios.length; i++){
                // Si el servicio está activo (true) se guarda dentro del nuevo array 'ServiciosActivos'
                if(ServicioEstado(nombreServicios[i]) == true){
                    ServiciosActivos[contador] = nombreServicios[i]; 
                    contador++;
                }
            }
            return ServiciosActivos;
        }
    
        
        // Función para la compra de Tokens mediante ether a través de la implementación del contrato del token
        function compraTokens(address _asegurado, uint _numTokens) public payable UnicamenteAsegurado(_asegurado) {
            // Se obtiene el número de tokens de lo dispuesto en el contrato
            uint256 Balance = balanceOf();
            
            /* Una vez tenemos el número de tokens de lo dispuesto, debemos establecer las condiciones adecuadas:
             1. El número de tokens que se quieren comprar debe ser menor o igual al número de tokens disponibles
             para ser comprados.
             2. El número de tokens a comprar debe ser positivo */
             
            require(_numTokens <= Balance, "Compra un numero de tokens adecuado");
            require(_numTokens > 0, "Compra un numero positivo de tokens");
            // El número de tokens se transfiere al asegurado que las ha comprado
            token.transfer(msg.sender, _numTokens);
            // Evento para emitir que se han comprado los número de tokens
            emit EventoComprado(_numTokens);
        }
        
        // La compañia puede incrementar el numero de tokens
        function generarTokens(uint _numTokens) public UnicamenteAseguradora(msg.sender) {
            token.increaseTotalSuply(_numTokens);
        }
        
        // Balance de tokens del contrato de la aseguradora
        function balanceOf() public view returns(uint256 tokens){
            return (token.balanceOf(address(this)));
        }
        
}
    
/* Contrato desplegado por el asegurado que le permite hacer toda la gestión requerida */
contract InsuranceHealthRecord is OperacionesBasicas{
    
    // Constructor del IHR 
    constructor (address _owner , IERC20 _token, address _insurance , address payable _aseguradora) public{
        propietario.direccionPropietario = _owner;
        propietario.saldoPropietario = 0;
        propietario.estado = Estado.alta;
        propietario.tokens = _token;
        propietario.insurance = _insurance;
        propietario.aseguradora = _aseguradora;
    }
    
    // Events requerits per informar de l'execució de certes funcions 
    event servicioPagado (address, string, uint256);
    event EventoDevolverTokens(address, uint256);
    event EventoPeticionServicioLab(address, address,string);
    event EventoSelfDestruct(address);
    
    // Estado
    enum Estado {alta,baja}
    
    // Estructura de los servicios solicitados
    struct ServiciosSolicitados{
        string nombreServicio;
        uint256 precioServicio;
        bool estadoServicio;
    }
    
    // Estructura de los servicios solicitados del laboratorio (PCR o RX)
    struct ServicioSolicitadoLab{
        string nombreServicio;
        uint256 precioServicio;
        address direccionLab;
    }
    
    // Mapping para guardar el historial del asegurado
    mapping (string => ServiciosSolicitados) historialAsegurado;
    
    //Mapping guardar l'historial de l'assegurat amb els laboratori
    ServicioSolicitadoLab [] historialAseguradoLaboratorio;
    
    // Estructura del propietari
    struct Owner{
        address direccionPropietario;
        uint saldoPropietario;
        Estado estado;
        IERC20 tokens;
        address insurance;
        address payable aseguradora;
    }
    
    // Modifier para controlar que únicamente el propietario de la póliza
    modifier Unicamente(address _direccion){
        require (_direccion == propietario.direccionPropietario, "No eres un asegurado.");
        _;
    }
    
    // Estructura para almacenar información del propietario de la póliza
    Owner propietario;
    // Estructura para almacenar información de los servicios solicitados
    ServiciosSolicitados servicios;
       
    // El asegurado compra tokens
    function CompraTokens (uint _numTokens) payable public Unicamente(msg.sender){
        // Se requiere que el numero de tokens comprados sea positivo
        require (_numTokens > 0, "Necesitas comprar un numero de tokens positivo.");
        // Transferencia de los tokens
        uint coste = calcularPrecioTokens(_numTokens);
        require(msg.value >= coste, "Compra menos tokens o pon más ethers.");
        uint returnValue = msg.value - coste;
        msg.sender.transfer(returnValue);
        // Se llama a la función de compra de tokens del contrato IF
        InsuranceFactory(propietario.insurance).compraTokens(msg.sender, _numTokens);
    }
    
    // La función 'balance Of' devuelve el saldo del propietario, únicamente la puede ejecutar la cuenta del msg.sender
    function balanceOf() public view Unicamente(msg.sender) returns (uint256 _balance) {
        return (propietario.tokens.balanceOf(address(this)));
    }

    // Devuelve tokens i recupera ethers
    function devolverTokens(uint _numTokens) public payable Unicamente(msg.sender){
        // El nombre de tokens a retornar ha de ser positiu
        require (_numTokens > 0, "Necesitas devolver un número positivo de tokens.");
        // El usuario debe tener el número de tokens que desea devolver
        require(_numTokens <= balanceOf(), "No tienes los tokens que desea devolver");
        // El propietario devuelve los tokens
        propietario.tokens.transfer(propietario.aseguradora, _numTokens);
        // Devolucion al asegurado
        msg.sender.transfer(calcularPrecioTokens(_numTokens)); 
        // Evento que informa del retorno de tokens del msg.sender
        emit EventoDevolverTokens(msg.sender, _numTokens);
    }
    
    // Funció per fer la petició d'un servei a l'aseguradora  
     function peticionServicio(string memory _servicio) public Unicamente(msg.sender){
        //Es comprova que el servei estigui donat d'alta
        require(InsuranceFactory(propietario.insurance).ServicioEstado(_servicio) == true, "El servicio no se ha dado de alta.");
        // S'obté el preu del servei a partir de l'altre contracte IF
        uint256 pagamientoTokens = InsuranceFactory(propietario.insurance).getPrecioServicio(_servicio);
        // Es necessari que el preu del servei sigui menor al nombre de tokens del que es disposa
        require(pagamientoTokens <= balanceOf(), "Necesitas comprar más tokens para obtener este servicio");
        // S'envien els tokens que val el servei a l'asseguradora (persona)
        propietario.tokens.transfer(propietario.aseguradora, pagamientoTokens);
        // Relacio amb el nom del nou servei i l'estructura definida dels serveis solicitats
        historialAsegurado[_servicio] = ServiciosSolicitados(_servicio,pagamientoTokens,true);
        // Event per emtre que el servei s'ha pagat 
        emit servicioPagado (msg.sender, _servicio, pagamientoTokens);
    }
    

    /* El usuario hace la petición de un servicio a un laboratorio indicado a través de su dirección (pasada por parámetro) y el nombre
     del servicio que pide. Únicamente podrá ejecutar esta función el asegurado propietario de este contrato. */
    function peticionServicioLab(address _direccionLab, string memory _servicio) public payable Unicamente(msg.sender){
        // Instancia del contrato del Laboratorio que tiene por dirección 'dirección Lab'
        Laboratorio contratoLab = Laboratorio(_direccionLab);
        // Es necesario hacer un require para diferenciar los ethers y los tokens del asegurado
        require(msg.value == contratoLab.consultarPrecioServicios(_servicio) * 1 ether, "Operación no válida.");
        // Se da el servicio al asegurado
        contratoLab.darServicio(msg.sender, _servicio);
        // Se paga el servicio al Laboratorio (cuenta, no contrato)
        payable(contratoLab.DireccionLab()).transfer(contratoLab.consultarPrecioServicios(_servicio) * 1 ether);
        // Se actualiza el historial de operaciones con Laboratorios del asegurado
        ServicioSolicitadoLab memory nuevoServicio = ServicioSolicitadoLab(_servicio, contratoLab.consultarPrecioServicios(_servicio), _direccionLab);
        historialAseguradoLaboratorio.push(nuevoServicio);
        // Evento que informa de la peticion del servicio
        emit EventoPeticionServicioLab(_direccionLab,msg.sender,_servicio);
    }
    
    // Función para ver el historial de los servicios de la aseguradora que ha consumido el asegurado
    function HistorialAseguradora() public view Unicamente(msg.sender) returns(string memory) {
        return InsuranceFactory(propietario.insurance).consultarHistorialAsegurado(msg.sender, msg.sender);
    }
    
    // Función para ver el historial del asegurado dado el nombre de un servicio por parametro (Función de ayuda para IF)
    function HistorialAsegurado(string memory _servicio) public view returns (string memory nombreServicio,uint precioServicio){
        return (historialAsegurado[_servicio].nombreServicio, historialAsegurado[_servicio].precioServicio);
    }
    
    // Función para ver el historial del asegurado dado el nombre de un servicio para parametro
    function HistorialAseguradoLaboratorio() public view returns (ServicioSolicitadoLab[] memory){
        return historialAseguradoLaboratorio;
    }
    
    // Función para devolver el estado del servicio (puede ser: true o false)
        function ServicioEstadoAsegurado(string memory _nombreServicio) public view returns (bool){
            return historialAsegurado[_nombreServicio].estadoServicio;
        }

    // El usuario se da de baja y utiliza 'self Destruct' para destruir su contrato
    function darBaja() public Unicamente(msg.sender){
        // Evento de la baja del cliente
        emit EventoSelfDestruct(msg.sender);
        // Destruccion del contrato del usuario
        selfdestruct(msg.sender); 
    }
    
}
        
// Contracte del laboratori que proveeix els serveis de PCR i RX
contract Laboratorio is OperacionesBasicas {
    
    //Adreça de la direccio que executa el contracte Laboratori    
    address public DireccioLab;
    address contracteAsseguradora;
    
    // Constructor del laboratori
    constructor (address _account, address direccioContracteAsseguradora) public {
        DireccioLab = _account;
        contracteAsseguradora = direccioContracteAsseguradora;
    }
    
    // Estrucura del servei oferit pel laboratori 
    struct ServeiLab{
        string nomServei;
        uint preu;
        bool enFuncionament;
    }

    // Array dels serveis que el laboratori ha posat en marxa (la variable enFuncionament == true)
    string [] nomServeisLab;
    // Mapping que relaciona el nom del servei amb l'estructura del servei
    mapping (string => ServeiLab) public serveisLab;
    
    // Events 
    event serveiFuncionant (string,uint);
    event EventDonarServei(address,string);
    
    // Modificador per que tan sols els laboratoris puguin executar certes funcions
    modifier UnicamentLab(address _account){
        require (_account == DireccioLab, "No es té  permís per aquesta funció.");
        _;
    } 
    
    // S'implementa un nou servei que a partir de l'array de serveis fixes es reconeix s'hi esta implementat i es dona preu al servei
   function nouServeiOferit(string memory _servei, uint _preu) public UnicamentLab(msg.sender){
    // Per comparar dos strings s'ha emprat un tractament especial
    require(keccak256(abi.encodePacked("PCR")) == keccak256(abi.encodePacked(_servei)) || keccak256(abi.encodePacked("RX")) == keccak256(abi.encodePacked(_servei)), "El servei no s'ha implementat");
    // Es guarda la relacio amb el nom del servei i la seva estructura
    serveisLab[_servei] = ServeiLab(_servei, _preu, true);
    // Es guarda a l'array de serveis en funcionament 
    nomServeisLab.push(_servei);
    // Event del servei 
    emit serveiFuncionant(_servei,_preu);
    }
    
    // Es retorna el conjunt de serveis que es troben en funcionament al laboratori
    function consultarServicios() public view returns (string [] memory){
        return nomServeisLab;
    }
    
    // Es retorna el preu del servei donat el seu nom
    function consultarPrecioServicios(string memory _nomServei) public view returns (uint){
        require(serveisLab["PCR"].enFuncionament == true, "El servei no està en funcionament.");
        return serveisLab[_nomServei].preu;
    }

    // Mapping que relaciona una adreça amb els resultats de la seva PCR o RX. 
    //I a més, permetrà veure els resultats de les proves que s'ha fet un usuari donada la seva adreça
    mapping (address => string []) public resultatsServeis;
    
    //Funció  per donar servei: donat una compte d'un assegurat i un nom d'un servei s'executarà el servei
    function darServicio(address _compteAssegurat, string memory _nomServei) public {
        // Es requereix que la persona que executa la funcio sigui un assegurat de l'asseguradora
        InsuranceFactory IF = InsuranceFactory(contracteAsseguradora);
        IF.FuncionUnicamenteAsegurado(_compteAssegurat);
        //S'igualen dos strings mitjançant 'abi.encodePacked'
        if(keccak256(abi.encodePacked(_nomServei)) == keccak256(abi.encodePacked("PCR"))){
            PCR(_compteAssegurat);
        }else if(keccak256(abi.encodePacked(_nomServei)) == keccak256(abi.encodePacked("RX"))){
            RX(_compteAssegurat);
        }
        // Event del servei donat per l'assegurat respectiu
        emit EventDonarServei(_compteAssegurat,_nomServei);
    }
    
    // Funció  per executar el servei de PCR
    function PCR(address _compteAssegurat) private returns (string memory) {
        // Es requreix que el servei s'hagi donat d'alta pel laboratori 
        require(serveisLab["PCR"].enFuncionament == true, "El servei no està en funcionament.");
        // Codi de la prova de la IPFS
        string memory resultatPcr = "QmWzuN3uqxU5CRy3ts9QMubHShFqkw6Ba7F9Sw5Pp8NwVP";
        // Relacio del resultat de la PCR amb l'adreça que s'ha fet la PCR
        resultatsServeis[_compteAssegurat].push(resultatPcr);
        // Retorna el codi respectiu al resultat per aquella adreça
        return resultatPcr;
    }
    
    // Funció per executar una radiografia (RX)
      function RX(address _compteAssegurat) private returns (string memory) {
        // Es requreix que el servei s'hagi donat d'alta pel laboratori 
        require(serveisLab["RX"].enFuncionament == true, "El servei no està en funcionament.");
        // Codi de la prova de la IPFS
        string memory resultatrx = "QmRUPWYZDzaU9RPQrEtLXVwDCFup9LK41TaiunsitAfoXX";
        // Relacio del resultat de la PCR amb l'adreça que s'ha fet la PCR
        resultatsServeis[_compteAssegurat].push(resultatrx);
        // Retorna el codi respectiu al resultat per aquella adreça
        return resultatrx;
    }
}
