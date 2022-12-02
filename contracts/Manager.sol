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

    //Amount of fee to calculate percentage
    uint256 fee = 5;
    //Amount of tickets
    uint256 ticketCount;
    //Total funds of all tickets
    uint256 ticketFunds;

    /*Events to call in many functions, 
    to improve user experience*/
    event TicketCreated(string eventName, uint256 price, address owner);
    event FundsReceived(uint256 amount);
    event TicketTransfered(uint256 ticketPrice, address newOner);
    event NewTicketPrice(uint256 newPrice);
    event ShowComission(uint256);
    event TicketDeleted(uint256);
    event ViewStatistics(uint256, uint256);
    event TicketCount(uint256);

    //Receive & fallback so that the contract can receive ethers
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
        uint256 _price,
        address
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
    function totalTickets() public returns (uint256 total) {
        emit TicketCount(total);
        return ticketList.length;
    }

    function getTickets() public view returns (Ticket[] memory) {
        return ticketList;
    }

    //Function to view the Ticket Address from the index
    function showTicketAddr(uint256 index) public view returns (Ticket) {
        return ticketList[index];
    }

    //Function to view the Ticket's info through the index
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

    //Function to view the Ticket's info through the address
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

    /*
        Function to transfer a Ticket
        The ticket must be Transferible and Valid
    */
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
        emit TicketTransfered(msg.value, newOwner);
    }

    //Function to get the Fee Percentage
    function getFee(uint256 ticketPrice) public view returns (uint256) {
        return (ticketPrice * fee) / 100;
    }

    /*
        Function to change the ticket price
        A 5% commission is charged to the manager
    */
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

    //Function to return the quantity of tickets in the dApp and the total funds of them
    function showStatistitcs()
        public
        returns (uint256 allTickets, uint256 allFunds)
    {
        uint256 tickets = ticketCount;
        uint256 totalFunds = ticketFunds;
        emit ViewStatistics(tickets, totalFunds);
        return (ticketCount, ticketFunds);
    }

    //Function to delete a ticket of the list
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
