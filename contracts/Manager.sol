// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    //Ver mapping o mapping=>[array]

    Ticket[] private ticketList; 

    event FundsReceived(uint256 amount);
    event TicketTransfered(string ticket);

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
        ) public {
            Ticket ticket = new Ticket(_id, _eventName, _eventDate, _eventDescription, _price);
            ticketList.push(ticket);
        }

    //Función p/ ver todos los tickets de la dApp
    function showAllTickets() public {}

    //Función p/ ver los tickets asignados a un address
    function showTicketsByAddress() public {}

    //Función p/ transferir un ticket (status Transferible)
    function transferTicket(string memory ticket) public onlyOwner {
        //TO DO function transferTicket
        emit TicketTransfered(ticket);
    }

    //Función p/ que el dueño de un ticket le cambie el precio (5% comision)
    function changeTicketPrice() public onlyOwner {}

    //Función p/ retornar cantidad de tickets de la dApp y el precio total
    function showStatistitcs() public {}

    //Función p/ eliminar ticket de la lista
    function deleteTicket() public {}
}
