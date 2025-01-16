// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
/*tengo que crear una subasta que cada vez que un usuario pague 
el que gane se lo nombre y a los que pierden se le devuleve el 98$
laa subastasolamente se le puede parar el owner
1 tengo que crear una funcion donde se pueda depositar, 
2 va a ver una tupla o variable mayor apostador que se va a inicializar cuando se inicialize la subasta, que lo va arrancar el subastardor el subastador va a ser el primer mayor 
apostador con lo que inicie en la apuestsa 
otra funcion que va  a estar dentro de depositar que va a ser setear mayor apostador
el owner no puede participar

*/

contract subasta {
    event EtherRecibido(address remitente, uint256 monto,uint256 total);
     event Ganador(address ganador, uint256 monto);
    address private owner;
    struct Person{
        address payable direccion;
        uint256 apuesta;
    }
    mapping (address  => uint256) public totalinversion;
    address payable[] public listaApostadores;
     address payable public mayorApostador;
    constructor() payable {
        owner=msg.sender;
        mayorApostador= payable(msg.sender);
         totalinversion[msg.sender]= msg.value;
    }
    modifier onlyOwner(){
        require(owner==msg.sender,"no eres el owner");
        _;
    }
    function transferEtherOwnerGanador() external onlyOwner {
        address payable _to;
        _to = payable (msg.sender);
        if( _to.send(totalinversion[mayorApostador]) == false ){
            revert("fallo el envio");
        }
         devolverApuestas();
         emit Ganador(mayorApostador,totalinversion[mayorApostador]);
    }
     function transferEtherOwner() external onlyOwner {
        address payable _to;
        _to = payable (msg.sender);
        if( _to.send(address(this).balance) == false ){
            revert("fallo el envio");
        }
        
        for (uint256 i ;i< listaApostadores.length;i++ ){
           
         totalinversion[listaApostadores[i]]=0;
          
        }   
        //16/01/2025
        delete listaApostadores;
        
    }
//el owner no puede participar
    receive() external payable {
 


        require(msg.value >= 1000, "El monto debe ser al menos 1000 wei"); 
        require(msg.value % 100 == 0, "El monto debe ser multiplo de 100 wei"); 
       if(totalinversion[msg.sender]==0){  listaApostadores.push(payable(msg.sender)) ;}
      
         totalinversion[msg.sender]+= msg.value;
       
  if(totalinversion[mayorApostador]<totalinversion[msg.sender]){
            mayorApostador=payable(msg.sender);
        
        }

        emit EtherRecibido(msg.sender, msg.value,totalinversion[msg.sender]);
    }


  
    
   function GetApostadores() external view returns (Person[] memory) {

        Person[]  memory valorApostadores = new  Person[] (listaApostadores.length);
       
        for (uint256 i ;i< listaApostadores.length;i++ ){
            Person memory aux;
            aux.direccion = listaApostadores[i];
            aux.apuesta = totalinversion[listaApostadores[i]];
            valorApostadores[i]=aux;
        }   
        return valorApostadores;
    }
    //hay que devolver el 98% a cada participante
    function devolverApuestas() internal onlyOwner{
         
     
        for (uint i = 0; i < listaApostadores.length; i++) 
        {
         if(listaApostadores[i]!= mayorApostador)
         if(  listaApostadores[i].send( totalinversion[listaApostadores[i]]* 98 / 100) == false ){
            revert("fallo el envio");
        }
        }
        
    }
    

}