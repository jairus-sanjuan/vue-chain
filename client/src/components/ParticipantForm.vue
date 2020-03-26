<template>
  <b-row align-h="center">
    <b-col lg="6" class="form">
      <h3 class="mb-4">Participant Form</h3>
      <b-row>
        <b-col lg="6"
          ><b-form-group
            id="form-group"
            label="Username"
            label-for="form-group__username"
          >
            <b-form-input
              id="form-group__username"
              v-model="username"
              trim
            ></b-form-input> </b-form-group
        ></b-col>
        <b-col lg="6">
          <b-form-group
            id="form-group"
            label="Password"
            label-for="form-group__password"
          >
            <b-form-input
              id="form-group__password"
              v-model="password"
              type="password"
              trim
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col lg="12"
          ><b-form-group
            id="form-group"
            label="Participant Type"
            label-for="form-group__type"
          >
            <b-form-select
              v-model="type"
              :options="options"
            ></b-form-select> </b-form-group
        ></b-col>

        <b-col lg="12"
          ><b-form-group
            id="form-group"
            label="Address"
            label-for="form-group__address"
          >
            <b-form-input
              id="form-group__address"
              v-model="accounts"
              disabled
              trim
            ></b-form-input> </b-form-group
        ></b-col>
      </b-row>
      <b-row>
        <b-col lg="4" class="mx-auto"
          ><b-button variant="primary" @click="submit" :disabled="isDisabled"
            >Submit Form</b-button
          ></b-col
        >
      </b-row>
    </b-col>
  </b-row>
</template>

<script>
import { mapState } from 'vuex'
// import Web3 from 'web3'
export default {
  methods: {
    submit: async function() {
      try {
        const { username, password, accounts, type } = this
        console.log('Username : ', username)
        console.log('Password : ', password)
        console.log('Account Address : ', accounts)
        console.log('Type : ', type)

        await this.contracts.Implementation.methods
          .createParticipant(username, password, accounts, type)
          .send({ from: accounts, gas: 2000000 }, function(error, result) {
            if (error) {
              console.log('Error : ', error)
              return
            }

            console.log('Result : ', result)
          })
      } catch (error) {
        console.log('Catched Error : ', error)
      }
    }
  },
  computed: {
    ...mapState(['accounts', 'contracts'])
  },
  data() {
    return {
      username: '',
      password: '',
      type: null,
      options: [
        { value: null, text: 'Please select an option.' },
        { value: 'Manufacturer', text: 'Manufacturer' },
        { value: 'Supplier', text: 'Supplier' },
        { value: 'Consumer', text: 'Consumer' }
      ],
      isDisabled: false
    }
  },
  async mounted() {
    // console.log('Data on mount : ', this._data)
    // console.log('Accounts on mount : ', this.accounts)
    // console.log('Contracts on mount : ', this.contracts)
    try {
      const { accounts, contracts } = this

      const result = await contracts.Implementation.methods
        .getParticipantDetails(accounts)
        .call({ from: accounts })

      console.log('Participant : ', result)
      if (!result) return

      this.username = result.userName || ''
      this.password = result.password || ''
      this.type = result.participantType || null

      // if (result.participantAddress === this.accounts) this.isDisabled = true
    } catch (error) {
      console.log('Error :', error)
    }
  }
}
</script>

<style scoped>
.form.col-lg-6 {
  padding: 20px 50px;
  background: #ffffff 0% 0% no-repeat padding-box;
  box-shadow: 0px 7px 23px #88888852;
  border-radius: 12px;
}

.form-group {
  margin-bottom: 1rem;
}
</style>
