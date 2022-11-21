// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Ticket {
    //Caracteristicas de cada ticket
    uint256 private id;
    string private eventName;
    string private eventDate;
    string private eventDescription;
    uint256 private price;
    address private owner;

    enum EventType {
        SPORTS,
        MUSIC,
        CINEMA
    }
    enum TicketStatus {
        VALID,
        USED,
        EXPIRED
    }
    enum TransferStatus {
        TRANSFERIBLE,
        NO_TRANSFERIBLE
    }

    EventType private eventType;
    TicketStatus private ticketStatus;
    TransferStatus private transferStatus;

    event newTransferStatus(string status);

    receive() external payable {}

    fallback() external payable {}

    constructor(
        //Es una convencion (no un requisito) nombrar variables de parametros de funciones con (_)
        //para diferenciarlas de las variables globales del contrato
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
        eventType = EventType.SPORTS;
        ticketStatus = TicketStatus.VALID;
        transferStatus = TransferStatus.TRANSFERIBLE;
    }

    function getMarketPrice() public view returns (uint256){
        return price;
    }

    function getOwner() public view returns(address){
        return owner;
    }
    function getEventName() public view returns(string memory){
        return eventName;
    }
 
    function changePrice() public {}

    //Función p/ cambiar el estado del Ticket(Valid/Used/Expired)
    function changeStatus() public {}

    function setTransferStatus(TransferStatus newStatus) private {
        transferStatus = newStatus;
    }
    //Función p/ cambiar el estado Transferible/No_Transferible
    function changeTransferStatus() public { 
        setTransferStatus(TransferStatus.NO_TRANSFERIBLE); 
        emit newTransferStatus("No Transferible");
    }

    //Función p/ cambiar de dueño (venta)
    function changeOwner() public {}

    //Función p/ generar un ID unico (hash) ?
    function generateId() public {}

    //Función p/ retornar datos del ticket
    function showInformation() public {}
}
