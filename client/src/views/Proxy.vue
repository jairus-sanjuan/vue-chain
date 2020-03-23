<template>
  <b-row>
    <b-col lg="12">
      <b-row align-h="center" class="my-4">
        <h2 class="product__title mb-5">Add / Change Logic contract.</h2>
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
              ><b-button block variant="primary" @click="submit"
                >Submit</b-button
              ></b-col
            >
          </b-row></b-col
        >
      </b-row>
    </b-col>
  </b-row>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState(['contracts', 'accounts'])
  },
  data() {
    return {
      address: ''
    }
  },
  methods: {
    submit: async function() {
      const { contracts, accounts } = this
      let result = await contracts.Proxy.methods
        .setLogicContract(this.address)
        .send({ from: accounts })

      if (!result) return
    }
  },
  mounted() {
    const { contracts } = this

    this.address = contracts.Logic._address
  }
}
</script>

<style>
* {
}
</style>
