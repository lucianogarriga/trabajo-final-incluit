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

    // receive() external payable {}

    // fallback() external payable {}

    constructor(
        //It's a convention (not a requirement) to name function parameter variables with (_)
        //to differentiate them from the global variables of the contract
        string memory _eventName,
        string memory _eventDate,
        string memory _eventDescription,
        uint256 _price,
        address _owner,
        EventType _eventType,
        TicketStatus _ticketStatus,
        TransferStatus _transferStatus
    ) {
        id = setId();
        eventName = _eventName;
        eventDate = _eventDate;
        eventDescription = _eventDescription;
        price = _price;
        eventType = _eventType;
        ticketStatus = _ticketStatus;
        transferStatus = _transferStatus;
        owner = _owner;
    }

    function getMarketPrice() external view returns (uint256) {
        return price;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getEventName() external view returns (string memory) {
        return eventName;
    }
    function getTicketStatus() external view returns (TicketStatus){
        return ticketStatus;
    }

    //FUNCTION 1 => changePrice()
    function changePrice(uint256 _newPrice) external {
        price = _newPrice;
    }

    //FUNCTION 2 => changeTransferStatus()
    function setTransferStatus(TransferStatus newTranStatus) private {
        transferStatus = newTranStatus;
    }

    //FUNCTION TO CHANGE STATE = Transferible/No_Transferible
    //OPTION A) 
    function changeTransferStatus() public {
        setTransferStatus(TransferStatus.NO_TRANSFERIBLE);
        emit newTransferStatus("TransferStatus = NO_TRANSFERIBLE");
        //Se cambia 1 sola vez y es preciso el evento
    }
    //OPTION B) 
    function changeTransferStat(uint256 newTransfStat) public {
        require(
            newTransfStat <= uint256(TransferStatus.NO_TRANSFERIBLE),
            "Out of Range"
        );
        transferStatus = TransferStatus(newTransfStat);
        emit newTransferStatus("New transfer status");
        //Se puede cambiar de transferible a no_transferible las veces que sea necesario
        //Pero falta definir como asociar cada evento a cada status
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
    function changeOwner(address _newOwner) private {
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
            uint256 _price,
            string memory _eventDescription,
            EventType _eventType,
            TicketStatus _status,
            address _ownerAddr
        )
    {
        return (
            address(this),
            id,
            eventName,
            eventDate,
            price,
            eventDescription,
            eventType,
            ticketStatus,
            owner
        );
    }
}

