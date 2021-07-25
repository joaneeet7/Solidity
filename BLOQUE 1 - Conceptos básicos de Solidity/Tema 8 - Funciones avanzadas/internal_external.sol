pragma solidity >=0.4.4 <0.7.0;

contract Comida{
    
    struct plato{
        string name;
        string ingredientes;
        uint tiempo;
    }
    
    plato [] platos;
    mapping(string=>string) ingredientesPlatos;
    
    function NuevoPlato(string _nombre, string _ingredientes, uint _tiempo) internal{
        platos.push(plato(_nombre, _ingredientes, _tiempo));
        ingredientesPlatos[_nombre]=_ingredientes;
    }
    
    function ingredientes(string _nombre) external view returns (string){
        return ingredientesPlatos[_nombre];
    } 
    
}

//https://www.youtube.com/watch?v=Ii4g38mPPlg


contract Sandwich is Comida{
    
    
    function sandwitch(string _ingredientes, uint _tiempo) public{
        NuevoPlato("Sandwitch", _ingredientes, _tiempo);
    }
    
    function verIngredientes() public view returns(string){
        return this.ingredientes("Sandwitch");
    }
    
}