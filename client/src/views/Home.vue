<template>
  <div class="home">
    <img alt="Vue logo" src="../assets/logo.png" />
    <HelloWorld msg="Welcome to Your Vue.js App" />
  </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'
import { init_web3, load_contracts } from '../utils/helper'

export default {
  name: 'Home',
  components: {
    HelloWorld
  },
  mounted() {
    init_web3()
    load_contracts()
  }
}
</script>
