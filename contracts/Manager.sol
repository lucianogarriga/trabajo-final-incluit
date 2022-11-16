// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    //Ver mapping o mapping=>[array]

    mapping(address => uint256) ticketId;
    Ticket[] private ticketList;

    event FundsReceived(uint256 amount);
    event TicketTransfered(string ticket);
    event NewTicket(string eventName, string eventDate, address owner);

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
        ticketList.push(new Ticket(
            setId(_id),
            _eventName,
            _eventDate,
            _eventDescription,
            _price));
        emit NewTicket(_eventName, _eventDate, address(this));
    }

    //Funcion para generar un ID
    function setId(uint256 _id) private view returns (uint256) {
        _id = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, _id))) 
        % 100000000;
        return _id;
    }

    //Función p/ ver todos los tickets de la dApp
    function showAllTickets() public view {}

    //Función p/ ver los tickets asignados a un address
    function showTicketsByAddress() public view {}

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