const SupplyChainProxy = artifacts.require('SupplyChainProxy')
const SupplyChainLogic_1 = artifacts.require('SupplyChainLogic_1')
module.exports = async function(deployer) {
  await deployer.deploy(SupplyChainProxy)
  var proxy = await SupplyChainProxy.deployed()

  await deployer.deploy(SupplyChainLogic_1)
  var logic = await SupplyChainLogic_1.deployed()
  await proxy.setLogicContract(logic.address)
}
