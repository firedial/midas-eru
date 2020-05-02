<template>
  <div class="main">
    aaa
    <button v-on:click="getBalances">get</button>
    <balance-table v-bind:balances="balances"/>
  </div>
</template>

<script>
import axios from 'axios'
import Table from '@/components/Table'
export default {
  name: 'Main',
  data () {
    return {
      balances: []
    }
  },
  methods: {
    getBalances: function () {
      axios
        .get('http://localhost:8080/api/v1/balance/?')
        .then(response => (this.balances = response.data))
    }
  },
  components: {
    'balance-table': Table
  }
}
</script>

<style scoped>
</style>
