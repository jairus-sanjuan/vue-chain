const SupplyChainProxy = artifacts.require('SupplyChainProxy')
const SupplyChainLogic_3 = artifacts.require('SupplyChainLogic_3')
module.exports = async function(deployer) {
  await deployer.deploy(SupplyChainProxy)
  var proxy = await SupplyChainProxy.deployed()

  await deployer.deploy(SupplyChainLogic_3)
  var logic = await SupplyChainLogic_3.deployed()
  await proxy.setLogicContract(logic.address)
}
