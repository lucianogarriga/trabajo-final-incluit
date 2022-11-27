//MIGRATION para hacer el deploy de un contrato
//Se agrega una VAR que represente el contrato
//luego declaramos el contrato que queremos hacer el deploy
var ManagerContract = artifacts.require("Manager");

module.exports = function(deployer) {
  //si el constructor del contrato "Squad" recibe parametros,
  //tambien hay que pasarlo en esta seccion (name)
  deployer.deploy(ManagerContract);
};