const SafeMath = artifacts.require("SafeMath");
const MetaCoin = artifacts.require("MetaCoin");
const Token = artifacts.require("MetaCoin");
const Forward = artifacts.require("Forward");
const Swap = artifacts.require("Swap");
module.exports = function(deployer) {
  deployer.deploy(SafeMath);
    deployer.deploy(MetaCoin);
    deployer.deploy(Forward);
    deployer.deploy(Swap);
};
