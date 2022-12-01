// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

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

contract Ticket {
    //Ticket characteristics
    uint256 private id;
    string private eventName;
    string private eventDate;
    string private eventDescription;
    EventType private eventType;
    TicketStatus private ticketStatus;
    TransferStatus private transferStatus;
    uint256 private price;
    address private owner;

    event newTransferStatus(string);
    event newTicketStatus(string);

    constructor(
        //It's a convention (not a requirement) to name function parameter variables with (_)
        //to differentiate them from the global variables of the contract
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        EventType _eventType,
        TicketStatus _ticketStatus,
        TransferStatus _transferStatus,
        uint256 _price,
        address _owner
    ) {
        id = setId();
        eventName = _eventName;
        eventDate = _eventDate;
        eventDescription = _eventDescription;
        eventType = _eventType;
        ticketStatus = _ticketStatus;
        transferStatus = _transferStatus;
        price = _price;
        owner = _owner;
    }

    modifier isOwner() {
        require(msg.sender == owner, "");
        _;
    }

    function getMarketPrice() external view returns (uint256) {
        return price;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getTicketId() external view returns (uint256) {
        return id;
    }

    function getEventName() external view returns (string memory) {
        return eventName;
    }

    function getTransferStatus() external view returns (TransferStatus) {
        return transferStatus;
    }

    function getTicketStatus() external view returns (TicketStatus) {
        return ticketStatus;
    }

    //FUNCTION 1 => changePrice()
    function changePrice(uint256 _newPrice) external {
        //Validate the _newPrice is another amount than price
        require(_newPrice != price);
        price = _newPrice;
    }

    //FUNCTION 2 => changeTransferStatus()
    function setTransferStatus(TransferStatus newTranStatus) private {
        transferStatus = newTranStatus;
    }

    //FUNCTION TO CHANGE STATE = Transferible/No_Transferible
    function statusNoTransfe() public {
        setTransferStatus(TransferStatus.NO_TRANSFERIBLE);
        emit newTransferStatus("TransferStatus = NO_TRANSFERIBLE");
    }

    function statusTransfe() public {
        setTransferStatus(TransferStatus.TRANSFERIBLE);
        emit newTransferStatus("TransferStatus = TRANSFERIBLE");
    }

    /*FUNCTION 3 => changeStatus()
     */
    function setTicketStatus(TicketStatus newTickStatus) private {
        ticketStatus = newTickStatus;
    }

    //Function to change the ticket status to USED
    function changeStatusUsed() public {
        setTicketStatus(TicketStatus.USED);
        emit newTicketStatus("TicketStatus = USED");
    }

    //Function to change the ticket status to EXPIRED
    function changeStatusExpired() public {
        setTicketStatus(TicketStatus.EXPIRED);
        emit newTicketStatus("TicketStatus = EXPIRED");
    }

    //FUNCTION 4 => changeOwner()
    function changeOwner(address _newOwner) external {
        //Validate the newOwner is other address than the owner
        require(_newOwner != owner);
        owner = _newOwner;
    }

    //FUNCTION 5 => create an ID for each ticket => setId()
    function setId() private view returns (uint256) {
        uint256 num = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ) % 100000000;
        return num;
    }

    //FUNCTION 6 => return ticket information => showInformation()
    function showInformation()
        public
        view
        returns (
            address _ticketAddr,
            uint256 _id,
            string memory _eventName,
            string memory _eventDate,
            string memory _eventDescription,
            EventType _eventType,
            TicketStatus _status,
            uint256 _price,
            address _ownerAddr
        )
    {
        return (
            address(this),
            id,
            eventName,
            eventDate,
            eventDescription,
            eventType,
            ticketStatus,
            price,
            owner
        );
    }
}
