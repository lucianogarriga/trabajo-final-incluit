const Manager = artifacts.require("Manager");

 
contract("Manager", function (/* accounts */) {
  it("should assert true", async function () {
    await Manager.deployed();
    return assert.isTrue(true);
  });
});
