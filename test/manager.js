const Manager = artifacts.require("Manager");
const utils = require("./helpers/utils");
 
contract("Manager", function (accounts) {

  let contract;
  //Address del deploy del contrato
  const [peter, daniel] = accounts;

  beforeEach(async () => {
    //asignamos valor a la VAR global ya declarada
    //Debemos usar .new() xq necesitamos 1 nueva instancia x cada test 
    // y utiliza 1 address unico para c/ test
    contract = await Manager.new();

  });

  //1er test = Funcion de Create Ticket
  context("Function: createTicket", async function () {
    it("should add the Ticket to the list", async function () {
      //1) SET UP = Inicializar variables 
      //In BeforeEach()

      //2) ACT = Ejecutar lo que se va a testear
      //agarramos la instancia (contract) y llamamos la funcion (createTicket)
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

      //verificar cuantos elementos tiene la lista y lo guardamos en una VAR
      let ticketList = await contract.getTickets();

      //3) ASSERT = Comprobar que los datos que devuelve son los correctos
      //que la longitud del array tenga la cantidad de Players que agregamos (1)
      //en caso de no ser correcto, que tire el error y emita el mensaje
      assert.equal(ticketList.length, 1, "Ticket list should be 1");
    })

    
  })
});
