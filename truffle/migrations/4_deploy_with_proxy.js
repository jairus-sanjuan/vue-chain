const SupplyChainProxy = artifacts.require('SupplyChainProxy')
const SupplyChainLogic = artifacts.require('SupplyChainLogic')
module.exports = function(deployer) {
  deployer.deploy(SupplyChainProxy).then(function() {
    return deployer.deploy(SupplyChainLogic, SupplyChainProxy.address)
  })
}
