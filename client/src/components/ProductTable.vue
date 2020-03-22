<template>
  <div>
    <b-table striped hover :items="products"
      ><template v-slot:cell(id)="data">
        <!-- `data.value` is the value after formatted by the Formatter -->
        <router-link :to="`/products/${data.value}`">{{
          data.value
        }}</router-link>
      </template></b-table
    >
  </div>
</template>

<script>
// import Web3 from 'web3'
import { mapState } from 'vuex'

export default {
  methods: {},
  computed: {
    ...mapState(['contracts', 'accounts'])
  },
  data() {
    return {
      products: []
    }
  },
  async mounted() {
    const { accounts, contracts } = this
    let count = await contracts.ModifiedSupplyChain.methods
      .product_counter()
      .call({ from: accounts })

    if (!count) return

    for (var i = 0; i < count; i++) {
      var product = await contracts.ModifiedSupplyChain.methods
        .products(i)
        .call({ from: accounts })

      if (!product) return

      const {
        mfgTimeStamp,
        modelNumber,
        partNumber,
        productOwner,
        serialNumber
      } = product

      const dat = new Date(mfgTimeStamp * 1000)

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

      this.products.push({
        id: i,
        productOwner,
        modelNumber,
        partNumber,
        serialNumber,
        mfgTimeStamp: formatted_date
      })
    }

    console.log('Products :', this.products)
  }
}
</script>

<style>
* {
}
</style>
