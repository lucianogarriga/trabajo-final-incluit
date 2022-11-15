// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Ticket {
    //Caracteristicas de cada ticket
    uint256 private id;
    string private eventName;
    string private eventDate;
    string private eventDescription;
    uint256 private price;

    enum EventType {
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

    receive() external payable {}

    fallback() external payable {}

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

    //Función p/ cambiar el precio del ticket
    function changePrice() public {}

    //Función p/ cambiar el estado Transferible/No_Transferible
    function changeTransferStatus() public {}

    //Función p/ cambiar el estado del Ticket(Valid/Used/Expired)
    function changeStatus() public {}

    //Función p/ cambiar de dueño (venta)
    function changeOwner() public {}

    //Función p/ generar un ID unico (hash)
    function generateId() public {}

    //Función p/ retornar datos del ticket
    function showInformation() public {}
}
