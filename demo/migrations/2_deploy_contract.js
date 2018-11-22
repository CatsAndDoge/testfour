var Demo = artifacts.require("./Demo.sol");
var User = artifacts.require("./user.sol");
module.exports = function(deployer){
  deployer.deploy(Demo);
  deployer.deploy(User);
}

