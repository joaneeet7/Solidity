// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney{
    
    // Instancia del contrato token
    ERC20Basic private token;
    
    // Constructor
    constructor () public{
        token = new ERC20Basic(10000);
        owner = msg.sender;
    }
    
    // Direccion de Disney
    address payable public owner;
    
    // Mapping para el registro de Clientes
    mapping (address => cliente) public Clientes;
    
    // Estructura para el cliente 
    struct cliente{
        uint tokens_comprados;
        string [] atracciones_disfrutadas;
    }
    
    // Establecer el precio de cada token (relacion con ethers)
    function PrecioTokens(uint _numTokens) internal pure returns (uint){
        return _numTokens * (1 ether);
    }
    
    // Comprar Tokens para poder disfrutar de Disney
    function CompraTokens(uint _numTokens) public payable {
        // Transfarencia de los tokens
        uint coste = PrecioTokens(_numTokens);
        // Se requiere que el valor introducido sea mayor al coste
        require(msg.value >= coste, "Compra menos tokens o paga con más ethers.");
        // Diferencia a pagar
        uint returnValue = msg.value - coste;
        // Transferencia de la diferencia de tokens
        msg.sender.transfer(returnValue);
        // Se obtiene el balance de tokens del contrato
        uint256 Balance = balanceOf();
        require(_numTokens <= Balance, "Compra un numero de tokens adecuado");
        // El nombre de tokens es transfareix a l'assegurat que les ha comprat
        token.transfer(msg.sender, _numTokens);
        // Registro de tokens comprados
        Clientes[msg.sender].tokens_comprados = _numTokens;
    }
    
    // Generacion de tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSuply(_numTokens); 
    }
    
    // Balance de tokens de un cliente
     function MisTokens() public view returns(uint256 tokens){
        return token.balanceOf(msg.sender);
    }
    
    // Balance de tokens del contrato de Disney
    function balanceOf() public view returns (uint256 tokens){
        return token.balanceOf(address(this));
    }
    
    // Modifier para controlar las funciones que unicamente ejecuta Disney
    modifier Unicamente(address _direccio){
        require (_direccio == owner, "No tienes permisos para estas funciones.");
        _;
    }
    
    // ------------------------------------------------------------------------------------------------ //
    
    // Eventos
    event disfruta_atraccion (string);
    event nueva_atraccion(string);
    event baja_atraccion(string);
        
    //Mapping para relacionar un nombre de una atraccion y la struct de la atraccion
    mapping (string => atraccion) public MappingAtracciones;
    
    // Mapping para relacion una identidad con el historial de atracciones a las que ha subido
    mapping (address => string []) HistorialAtracciones;
    
    // Array para almacenar las atracciones 
    string [] Atracciones;
    
    //Estructura de la atraccion
    struct atraccion{
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
        }
    
    // Crear nuevas atracciones para DISNEY (solo ejecutable por Disney)
    function NuevaAtraccion(string memory _nombreAtraccion, uint256 _precio) public Unicamente (msg.sender){
        // Creacion de un atraccion nueva en Disney
        MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion,_precio,true);
        // Almacenamiento en una lista de su nombre
        Atracciones.push(_nombreAtraccion);
        // Emision del evento para un nueva atraccion
        emit nueva_atraccion(_nombreAtraccion);
    }
    
    // Dar de baja atracciones de DISNEY
    function BajaAtraccion(string memory _nombreAtraccion) public Unicamente(msg.sender){
        // El estado de la atraccion pasa a ser falso => NO ESTA DISPONIBLE 
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;
        // Emision del evento de dar de baja a una atraccion
        emit baja_atraccion(_nombreAtraccion);
    }
    
    // Visualiza las atracciones de Disney
    function AtraccionesDisponibles() public view returns (string [] memory){
        return Atracciones;
    }
    
    // Funcion para subirse a una atraccion de DISNEY y pagar su valor con tokens
    function SubirseAtraccion(string memory _nombreAtraccion) public {
        // Precio de la atraccion (en tokens)
        uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;
        // Se verifica que la atraccion esta disponible
        require(MappingAtracciones[_nombreAtraccion].estado_atraccion == true, 
                "La atraccion no esta disponible en estos momentos.");
        // Se verifica que el cliente tenga el numero de tokens necesario
        require(tokens_atraccion <= MisTokens(), 
                "Necesitas mas Tokens para subirte a esta atraccion.");
        /* El cliente paga la atraccion con Tokens:
         - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_disney',
         debido a que en caso de usar el Transfer o el TransferFrom las direcciones que se escogian
         para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibia el metodo Transfer
         de ERC20.sol era la direccion del contrato y no del cliente*/
        token.transferencia_disney(msg.sender,address(this),tokens_atraccion);
        // Almacenamiento en el historial de atracciones disfrutadas
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);
        // Emision del evento para disfrutar de la atraccion
        emit disfruta_atraccion(_nombreAtraccion);
    }
    
    // Visualiza el historial completo de atracciones disfrutadas del cliente
    function Historial() public view returns (string [] memory){
        return HistorialAtracciones[msg.sender];
    }
    
    // Funcion para que un cliente de Disney pueda devolver un numero de tokens si lo desea
    function DevolverTokens(uint _numTokens) public payable {
        // El numero de tokens a devolver debe ser positivo 
        require (_numTokens > 0, "Necesitas devolver un numero positivo de tokens.");
        // El usuario debe tener el número de tokens que desea devolver
        require(_numTokens <= balanceOf(), "No tienes los tokens que desea devolver.");
         // El cliente devuelve los tokens
        token.transferencia_disney(msg.sender,address(this), _numTokens);
        // Devolucion de los ethers al cliente
        msg.sender.transfer(PrecioTokens(_numTokens)); 
    }
    
}