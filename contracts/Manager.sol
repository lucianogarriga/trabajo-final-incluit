// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    Ticket[] private ticketList;
    mapping(Ticket => address) Owners;

    event FundsReceived(uint256 amount);
    event NewOwner(address newOner);
    event NewTicketPrice(uint256 newPrice);
    event NewTicket(string eventName, uint256 price, address owner);

    uint256 public ticketCount;

    receive() external payable {
        emit FundsReceived(msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.value);
    }

    constructor() {}

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
        uint256 _price,
        address _owner
    ) public payable {
        Ticket ticket = new Ticket(
            _eventName,
            _eventDate,
            _eventDescription,
            _eventType,
            _ticketStatus,
            _transferStatus,
            _price,
            _owner
        );
        Owners[ticket] = _owner;
        ticketList.push(ticket);
        ticketCount += 1;
        emit NewTicket(_eventName, _price, _owner);
    }

    //Function to see all tickets in the dApp
    function totalTickets() public view returns (uint256 total) {
        return ticketList.length;
    }

    function showAllTickets(uint256 index)
        public
        view
        returns (
            //address ticketAddr,
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
    function transferTicket(Ticket ticket, address newAddress)
        public
        payable
        onlyOwner
    {
        require(
            ticket.getTransferStatus() == TransferStatus.TRANSFERIBLE,
            "This ticket isn't transferible"
        );
        require(
            ticket.getTicketStatus() == TicketStatus.VALID,
            "This ticket isn't valid"
        );
        address addressSent = Owners[ticket];
        (bool sent, ) = addressSent.call{value: msg.value}("");
        require(sent == true, "Error to transfer ticket");
        Owners[ticket] = newAddress;
        emit NewOwner(newAddress);
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
    function showStatistitcs()
        public
        view
        returns (uint256 allTickets, uint256 totalFunds)
    {
        uint256 allT = totalTickets();
        uint256 funds = address(this).balance;
        return (allT, funds);
    }

    //Función p/ eliminar ticket de la lista
    function deleteTicket(uint256 ticketIndex) public onlyOwner {
        require(ticketIndex < ticketList.length, "Index not found");

        for (uint256 i = ticketIndex; i < ticketList.length - 1; i++) {
            ticketList[i] = ticketList[i + 1];
        }
        ticketList.pop();
    }
}
