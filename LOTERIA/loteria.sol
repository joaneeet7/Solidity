// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract loteria{
    
    // Instancia del contrato token
    ERC20Basic private token;
    
    // Direcciones
    address public owner;
    address public contrato;
    uint public tokens_creados = 10000;
    
    // Constructor
    constructor () public {
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }
        
    // -----------------------------------------------------------------------------------------------------------
    // --------------------------------------------- TOKENS ------------------------------------------------------
    // -----------------------------------------------------------------------------------------------------------
    
    // Establecer el precio de cada token (relacion con ethers)
    function PrecioTokens(uint _numTokens) internal pure returns (uint){
        return _numTokens * (1 ether);
    }
    
    // Generacion de tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSuply(_numTokens); 
    }
       
    // Comprar Tokens para poder comprar tickes para la loteria
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
        uint256 Balance = TokensDisponibles();
        require(_numTokens <= Balance, "Compra un numero de tokens adecuado");
        // El nombre de tokens es transfareix a l'assegurat que les ha comprat
        token.transfer(msg.sender, _numTokens);
    }
    
    // Balance de tokens del contrato de la loteria
    function TokensDisponibles() public view returns (uint256 tokens){
        return token.balanceOf(address(this));
    }
    
      // Balance de tokens del contrato de la loteria
    function Bote() public view returns (uint256 tokens){
        return token.balanceOf(owner);
    }
    
    // Balance de tokens de un cliente
     function MisTokens() public view returns(uint256 tokens){
        return token.balanceOf(msg.sender);
    }
    
    // ---------------------------------------------------------------------------------------------------------
    // --------------------------------------------- LOTERIA ---------------------------------------------------
    // ---------------------------------------------------------------------------------------------------------
    
    // Precio del boleto
    uint public PrecioBoleto = 5;
    // Relacion entre la de la persona y sus boletos
    mapping (address => uint []) idPersona_boletos;
    // Relacion necesaria para identificar el ganador
    mapping (uint => address) ADN_Boleto;
    // Nonce inicializado a 0
    uint randNonce = 0;
    // Registro de los boletos generados 
    uint [] boletos_comprados;
    // Evento para emitir que numero de boleto se ha comprado
    event boleto_comprado(uint);
    
    function CompraBoleto(uint _boletos) public {
        // Precio total de los boletos a comprar
        uint precio_total = _boletos * PrecioBoleto;
        
        // Se verifica que el cliente tenga el numero de tokens necesario
        require(precio_total <= MisTokens(), 
                "Necesitas mas Tokens para comprar un boleto.");
        
        /* El cliente paga el boleto con Tokens:
         - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_loteria',
         debido a que en caso de usar el Transfer o el TransferFrom las direcciones que se escogian
         para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibia el metodo Transfer
         de ERC20.sol era la direccion del contrato y no del cliente.*/
        token.transferencia_loteria(msg.sender,owner,precio_total);
        
        /*Lo que esto haría es tomar la marca de tiempo de now, el msg.sender, y un nonce 
        (un número que sólo se utiliza una vez, para que no ejecutemos dos veces la misma 
        función hash con los mismos parámetros de entrada) en incremento.
        Luego entonces utilizaría keccak para convertir estas entradas a un hash aleatorio, 
        convertir ese hash a un uint y luego utilizar % 100 para tomar los últimos 2 dígitos solamente, 
        ándonos un número totalmente aleatorio entre 0 y 99.*/
        for (uint i = 0; i< _boletos; i++){
            uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 10000;
            randNonce++;
            // Almacenamos los datos de los boletos generados
            idPersona_boletos[msg.sender].push(random);
            boletos_comprados.push(random);
            ADN_Boleto[random] = msg.sender;
            emit boleto_comprado(random);
        }
        
    }
    
    // Visualizar el numero de tus boletos
    function TusBoletos() public view returns(uint [] memory){
        return idPersona_boletos[msg.sender];
    }
    
    // Evento del boleto ganador
    event boleto_ganador (uint);
    
    // Generar ganador y ingresar dinero
    function GenerarGanador() public Unicamente(msg.sender){
        // Debe haber boletos comprados para generar un ganador
        require (boletos_comprados.length >0, "No hay boletos comprados");
        // Cojo la longitud del array para limitar la eleccion entre 0 y L (longitud)
        uint longitud = boletos_comprados.length;
        // De manera random elegir un numero entre 0 y L
        uint posicion_array = uint(uint(keccak256(abi.encodePacked(now))) % longitud);
        uint eleccion = boletos_comprados[posicion_array];
        emit boleto_ganador (eleccion);
        // Recuperar la direccion de la persona
        address direccion_ganador = ADN_Boleto[eleccion];
        // Enviarle los tokens al ganador
        token.transferencia_loteria(msg.sender,direccion_ganador,Bote());
    }
    

    // Funcion para que un cliente pueda devolver tokens si lo desea
    function DevolverTokens(uint _numTokens) public payable {
        // El numero de tokens a devolver debe ser positivo 
        require (_numTokens > 0, "Necesitas devolver un numero positivo de tokens.");
        // El usuario debe tener el número de tokens que desea devolver
        require(_numTokens <= MisTokens(), "No tienes los tokens que desea devolver.");
         // El cliente devuelve los tokens
        token.transferencia_loteria(msg.sender,address(this), MisTokens());
        // Devolucion de los ethers al cliente
        msg.sender.transfer(PrecioTokens(_numTokens)); 
    }
    
    
    // Modifier para controlar las funciones que unicamente ejecuta la loteria
    modifier Unicamente(address _direccio){
        require (_direccio == owner, "No tienes permisos para estas funciones.");
        _;
    }  
    
}