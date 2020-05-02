<template>
  <div class="hello">
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
      msg: 'Welcome to Your Vue.js App',
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

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
