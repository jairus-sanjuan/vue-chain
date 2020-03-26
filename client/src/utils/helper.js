import ModifiedSupplyChain from '../contracts/ModifiedSupplyChain.json'
import SupplyChainLogic_1 from '../contracts/SupplyChainLogic_1.json'
import SupplyChainLogic_3 from '../contracts/SupplyChainLogic_3.json'
import SupplyChainProxy from '../contracts/SupplyChainProxy.json'
import Web3 from 'web3'
import store from '../store/index'

const load_contracts = async () => {
  let ethereum = window.ethereum
  const web3 = new Web3(ethereum)
  const id = await web3.eth.net.getId()
  const proxy_network = SupplyChainProxy.networks[id]
  const logic_contract = new web3.eth.Contract(
    SupplyChainLogic_3.abi,
    proxy_network.address
  )

  return new Promise((resolve, reject) => {
    try {
      const modified_supply_chain_network = ModifiedSupplyChain.networks[id]
      const modified_supply_chain = new web3.eth.Contract(
        ModifiedSupplyChain.abi,
        modified_supply_chain_network.address
      )

      const logic_network = SupplyChainLogic_1.networks[id]
      const logic = new web3.eth.Contract(
        SupplyChainLogic_1.abi,
        logic_network.address
      )

      const proxy = new web3.eth.Contract(
        SupplyChainProxy.abi,
        proxy_network.address
      )

      var arr = {
        ModifiedSupplyChain: modified_supply_chain,
        Logic: logic,
        Proxy: proxy,
        Implementation: logic_contract
      }

      console.log('Contracts : ', arr)

      resolve(arr)
    } catch (error) {
      reject(error)
    }
  })
}

const init_web3 = async () => {
  let web3 = window.web3
  let ethereum = window.ethereum
  async function enable_web3() {
    await ethereum.enable()
  }

  const contracts = await load_contracts()
  return new Promise((resolve, reject) => {
    if (typeof web3 !== 'undefined') {
      web3 = new Web3(web3.currentProvider || 'ws://127.0.0.1:7545')
    } else {
      window.alert('Please connect to Metamask.')
    }

    if (window.ethereum) {
      const web3 = new Web3(ethereum)
      try {
        enable_web3()

        web3.eth.getAccounts(function(error, accounts) {
          store.commit('load_account', accounts[0])
        })

        window.ethereum.on('accountsChanged', function() {
          web3.eth.getAccounts(function(error, accounts) {
            store.commit('load_account', accounts[0])
            if (error) {
              console.log('Error :', error)
            }

            console.log('Account changed : ', accounts[0])
            // window.location.reload(true)
          })
        })

        store.commit('load_contract', contracts)
        console.log('web3 enabled')
        resolve(web3)
      } catch (error) {
        reject(error)
      }
    } else if (window.web3) {
      const web3 = window.web3
      console.log('Injected web3 detected.')
      resolve(web3)
    } else {
      const provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545')
      console.log('No web3 provider available')
      const web3 = new Web3(provider)
      resolve(web3)
    }
  })
}

export { init_web3, load_contracts }
