export default {
  load_contract: (state, contract) => {
    state['contracts'] = contract
    console.log('Contract : ', contract)
  },
  load_account: (state, account) => {
    state['accounts'] = account
    console.log('Account : ', account)
  }
}
