// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Deposit {
    address public owner;
    string constant public ownerName = "Henrique Kubenda";

    constructor() {
        owner = msg.sender;
    }

    // metodo default para permitir que el contracto pueda recibir una transferencia directa
    // a su balance utilizando su address para hacer la transferencia (i.e una persona transfiere
    // dinero al contrato de forma directa, tal cual lo haría si hiciera una transferencia a otra
    // persona utilizando el address de la persona)
    receive() external payable{
    }

    // metodo default que recibe una transacción (un deposito), la unica diferencia con el metodo
    // anterior es que este metodo recibe el deposito independientemente si la transacción tiene 
    // un msg.data asociado
    fallback() external payable{
    }

    // metodo custom creado para tambien poder hacer una transacción (un deposito) hacia el
    // balance del contrato, a diferencia de los metodos anteriores que son metodos predeterminados
    // ya que su funcionalidad ya esta implementada (se tiene acceso a estos metodos gracias a una
    // herencia que es implicita) este metodo "sendEtherToContract" puede tener una computación en su
    // cuerpo, haciendolo bastante mas flexible al querer ejecutar acciones una vez que el user
    // haga una transacción he interactue con el contrato.
    function sendEtherToContract() public payable {
        doSomething();
    }

    function getContractsBalance() public view returns(uint) {
        return address(this).balance;
    }

    function transferEthFromContractBalance(address payable _recipientTaddress, uint _amountToTransfer) public returns(bool){
        uint contractsBalance = getContractsBalance();
        bool hasAuthorizationToMakeTransfer = msg.sender == owner;
        bool trasferSuccessful = false;

        if (contractsBalance >= _amountToTransfer && hasAuthorizationToMakeTransfer) {
            // el metodo transfer es un metodo existente en los objetos de tipo address (deben ser payable para poder recibir fondos)
            // el monto que se pasa como argumento debe considerarse en "wei", 1 eth == 1000000000000000000 wei 🤯
            _recipientTaddress.transfer(_amountToTransfer);
            trasferSuccessful = true;
        }

        return trasferSuccessful;
    }

    function doSomething() private pure returns(string memory) {
        // inserte su computación compleja aqui i.e:
        int x = 1;
        int y = -1;
        string memory superImportantMessage = "happy 2022!";
        
        if(y + x == 0) {
            superImportantMessage = "maths are crazy!";
        } else {
            superImportantMessage = "maths are even crazier if this code gets executed xD";
        }
        return superImportantMessage;
    }
}
