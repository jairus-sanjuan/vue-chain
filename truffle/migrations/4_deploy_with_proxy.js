const SupplyChainProxy = artifacts.require('SupplyChainProxy')
const SupplyChainLogic = artifacts.require('SupplyChainLogic')
module.exports = async function(deployer) {
  // deployer.deploy(SupplyChainProxy).then(function() {
  //   return deployer.deploy(SupplyChainLogic, SupplyChainProxy.address)
  // })
  var proxyInstance
  var logicInstance

  await deployer.deploy(SupplyChainProxy)
  proxyInstance = await SupplyChainProxy.deployed()

  await deployer.deploy(SupplyChainLogic, proxyInstance.address)
  logicInstance = await SupplyChainLogic.deployed()
  await proxyInstance.setLogicContract(logicInstance.address)
}
