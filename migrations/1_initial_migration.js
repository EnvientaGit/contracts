var Migrations = artifacts.require("./Migrations.sol");
var EnvientaToken = artifacts.require("./EnvientaToken.sol");
var EnvientaCrowdsale = artifacts.require("./EnvientaCrowdsale.sol");
var EnvientaPreToken = artifacts.require("./EnvientaPreToken.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(EnvientaToken);
  deployer.deploy(EnvientaCrowdsale);
  deployer.deploy(EnvientaPreToken);
};
