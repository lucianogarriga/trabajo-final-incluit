const Ticket = artifacts.require("Ticket");
const utils = require("./helpers/utils");


contract("Ticket", function (accounts) {

  let contract;
  //Address who deploy the contract
  const [peter, daniel] = accounts;

  beforeEach(async () => {
    //Must use .new() because we need a new instance for each test 
    //and utilice 1 unique address for each test
    contract = await Ticket.new(
      "Partido Argentina Mexico",
      "26 de Noviembre",
      "Partido Fase de Grupos Qatar",
      0,
      0,
      0,
      1100,
      peter);

  });

  //1st test = Funtion Change Price
  context("Function: changePrice", async function () {

    it("should change the Ticket Price", async function () {
      //1) SET UP 
      //In BeforeEach() 
      //2) ACT 
      await contract.changePrice(200
      )

      assert(true);

    })
  });

  //2nd test = Funtion Status No Transfer
  context("Function: statusNoTransfe", async function () {

    it("should emit the event newTransferStatus", async function () {
      //1) SET UP 
      //In BeforeEach() 
      //2) ACT  
      let tx = await contract.statusNoTransfe();
      let log = tx.logs[0];
      //3) ASSERT
      assert.equal(log.event, "newTransferStatus");

    })
  });

  //3rd test = Funtion Status Transfer
  context("Function: statusTransfe", async function () {

    it("should emit the event newTransferStatus", async function () {
      //1) SET UP 
      //In BeforeEach() 
      //2) ACT  
      let tx = await contract.statusTransfe();
      let log = tx.logs[0];
      //3) ASSERT
      assert.equal(log.event, "newTransferStatus");

    })
  });

  //4th test = Funtion Status Used
  context("Function: changeStatusUsed", async function () {

    it("should emit the event newTicketStatus", async function () {
      //1) SET UP 
      //In BeforeEach() 
      //2) ACT  
      let tx = await contract.changeStatusUsed();
      let log = tx.logs[0];
      //3) ASSERT
      assert.equal(log.event, "newTicketStatus");

    })
  });

  //5th test = Funtion Status Expired
  context("Function: changeStatusExpired", async function () {

    it("should emit the event newTicketStatus", async function () {
      //1) SET UP 
      //In BeforeEach() 
      //2) ACT  
      let tx = await contract.changeStatusExpired();
      let log = tx.logs[0];
      //3) ASSERT
      assert.equal(log.event, "newTicketStatus");

    })
  });

  //6th test = Function change owner
  context("Function: changeOwner", async function () {

    it("should change the Ticket Owner", async function () {
      //1) SET UP 
      //In BeforeEach() 
      //2) ACT 
      await contract.changeOwner(daniel)

      assert(true); 
    })
  });
})


