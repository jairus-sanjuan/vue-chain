<template>
  <div>
    <b-row align-h="center" class="my-4">
      <h2 class="product__history">History</h2>
      <b-table striped hover :items="history"></b-table>
    </b-row>
  </div>
</template>

<script>
import { mapState } from 'vuex'
export default {
  props: {
    id: Number
  },
  computed: {
    ...mapState(['accounts', 'contracts'])
  },
  data() {
    return {
      history: []
    }
  },
  async mounted() {
    const { accounts, contracts } = this
    // console.log('Params : ', this.id)

    try {
      let track = await contracts.ModifiedSupplyChain.methods
        .getProductTrack(this.id)
        .call({ from: accounts })

      if (!track) return

      track.forEach(async t => {
        let reg = await contracts.ModifiedSupplyChain.methods
          .registrations(Number(t))
          .call({ from: accounts })

        const { ownerAddress, productOwner, trxTimeStamp } = reg
        const dat = new Date(trxTimeStamp * 1000)

        let formatted_date =
          dat.getMonth() +
          1 +
          '-' +
          dat.getDate() +
          '-' +
          dat.getFullYear() +
          ' ' +
          dat.getHours() +
          ':' +
          dat.getMinutes() +
          ':' +
          dat.getSeconds()
        this.history.push({
          RegistrationID: Number(t),
          ownerAddress,
          productOwner,
          Date: formatted_date
        })
        console.log('Registration : ', reg)
      })

      console.log('Track : ', track)
    } catch (error) {
      console.log('Error : ', error)
    }
  }
}
</script>

<style>
* {
}
</style>
