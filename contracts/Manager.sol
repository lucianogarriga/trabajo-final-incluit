// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    Ticket[] private ticketList;

    event FundsReceived(uint256 amount);
    event TicketTransfered(string ticket);
    event NewTicket(
        uint256 id,
        string eventName,
        string eventDate,
        address owner
    );

    receive() external payable {
        emit FundsReceived(msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.value);
    }

    constructor() {}

    //Función p/ tokenizar un ticket
    //toma los parametros definidos x el constructor de Ticket.sol
    function createTicket(
        uint256 _id,
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        uint256 _price
    ) public payable {
        Ticket newTicket = new Ticket(
            _id,
            _eventName,
            _eventDate,
            _eventDescription,
            _price
        );
        _id = setId();
        ticketList.push(newTicket);
        emit NewTicket(_id, _eventName, _eventDate, msg.sender);
    }

    //Funcion para generar un ID
    function setId() private view returns (uint256) {
        uint256 num = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 100000000;
        return num;
    }

    //Función p/ ver todos los tickets de la dApp
    function showAllTickets() public view returns (Ticket[] memory) {
        return ticketList;
    }

    //Función p/ ver los tickets asignados a un address
    function showTicketsByAddress(address) public view returns (Ticket[] memory){}

    //Función p/ transferir un ticket (status Transferible)
    function transferTicket(address transferAddres, address receiveAddress) public payable onlyOwner {
        
        //emit TicketTransfered(ticket);
    }

    //Función p/ que el dueño de un ticket le cambie el precio (5% comision)
    function changeTicketPrice() public onlyOwner {}

    //Función p/ retornar cantidad de tickets de la dApp y el precio total
    function showStatistitcs() public view {}

    //Función p/ eliminar ticket de la lista
    function deleteTicket(uint ticketIndex) public payable onlyOwner { 
        require(ticketIndex < ticketList.length, "Index not found");
 
        for (uint i = ticketIndex; i < ticketList.length -1; i++){
            ticketList[i] = ticketList[i+1];
        }
        ticketList.pop();
    }
}
