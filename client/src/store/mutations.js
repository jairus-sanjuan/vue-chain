export default {
  load_contract: (state, { name, contract }) => {
    state['contracts'][name] = contract
    console.log('Contract : ', contract)
  },
  load_account: (state, account) => {
    state['accounts'] = account
    console.log('Account : ', account)
  }
}
