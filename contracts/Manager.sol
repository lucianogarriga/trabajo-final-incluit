// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ticket.sol";

contract Manager is Ownable, Ticket {
    //ver si crear un mapping(address=>[]) u otra opcion

    //receive (){} y fallback(){} ya declarados en Ticket

    constructor(
        uint256 _id,
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        uint256 _price
    ) payable Ticket(_id, _eventName, _eventDate, _eventDescription, _price) {}

    function createTicket() public {}

    function showAllTickets() public {}

    function showTicketsByAddress() public {}

    function transferTicket() public onlyOwner {}

    function changeTicketPrice() public onlyOwner {}

    function showStatistitcs() public {}
}
