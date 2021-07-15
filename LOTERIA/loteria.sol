// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";


contract loteria{
    
    // Implementar la compra de Tokens
    // Funcion para comprar tickets de numeros aleatorios entre un rango de numeros y almacenarlos en un array
    // Funcion para comprar tickets con tokens
    // Funcion para ejecutar el ganador (aleatoriamente de un billete comprado):
        // Asignar all bote de Tokens al ganador
    // Funcion para cambiar los Tokens por ethers
    
    
    // Analisis del proyecto:
        // Ver que ofrece este programa en terminos de seguridad
        // Desplegarlo sobre Rinkeby con Metamask
        // Realizar all the proceso de LOTERIA 
        
    
    // Instancia del contrato token
    ERC20Basic private token;
    
    // Direcciones
    address public owner;
    address public contrato;
    
    // Constructor
    constructor () public {
        token = new ERC20Basic(100000);
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
    
    // Registro de los numeros de los boletos
    uint [] numeros_boletos;
    function GeneracionBoletos() public Unicamente(msg.sender){
        // Maximo numero de boletos a generar
        uint max_boletos = 1000;
        
        // Generacion de un determinado numero de boletos 
        for (uint i = 0; i< max_boletos; i++){
            numeros_boletos.push(i);
        }
    }
    
    // Establecer el precio de un boleto
    function PrecioBoleto() internal pure returns (uint){
        return 5;
    }
    
    // Relacion entre la identidad de una persona y el numero de boleto
    mapping (string => uint []) public boletos_persona;
    // Evento para emitir que numero de boleto se ha comprado
    event boleto_comprado(uint);
    
    // Comprar un boleto de loteria
    uint last_boleto = 0;
    function CompraBoleto(uint _boletos, string memory _idPersona) public {
        
        // Es necesario que los boletos se hayan generado previamente a comprarlos
        require (numeros_boletos.length > 0, "Aun no se han generado los boletos.");
        
        // Precio total de los boletos a comprar
        uint precio_total = _boletos * PrecioBoleto();
        
        // Se verifica que el cliente tenga el numero de tokens necesario
        require(precio_total <= MisTokens(), 
                "Necesitas mas Tokens para comprar un boleto.");
        
        /* El cliente paga el boleto con Tokens:
         
         - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_loteria',
         debido a que en caso de usar el Transfer o el TransferFrom las direcciones que se escogian
         para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibia el metodo Transfer
         de ERC20.sol era la direccion del contrato y no del cliente.*/
        token.transferencia_loteria(msg.sender,owner,precio_total);
        
        // Asignar los boletos a la persona
        //uint256 [] storage _idboleto;
        
        // Se cogen los numeros disponibles para los boletos de esa persona
        //for (uint i = 0; i < (_boletos+1); i++){
       //     _idboleto.push(numeros_boletos[last_boleto]);
        //    last_boleto++;
        //}
        
        // Se relacionan los numeros de los boletos a la identidad de esa persona
        //uint [] storage boletos;
        //for (uint i = 0; i< _idboleto.length; i++){
        //    boletos.push(_idboleto[i]);
        //}
        
        // Asignacion del numero de boletos a esa persona
        //boletos_persona[_idPersona] = boletos;
        
    }
    
    
    // Modifier para controlar las funciones que unicamente ejecuta la loteria
    modifier Unicamente(address _direccio){
        require (_direccio == owner, "No tienes permisos para estas funciones.");
        _;
    }  
    
}
