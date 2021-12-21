// SPDX-License-Identifier: MIT
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
            require (MappingAsegurados[_direccionAsegurado].AutorizacionCliente == true, "Direccion no autorizada.");
        }
        
        // Restricciones para que unicamente se ejecuten funciones por la compañia de seguros
        modifier UnicamenteAseguradora(address _direccionAsseguradora){
            // Es requreix que l'adreça de l'asseguradora sigui l'unicada autoritzada
            require (Aseguradora == _direccionAsseguradora, "Direccion no autorizada.");
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
        
        // Funcion que devuelve el array de las direcciones de los laboratorios
        function Laboratorios() public view UnicamenteAseguradora(msg.sender) returns(address [] memory){
        return DireccionesLaboratorios;
        }
        
        // Funcion que devuelve el array de las direcciones de los Asegurados
        function Asegurados() public view UnicamenteAseguradora(msg.sender) returns(address [] memory){
        return DireccionesAsegurados;
        }
        
        // Funcion para ver el historial de un asegurado
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
            // Se llama al metodo self destruct del cliente y se da de baja el cliente relacionado a la dirección entrada para parametro
            InsuranceHealthRecord(MappingAsegurados[_direccionAsegurado].DireccionContrato).darBaja;
            // Emision del evento
            emit EventoBajaCliente(_direccionAsegurado);
        }
            
        // Funcion para la creación de un nuevo servicio de la aseguradora
        function nuevoServicio(string memory _nombreServicio, uint256 _precioServicio) public UnicamenteAseguradora(msg.sender){
            // Relacion con el nombre del nuevo servicio y la estructura definida del servicio (nombre, precio y estado)
            MappingServicios[_nombreServicio] = servicio(_nombreServicio,_precioServicio,true);
            // Se guarda el nombre del servicio en el array
            nombreServicios.push(_nombreServicio);
            // Evento de un nuevo servicio
            emit EventoNuevoServicio(_nombreServicio,_precioServicio);
        }
        
        // La aseguradora dar de baja un servicio dado de alta anteriormente
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
        
        // Funcion para devolver el estado del servicio (puede ser: true o false)
        function ServicioEstado(string memory _nombreServicio) public view returns (bool){
            return MappingServicios[_nombreServicio].EstadoServicio;
        }
        
        
        // Funcion para devolver todos los servicios activos de la aseguradora
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
    
    // Eventos requeridos para informar de la ejecución de ciertas funciones
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
    
    // Mapping para guardar el historial del asegurado con los laboratorio
    ServicioSolicitadoLab [] historialAseguradoLaboratorio;
    
    // Estructura del propietario
    struct Owner{
        address direccionPropietario;
        uint saldoPropietario;
        Estado estado;
        IERC20 tokens;
        address insurance;
        address payable aseguradora;
    }
    
    // Modifier para controlar que unicamente el propietario de la póliza puede ejecutar ciertas funciones
    modifier Unicamente(address _direccion){
        require (_direccion == propietario.direccionPropietario, "No eres un asegurado.");
        _;
    }
    
    // Estructura para almacenar información del propietario de la póliza
    Owner propietario;
    // Estructura para almacenar información de los servicios solicitados
    ServiciosSolicitados servicios;
       
    // Funcion para que un asegurado compre tokens
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

    // Funcion para que un aseguradora devuelva tokens i recupere su valor en ethers
    function devolverTokens(uint _numTokens) public payable Unicamente(msg.sender){
        // El numero de tokens a devolver debe ser positivo 
        require (_numTokens > 0, "Necesitas devolver un numero positivo de tokens.");
        // El usuario debe tener el número de tokens que desea devolver
        require(_numTokens <= balanceOf(), "No tienes los tokens que desea devolver.");
        // El propietario devuelve los tokens
        propietario.tokens.transfer(propietario.aseguradora, _numTokens);
        // Devolucion al asegurado
        msg.sender.transfer(calcularPrecioTokens(_numTokens)); 
        // Evento que informa del retorno de tokens del msg.sender
        emit EventoDevolverTokens(msg.sender, _numTokens);
    }
    
    // Función para hacer la petición de un servicio a la aseguradora 
     function peticionServicio(string memory _servicio) public Unicamente(msg.sender){
        // Se comprueba que el servicio esté dado de alta
        require(InsuranceFactory(propietario.insurance).ServicioEstado(_servicio) == true, "El servicio no se ha dado de alta.");
        // Se obtiene el precio del servicio a partir del otro contrato IF
        uint256 pagamientoTokens = InsuranceFactory(propietario.insurance).getPrecioServicio(_servicio);
        // Es necesario que el precio del servicio sea menor al número de tokens de lo dispuesto
        require(pagamientoTokens <= balanceOf(), "Necesitas comprar más tokens para obtener este servicio");
        // Se envían los tokens que vale el servicio a la aseguradora (persona)
        propietario.tokens.transfer(propietario.aseguradora, pagamientoTokens);
        // Relacion con el nombre del nuevo servicio y la estructura definida de los servicios solicitados
        historialAsegurado[_servicio] = ServiciosSolicitados(_servicio,pagamientoTokens,true);
        // Evento para avisar de que el servicio se ha pagado
        emit servicioPagado (msg.sender, _servicio, pagamientoTokens);
    }
    

    /* El usuario hace la petición de un servicio a un laboratorio indicado a través de su dirección (pasada por parámetro) y el nombre
     del servicio que pide. Únicamente podrá ejecutar esta función el asegurado propietario de este contrato. */
    function peticionServicioLab(address _direccionLab, string memory _servicio) public payable Unicamente(msg.sender){
        // Instancia del contrato del Laboratorio que tiene por dirección 'dirección Lab'
        Laboratorio contratoLab = Laboratorio(_direccionLab);
        // Es necesario hacer un require para diferenciar los ethers y los tokens del asegurado
        require(msg.value == contratoLab.ConsultarPrecioServicios(_servicio) * 1 ether, "Operación no válida.");
        // Se da el servicio al asegurado
        contratoLab.DarServicio(msg.sender, _servicio);
        // Se paga el servicio al Laboratorio (cuenta, no contrato)
        payable(contratoLab.DireccionLab()).transfer(contratoLab.ConsultarPrecioServicios(_servicio) * 1 ether);
        // Se actualiza el historial de operaciones con Laboratorios del asegurado
        ServicioSolicitadoLab memory nuevoServicio = ServicioSolicitadoLab(_servicio, contratoLab.ConsultarPrecioServicios(_servicio), _direccionLab);
        historialAseguradoLaboratorio.push(nuevoServicio);
        // Evento que informa de la peticion del servicio
        emit EventoPeticionServicioLab(_direccionLab,msg.sender,_servicio);
    }
    
    // Funcion para ver el historial de los servicios de la aseguradora que ha consumido el asegurado
    function HistorialAseguradora() public view Unicamente(msg.sender) returns(string memory) {
        return InsuranceFactory(propietario.insurance).consultarHistorialAsegurado(msg.sender, msg.sender);
    }
    
    // Funcion para ver el historial del asegurado dado el nombre de un servicio por parametro (Función de ayuda para IF)
    function HistorialAsegurado(string memory _servicio) public view returns (string memory nombreServicio,uint precioServicio){
        return (historialAsegurado[_servicio].nombreServicio, historialAsegurado[_servicio].precioServicio);
    }
    
    // Funcion para ver el historial del asegurado dado el nombre de un servicio para parametro
    function HistorialAseguradoLaboratorio() public view returns (ServicioSolicitadoLab[] memory){
        return historialAseguradoLaboratorio;
    }
    
    // Funcion para devolver el estado del servicio (puede ser: true o false)
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
        
// Contrato del laboratorio que da los servicios de PCR y RX
contract Laboratorio is OperacionesBasicas {
    
    // Direcciones necesarias  
    address public DireccionLab;
    address contratoAseguradora;
    
    // Constructor del laboratorio
    constructor (address _account, address _direccionContratoAseguradora) public {
        DireccionLab = _account;
        contratoAseguradora = _direccionContratoAseguradora;
    }
    
    // Relacion entre el asegurado y el servicio que ha solicitado
    mapping (address => string) public ServicioSolicitado;
    
    // Direcciones de las personas que han solicitado un servicio
    address [] public PeticionesServicios;
    
    // Relacion entre el asegurado y sus resultados del Servicio 
    mapping (address => ResultadoServicio) ResultadosServiciosLab;
    
    // Estructura del resultado de un servicio
    struct ResultadoServicio {
        string diagnostico_servicio;
        string codigo_IPFS;
    }
    
    // Estrucura del servicio ofrecido por el laboratorio
    struct ServicioLab{
        string nombreServicio;
        uint precio;
        bool enFuncionamiento;
    }

    // Array de los servicios que estan en funcionamiento 
    string [] nombreServiciosLab;
    
    // Mapping que relaciona el nombre del servicio con la estructura de datos del servicio 
    mapping (string => ServicioLab) public serviciosLab;
    
    
    // Eventos 
    event Evento_ServicioFuncionando (string,uint);
    event Evento_DarServicio (address,string);
    
    // Restriccion para que unicamente el laboratorio pueda ejecutar ciertas funciones
    modifier UnicamenteLab(address _direccion){
        require (_direccion == DireccionLab, "No existen permisos para ejecutar esta funcion.");
        _;
    } 
    
    // Se devuelve el conjunto de servicios que se encuentran en funcionamiento en el laboratorio
    function ConsultarServicios() public view returns (string [] memory){
        return nombreServiciosLab;
    }
    
    // Se devuelve el precio del servicio dado su nombre
    function ConsultarPrecioServicios(string memory _nombreServicio) public view returns (uint){
        return serviciosLab[_nombreServicio].precio;
    }

    // Funcion para dar un nuevo servicio de alta
    function NuevoServicioLab(string memory _servicio, uint _precio) public UnicamenteLab(msg.sender){
        // Creacion de un nuevo servicio 
        serviciosLab[_servicio] = ServicioLab(_servicio, _precio, true);
        // Se guarda en el array de servicios en funcionamiento
        nombreServiciosLab.push(_servicio);
        // Evento del servicio
        emit Evento_ServicioFuncionando(_servicio,_precio);
    }
    
    // Funcion para dar un servicio a un asegurado 
    function DarServicio(address _direccionAsegurado, string memory _servicio) public {
        // Se requiere que la persona que ejecuta la función sea un asegurado de la aseguradora
        InsuranceFactory IF = InsuranceFactory(contratoAseguradora);
        IF.FuncionUnicamenteAsegurado(_direccionAsegurado);
        // Se require que el servicio este activo
        require(serviciosLab[_servicio].enFuncionamiento == true, "El servicio no esta activo");
        // Relacion entre la persona y el servicio solicitado 
        ServicioSolicitado[_direccionAsegurado] = _servicio;
        // Almacenamos las personas que piden un servicio
        PeticionesServicios.push(_direccionAsegurado);
        // Emision del servicio 
        emit Evento_DarServicio (_direccionAsegurado, _servicio);
    }
  
    // Funcion para que el laboratorio pueda asignar los resultados al asegurado
    function DarResultados(address _direccionAsegurado, string memory _diagnostico, string memory _codigoIPFS) public UnicamenteLab(msg.sender){
        // Uso del mapping que relaciona un asegurado con la estructura de resultados
        ResultadosServiciosLab[_direccionAsegurado] = ResultadoServicio (_diagnostico, _codigoIPFS);
    }
    
    // Funcion para visualizar los resultados del servio solicitado por el asegurado
    function VisualizarResultados(address _direccionAsegurado) public view returns (string memory _diagnostico, string memory _codigoIPFS) {
        // Diagnostico del servicio
        _diagnostico = ResultadosServiciosLab[_direccionAsegurado].diagnostico_servicio;
        // Codigo IPFS del serviciop
        _codigoIPFS = ResultadosServiciosLab[_direccionAsegurado].codigo_IPFS;
    }
    

}