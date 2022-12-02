const Manager = artifacts.require("Manager");
const utils = require("./helpers/utils");
 
contract("Manager", function (accounts) {

  let contract;
  //Address who deploy the contract
  const [peter, daniel] = accounts;

  beforeEach(async () => {
    //Asign value to the global variable 
    //Must use .new() because we need a new instance for each test 
    //and utilice 1 unique address for each test
    contract = await Manager.new();

  });

  //1er test = Funtion Create Ticket
  context("Function: createTicket", async function () {
    //1 Test to add a Ticket to list
    it("should add the Ticket to the list", async function () {
      //1) SET UP = Initialize variables 
      //In BeforeEach()

      //2) ACT = Execute what will be tested
      //we take the instance (contract) and call the function (createTicket)
      await contract.createTicket(
        "Partido Argentina Mexico",
        "26 de Noviembre",
        "Partido Fase de Grupos Qatar",
        0,
        0,
        0,
        1100,
        peter
      )

      //check how many elements the list has and store it in a VAR
      let ticketList = await contract.getTickets();

      //3) ASSERT = Check that the data returned are correct.
      //Check that the length of the array has the number of Players we add (1)
      //if it is not correct, throw the error and issue the message
      assert.equal(ticketList.length, 1, "Ticket list should be 1");
    })

    //2 Test to add a Ticket to list
    it("should fail if the caller is not the owner", async function () {
      //1) SET UP = Initialize variables 
      let notOwner = daniel;
      //In BeforeEach()

      //2) ACT = Execute what will be tested
      //we take the instance (contract) and call the function (createTicket)
      await utils.shouldThrow(
      contract.createTicket(
        "Partido Argentina Polonia",
        "30 de Noviembre",
        "Partido Fase de Grupos Qatar",
        0,
        0,
        0,
        2000,
        {from: notOwner}
        )
      )
    })
    
  })
});
