//MIGRATION to deploy a contract
//Tell TRUFFLE which contract i'd like to interact with

var ManagerContract = artifacts.require("Manager");

//Adding variable which represent a contract
//Then, we'll declarate the contract that we want to deploy

module.exports = function(deployer) {
  //si el constructor del contrato "Squad" recibe parametros,
  //tambien hay que pasarlo en esta seccion (name)
  deployer.deploy(ManagerContract, "NFTickets");
};