<template>
  <div>
    <b-row align-h="center">
      <h2 class="product__title">Details</h2>
      <b-table striped hover :items="product"></b-table>
    </b-row>

    <b-row align-h="center" class="my-4">
      <h2 class="product__title">Transfer Ownership</h2>
      <b-col lg="12" class="root">
        <b-row
          ><b-col lg="10"
            ><label class="sr-only" for="inline-form-input-username"
              >Address</label
            >
            <b-input-group prepend="Address" class="mb-2 mr-sm-2 mb-sm-0">
              <b-input
                id="inline-form-input-username"
                placeholder="Enter address ..."
                v-model="address"
              ></b-input> </b-input-group
          ></b-col>

          <b-col lg="2"
            ><b-button block variant="primary">Submit</b-button></b-col
          >
        </b-row></b-col
      >
    </b-row>

    <b-row align-h="center" class="my-4">
      <h2 class="product__title">History</h2>
    </b-row>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState(['accounts', 'contracts'])
  },
  async mounted() {
    const { accounts, contracts } = this

    let result = await contracts.ModifiedSupplyChain.methods
      .products(this.$route.params.id)
      .call({ from: accounts })

    if (!result) return
    const {
      mfgTimeStamp,
      modelNumber,
      partNumber,
      productOwner,
      serialNumber
    } = result
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

    this.product.push({
      id: this.$route.params.id,
      productOwner,
      modelNumber,
      partNumber,
      serialNumber,
      mfgTimeStamp: formatted_date
    })
  },
  data() {
    return {
      product: [],
      address: ''
    }
  },
  methods: {
    submit: async function() {}
  }
}
</script>

<style scoped>
.col-lg-12.root {
  padding: 20px 50px;
  background: #ffffff 0% 0% no-repeat padding-box;
  box-shadow: 0px 7px 23px #88888852;
  border-radius: 12px;
}

.product__title {
  margin: 20px 0 30px 0;
}

.product__details {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.product__header {
  padding-bottom: 5px;
  border-spacing: 2rem;
  border-bottom: 2px solid black;
}

.product__description {
  margin: 10px 0;
}
</style>
