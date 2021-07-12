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
    function compraTokens(uint _numTokens) public payable {
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
    function generaTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSuply(_numTokens); 
    }
    
    // Balance de tokens de un cliente
     function mis_tokens() public view returns(uint256 tokens){
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
    
    
    // Evento para disfrutar de la atraccion
    event disfruta_atraccion (string _atraccion);
    
    //Mapping para relacionar un nombre de una atraccion y la struct de la atraccion
    mapping (string => atraccion) public MappingAtracciones;
    
    //Estructura de la atraccion
    struct atraccion{
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
        }
    
    // Función para crear nuevas atracciones (solo ejecutable por Disney)
    function nuevaAtraccion(string memory _nombre, uint256 _precio) public Unicamente (msg.sender){
        MappingAtracciones[_nombre] = atraccion(_nombre,_precio,true);
    }
    
    // Atraccion de Nemo
    function Nemo() public returns(string memory) {
        // Precio de la atraccion (en tokens)
        uint tokens_atraccion = MappingAtracciones["Nemo"].precio_atraccion;
        
        // Se verifica que la atraccion esta disponible
        require(MappingAtracciones["Nemo"].estado_atraccion == true, 
                "La atraccion no esta disponible en estos momentos.");
        
        // Se verifica que el cliente tenga el numero de tokens necesario
        require(tokens_atraccion <= mis_tokens(), 
                "Necesitas mas Tokens para subirte a esta atraccion.");
        
        /* El cliente paga la atraccion con Tokens:
         
         - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_disney',
         debido a que en caso de usar el Transfer o el TransferFrom las direcciones que se escogian
         para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibia el metodo Transfer
         de ERC20.sol era la direccion del contrato y no del clientr*/
        
        token.transferencia_disney(msg.sender,address(this),tokens_atraccion);
        
        // Emision de un evento 
        emit disfruta_atraccion("Disfruta de Nemo");
    }
    
    // Funcion para que un cliente de Disney pueda devolver tokens si lo desea
    function devolverTokens(uint _numTokens) public payable {
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