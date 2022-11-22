// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    Ticket[] private ticketList;

    event FundsReceived(uint256 amount);
    event TicketTransfered(string ticket);
    event NewTicketPrice(uint256 newPrice);
    event NewTicket(
        string eventName,
        string eventDate,
        uint256 _ticketStatus,
        address owner
    );

    receive() external payable {
        emit FundsReceived(msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.value);
    }

    constructor() payable {}

    //Función p/ tokenizar un ticket
    //toma los parametros definidos x el constructor de Ticket.sol
    function createTicket(
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        uint256 _price,
        address _owner,
        EventType _eventType,
        TicketStatus _ticketStatus,
        TransferStatus _transferStatus
    ) public payable {
        Ticket newTicket = new Ticket(
            _eventName,
            _eventDate,
            _eventDescription,
            _price,
            _owner,
            _eventType,
            _ticketStatus,
            _transferStatus
        );
        ticketList.push(newTicket);
        emit NewTicket(_eventName, _eventDate, uint256(_ticketStatus), _owner);
    }

    //Función p/ ver todos los tickets de la dApp
    function showAllTickets() public view returns (Ticket[] memory) {
        return ticketList;
    }

    //Función p/ ver los tickets asignados a un address
    function showTicketsByAddress(address)
        public
        view
        returns (Ticket[] memory)
    {}

    //Función p/ transferir un ticket (status Transferible)
    function transferTicket(address transferAddres, address receiveAddress)
        public
        payable
        onlyOwner
    {
        //emit TicketTransfered(ticket);
    }

    //Función p/ que el dueño de un ticket le cambie el precio (5% comision)
    function changeTicketPrice(Ticket ticket) public payable onlyOwner {
        uint256 commissionPercentage = 5;
        uint256 managerFee = (msg.value * commissionPercentage) / 100;
        require(msg.value >= managerFee, "The amount transfer is insufficient");

        Ticket(ticket).changePrice(msg.value);
        emit NewTicketPrice(msg.value);
    }

    //Función p/ retornar cantidad de tickets de la dApp y el precio total
    function showStatistitcs() public view {}

    //Función p/ eliminar ticket de la lista
    function deleteTicket(uint256 ticketIndex) public payable onlyOwner {
        require(ticketIndex < ticketList.length, "Index not found");

        for (uint256 i = ticketIndex; i < ticketList.length - 1; i++) {
            ticketList[i] = ticketList[i + 1];
        }
        ticketList.pop();
    }
}
