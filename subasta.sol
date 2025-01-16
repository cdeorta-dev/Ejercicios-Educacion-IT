// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
/*tengo que crear una subasta que cada vez que un usuario pague 
el que gane se lo nombre y a los que pierden se le devuleve el 98$
laa subastasolamente se le puede parar el owner
1 tengo que crear una funcion donde se pueda depositar, 
2 va a ver una tupla o variable mayor apostador que se va a inicializar cuando se inicialize la subasta, que lo va arrancar el subastardor el subastador va a ser el primer mayor 
apostador con lo que inicie en la apuestsa 
otra funcion que va  a estar dentro de depositar que va a ser setear mayor apostador
*/

contract subasta {
    event EtherRecibido(address remitente, uint256 monto);
    address private owner;
    struct Person{
        address payable direccion;
        uint256 apuesta;
    }
    Person[] public listaApostadores;
    Person public mayorApostador;
    constructor() payable {
        owner=msg.sender;
        mayorApostador.direccion= payable(msg.sender);
        mayorApostador.apuesta= msg.value;
    }
    modifier onlyOwner(){
        require(owner==msg.sender,"no eres el owner");
        _;
    }
    function transferEtherOwner() external onlyOwner {
        address payable _to;
        _to = payable (msg.sender);
        if( _to.send(mayorApostador.apuesta) == false ){
            revert("fallo el envio");
        }
         devolverApuestas();
        
    }

    receive() external payable {
        if(mayorApostador.apuesta<msg.value){
            mayorApostador.direccion=payable(msg.sender);
            mayorApostador.apuesta= msg.value;
        }
        require(msg.value >= 1000, "El monto debe ser al menos 1000 wei"); 
        require(msg.value % 100 == 0, "El monto debe ser multiplo de 100 wei"); 
        emit EtherRecibido(msg.sender, msg.value);
    }


   function GetMayorApostador() external view returns (Person memory) {
        
        Person memory persona;
        for (uint i = 0; i < listaApostadores.length; i++) 
        {
           if (persona.apuesta<listaApostadores[i].apuesta){
                persona=listaApostadores[i];
           }
        }
        return persona;
    }
    
   function GetApostadores() external view returns (Person[] memory) {
        
        return listaApostadores;
    }
    //hay que devolver el 98% a cada participante
    function devolverApuestas() internal onlyOwner{
         
     
        for (uint i = 0; i < listaApostadores.length; i++) 
        {
         if(listaApostadores[i].direccion!= mayorApostador.direccion)
         if(  listaApostadores[i].direccion.send( listaApostadores[i].apuesta* 98 / 100) == false ){
            revert("fallo el envio");
        }
        }
        
    }
    

}