// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Ticket {
    uint256 private id;
    string private eventName;
    string private eventDate;
    string private eventDescription;
    uint256 private price;

    enum eventType {
        Sports,
        Music,
        Cinema
    }

    enum TicketStatus {
        Valid,
        Used,
        Expired
    }

    enum TransferStatus {
        Transferible,
        No_Transferible
    }

    event FundsReceived(uint256 amount);

    receive() external payable {
        emit FundsReceived(msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.value);
    }

    constructor(
        uint256 _id,
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        uint256 _price
    ) {
        id = _id;
        eventName = _eventName;
        eventDate = _eventDate;
        eventDescription = _eventDescription;
        price = _price;
    }

    function changePrice() public {}

    function changeTransferStatus() public {}

    function changeStatus() public {}

    function changeOwner() public {}

    function generateId() public {}

    function showInformation() public {}
}
