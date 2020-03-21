const ModifiedSupplyChain = artifacts.require('ModifiedSupplyChain')

module.exports = function(deployer) {
  deployer.deploy(ModifiedSupplyChain)
}
