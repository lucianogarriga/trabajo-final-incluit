// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    address public immutable MANAGER;
    //Array of tickets
    Ticket[] private ticketList;
    //Array of owners
    address[] private Owners;

    uint256 fee = 5;
    uint256 ticketCount;
    uint256 ticketFunds;

    event TicketCreated(string eventName, uint256 price, address owner);
    event FundsReceived(uint256 amount);
    event TicketTransfered(uint256 ticketPrice, address newOner);
    event NewTicketPrice(uint256 newPrice);
    event ShowComission(uint256);
    event TicketDeleted(uint256);
    event ViewStatistics(uint256, uint256);

    receive() external payable {
        emit FundsReceived(msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.value);
    }

    constructor() {
        MANAGER = msg.sender;
    }

    /*FUNCTION 1 => Tokenize a ticket
    It takes the parameters defined by the constructor of Ticket.sol
    */
    function createTicket(
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        EventType _eventType,
        TicketStatus _ticketStatus,
        TransferStatus _transferStatus,
        uint256 _price
    ) public payable {
        Ticket ticket = new Ticket(
            _eventName,
            _eventDate,
            _eventDescription,
            _eventType,
            _ticketStatus,
            _transferStatus,
            _price,
            msg.sender
        );
        Owners.push(msg.sender);
        ticketList.push(ticket);
        ticketCount += 1;
        ticketFunds = ticketFunds + _price;
        emit TicketCreated(_eventName, _price, address(msg.sender));
    }

    //Function to see all tickets in the dApp
    function totalTickets() public view returns (uint256 total) {
        return ticketList.length;
    }

    function getTickets() public view returns (Ticket[] memory) {
        return ticketList;
    }

    function showTicketAddr(uint256 index) public view returns (Ticket) {
        return ticketList[index];
    }

    // function showTicketId(uint256 index) public {
    //     emit ShowTicketId(ticketList[index].getTicketId());
    // }

    function showAllTickets(uint256 index)
        public
        view
        returns (
            address ticketAddr,
            uint256 ticketId,
            string memory eventName,
            string memory eventDate,
            string memory eventDescription,
            EventType eventType,
            TicketStatus ticketStatus,
            uint256 ticketPrice,
            address owner
        )
    {
        return Ticket(ticketList[index]).showInformation();
    }

    //Function to see the tickets assigned to an address
    function showTicketsByAddress(address _ticketAddr)
        public
        view
        returns (
            address ticketAddr,
            uint256 ticketId,
            string memory eventName,
            string memory eventDate,
            string memory eventDescription,
            EventType eventType,
            TicketStatus ticketStatus,
            uint256 ticketPrice,
            address owner
        )
    {
        return Ticket(_ticketAddr).showInformation();
    }

    //Función p/ transferir un ticket (status Transferible)
    function transferTicket(uint256 index, address newOwner) public payable {
        require(
            ticketList[index].getTransferStatus() ==
                TransferStatus.TRANSFERIBLE,
            "This ticket isn't transferible"
        );
        require(
            ticketList[index].getTicketStatus() == TicketStatus.VALID,
            "This ticket isn't valid"
        );
        address preOwner = ticketList[index].getOwner();
        (bool sent, ) = preOwner.call{value: msg.value}("");
        require(sent, "Error to transfer ticket");
        ticketList[index].changeOwner(newOwner);
        //Owners[ticketList] = newOwner;
        emit TicketTransfered(msg.value, newOwner);
    }

    function getFee(uint256 ticketPrice) public view returns (uint256) {
        return (ticketPrice * fee) / 100;
    }

    //Función p/ cambiar el precio de un ticket / Se cobra un 5% comision hacia el manager
    function changeTicketPrice(Ticket ticket, uint256 newPrice) public payable {
        uint256 feeToCheck = getFee(newPrice);

        require(
            msg.value >= feeToCheck,
            "Fee received isn't enough. Send the 5% of new price"
        );

        Ticket(ticket).changePrice(newPrice);

        emit NewTicketPrice(newPrice);
        emit ShowComission(msg.value);
    }

    //Función p/ retornar cantidad de tickets de la dApp y el precio total
    function showStatistitcs()
        public
        returns (uint256 allTickets, uint256 allFunds)
    {
        uint256 tickets = ticketCount;
        uint256 totalFunds = ticketFunds;
        emit ViewStatistics(tickets, totalFunds);
        return (ticketCount, ticketFunds);
    }

    //Función p/ eliminar ticket de la lista
    function deleteTicket(uint256 ticketIndex) public {
        require(ticketIndex < ticketList.length, "Index not found");

        for (uint256 i = ticketIndex; i < ticketList.length - 1; i++) {
            ticketList[i] = ticketList[i + 1];
        }
        ticketList.pop();
        ticketCount -= 1;
        emit TicketDeleted(ticketIndex);
    }
}
