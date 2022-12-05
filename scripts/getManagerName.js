//Import the Web3 library
const Web3 = require("web3");

//Filesystem of Js
const fs = require("fs");
//Pass to the script the abi that is generated in the file Manager.json
//Then we locate where the abi is and the reading method
//The script is called from the root of the project
const { abi } = JSON.parse(fs.readFileSync("./build/contracts/Manager.json"));

//Then we'll create the function that will be called when the script is executed
async function main() {

    //1st = Configure the connection to the Goerli network
    const network = process.env.ETHEREUM_NETWORK;

    //The Web3 library must be instantiated.
    const web3 = new Web3(
        //We must pass the Infura url
        //To get events, we do not call HTTPS but Websockets(wss)
        //To leave a connection open and receive events
        process.env.INFURA_URL
    );

    //To do tx, they must be SIGNED and we need the private key
    //We use the web3 library, and with our key it generates an account object type
    const signer = web3.eth.accounts.privateKeyToAccount(process.env.ACCOUNT_PRIVATE_KEY);

    //This signer account created we'll added it to the web3 library
    web3.eth.accounts.wallet.add(signer);

    //Create a new instance of the contract to interact with it
    const contract = new web3.eth.Contract(
        abi,
        //We pass the environment variable where we deploy the contract
        process.env.SQUAD_DEPLOYED_ADDRESS
    );

    //Subscribe to the event before calling the issuing function
    contract.events.ManagerName().on('data', function (event) {
        console.log(`New event - manager name: ${event.returnValues.name}`);
        //We add a catch of any error
    }).on('error', function (error, receipt) {
        console.log(`Error: ${error}`);
    });

    contract.events.TicketCreated().on('data', function (event) {
        console.log(`Ticket created - name: ${event.returnValues.eventName}`);
        //We add a catch of any error
    }).on('error', function (error, receipt) {
        console.log(`Error: ${error}`);
    });

    //Once the events have been subscribed, you must contact the contract x methods
    //We must prepare the transaction (tx) and call the methods of the contract
    
    //const tx = contract.methods.getManagerName();
    const tx = contract.methods.createTicket("Partido Argentina Mexico",
    "26 de Noviembre",
    "Partido Fase de Grupos Qatar",
    0,
    0,
    0,
    1100,
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");

    //Now the tx must be sent, the blockchain must interact with the contract.
    //and execute the methods
    const receipt = await tx.send({
        //1st say who is the one who sends the tx, the one who signs,
        from: signer.address,
        //2nd spend the gas we are willing to pay for
        gas: await tx.estimateGas()
    })

    //Once this is done, we ask for the hash of the etherscan tx.
    .once("transactionHash", (txhash) => {
        console.log(`https://${network}.etherscan.io/tx/${txhash}`);
    });

    //We print by console that finished and the block number that validated the tx.
    console.log(`Block number: ${receipt.blockNumber}`);
}

//Once finished with the function, we do the require of dotenv
require("dotenv").config();
//Then we call the main function, which is all that was developed at the beginning
main();