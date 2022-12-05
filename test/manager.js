const Manager = artifacts.require("Manager");
const utils = require("./helpers/utils");

contract("Manager", function (accounts) {

  let contract;
  //Address who deploy the contract
  const [peter, daniel] = accounts;

  beforeEach(async () => {
    //Must use .new() because we need a new instance for each test 
    //and utilice 1 unique address for each test
    contract = await Manager.new("NFTickets");

  });

  //1er test = Funtion Create Ticket
  context("Function: createTicket", async function () {
    //1 Test to add a Ticket to list
    it("should add the Ticket to the list", async function () {
      //1) SET UP = Initialize variables 
      //In BeforeEach()

      //2) ACT = Execute what will be tested
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
      assert.equal(ticketList.length, 1, "Ticket list should be 1");
    })

    //2 Test to verify it call the event
    it("should emit event TicketCreated", async function () {
      // Set up  
      let ownerOfPlayer = peter;
      //Act
      let tx = await contract.createTicket(
        "Partido Argentina Mexico",
        "26 de Noviembre",
        "Partido Fase de Grupos Qatar",
        0,
        0,
        0,
        1100,
        ownerOfPlayer
      )

      let log = tx.logs[0];

      //Assert
      assert.equal(log.event, "TicketCreated");
    });
  });

  context("Function: transferTicket", async function () {

    //Test to verify it transfer the ticket
    it("should transfer the ticket", async function () {
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

      await contract.transferTicket(0, daniel)

      //Assert
      assert(true);
    });

    //Test to verify if the ticket is transferible
    it("should fail if the ticket is not transferible", async function () {
      await contract.createTicket(
        "Partido Argentina Mexico",
        "26 de Noviembre",
        "Partido Fase de Grupos Qatar",
        0,
        0,
        1,
        1100,
        peter
      )

      await utils.shouldThrow(
        contract.transferTicket(0, daniel)
      )
      //Assert
      assert(true);
    });

    //Test to verify if the ticket is valid
    it("should fail if the ticket is not valid", async function () {
      await contract.createTicket(
        "Partido Argentina Mexico",
        "26 de Noviembre",
        "Partido Fase de Grupos Qatar",
        0,
        1,
        0,
        1100,
        peter
      )

      await utils.shouldThrow(
        contract.transferTicket(0, daniel)
      )
      //Assert
      assert(true);
    });

    //Test to verify it call the event
    it("should emit event TicketTransfered", async function () {
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

      let tx = await contract.transferTicket(0, daniel)
      let log = tx.logs[0];

      //Assert
      assert.equal(log.event, "TicketTransfered");
    });

  })

  context("Function: showStatistitcs", async function () {

    //Test to verify it call the event
    it("should emit event ViewStatistics", async function () {
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

      let tx = await contract.showStatistics()
      let log = tx.logs[0];

      //Assert
      assert.equal(log.event, "ViewStatistics");
    });

  })

  context("Function: deleteTicket", async function () {
    //1 Test to check the function delete the ticket
    it("should delete the ticket", async function () {
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

      await contract.deleteTicket(0)
      //check how many elements the list has and store it in a VAR
      let ticketList = await contract.getTickets();
      assert.equal(ticketList.length, 0, "Ticket didn't delete");
    })

    //2 Test to verify if the caller is the owner
    it("should fail if the caller is not the owner", async function () {
      //1) SET UP = Initialize variables 
      let notOwner = daniel;
      //In BeforeEach()

      //2) ACT = Execute what will be tested
      await utils.shouldThrow(
        contract.createTicket(
          "Partido Argentina Polonia",
          "30 de Noviembre",
          "Partido Fase de Grupos Qatar",
          0,
          0,
          0,
          2000,
          { from: notOwner }
        )
      )
    })

    //3 Test to verify it call the event
    it("should emit event TicketDeleted", async function () {

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

      let tx = await contract.deleteTicket(0)
      let log = tx.logs[0];

      //Assert
      assert.equal(log.event, "TicketDeleted");
    });
  })

});
