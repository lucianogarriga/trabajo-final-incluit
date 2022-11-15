// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable {
    //Ver mapping o mapping=>[array]

    Ticket[] private ticketList;

    event FundsReceived(uint256 amount);

    receive() external payable {
        emit FundsReceived(msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.value);
    }

    constructor() {}

    function createTicket() public {}

    function showAllTickets() public {}

    function showTicketsByAddress() public {}

    function transferTicket() public onlyOwner {}

    function changeTicketPrice() public onlyOwner {}

    function showStatistitcs() public {}
}
