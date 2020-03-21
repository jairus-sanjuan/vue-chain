<template>
  <div class="home">
    <Loader v-if="!isFinished" />
    <div class="p-3" v-else>
      <img class="mb-3" alt="Vue logo" src="../assets/logo.png" />
      <h4>Welcome to Supply Chain made with Vue & VueX</h4>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import Loader from '@/components/Loader.vue'
import { init_web3 } from '../utils/helper'
import { mapState } from 'vuex'
// import { mapActions } from 'vuex'
export default {
  name: 'Home',
  components: {
    Loader
  },
  data() {
    return {
      isFinished: false
    }
  },
  computed: {
    ...mapState(['contracts'])
  },
  mounted() {
    if (this.contracts.ModifiedSupplyChain) {
      this.isFinished = !this.isFinished
    } else {
      init_web3().then(() => (this.isFinished = !this.isFinished))
    }
  }
}
</script>
