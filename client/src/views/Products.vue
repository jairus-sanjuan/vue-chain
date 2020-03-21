<template>
  <div><product-table /></div>
</template>

<script>
import { mapState } from 'vuex'
import ProductTable from '../components/ProductTable.vue'

export default {
  components: {
    ProductTable
  },
  computed: {
    ...mapState(['accounts', 'contracts'])
  },
  methods: {},
  async mounted() {
    const { accounts, contracts } = this
    await contracts.ModifiedSupplyChain.methods
      .product_counter()
      .call({ from: accounts }, function(error, result) {
        if (error) return error

        console.log('ProductCounter : ', result)
      })
  }
}
</script>
<style>
* {
}
</style>
