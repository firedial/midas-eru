<template>
  <div class="main">
    <div id="search">
      aaa {{ queries }} <br/>
      startDate: <input type="date" v-model="queries.startDate">
      endDate: <input type="date" v-model="queries.endDate">
      moveIgnore: <input type="checkbox" v-model="queries.moveIgnore">
      <button v-on:click="getBalances">get</button>
    </div>
    <div id="contents">
      <balance-table v-bind:balances="balances"/>
    </div>
    <div id="attribute">
      <input type="radio" value="kind" v-model="targetAttributeList">
      <label for="kind">kind</label>
      <input type="radio" value="purpose" v-model="targetAttributeList">
      <label for="purpose">purpose</label>
      <input type="radio" value="place" v-model="targetAttributeList">
      <label for="place">place</label>
      <table>
        <tr>
          <th></th>
          <th>id</th>
          <th>name</th>
        </tr>
        <tr v-for="attribute in attributes" v-bind:key="attribute.id">
          <td>
            <input v-if="targetAttributeList === 'kind'" type="checkbox" :value="attribute.id" v-model="queries.checkedKinds">
            <input v-else-if="targetAttributeList === 'purpose'" type="checkbox" :value="attribute.id" v-model="queries.checkedPurposes">
            <input v-else-if="targetAttributeList === 'place'" type="checkbox" :value="attribute.id" v-model="queries.checkedPlaces">
          </td>
          <td> {{ attribute.id }} </td>
          <td> {{ attribute.name }} </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Table from '@/components/Table'
export default {
  name: 'Main',
  data () {
    return {
      balances: [],
      kinds: [],
      purposes: [],
      places: [],
      targetAttributeList: 'kind',
      queries: {
        moveIgnore: false,
        startDate: '',
        endDate: '',
        checkedKinds: [],
        checkedPurposes: [],
        checkedPlaces: []
      }
    }
  },
  methods: {
    getBalances: function () {
      axios
        .get('http://localhost:8080/api/v1/balance/?' + this.query)
        .then(response => (this.balances = response.data))
    },
    getCheckedAttributes: function () {
      if (this.targetAttributeList === 'kind') {
        return this.queries.checkedKinds
      }
      if (this.targetAttributeList === 'purpose') {
        return this.queries.checkedPurposes
      }
      if (this.targetAttributeList === 'place') {
        return this.queries.checkedPlaces
      }
      return this.queries.checkedKinds
    }
  },
  computed: {
    query: function () {
      var query = '1=1'
      if (this.queries['moveIgnore'] === true) {
        query += '&move=ignore'
      }
      if (this.queries['startDate'] !== '') {
        query += '&start=' + this.queries['startDate'].replace(/-/g, '/')
      }
      if (this.queries['endDate'] !== '') {
        query += '&end=' + this.queries['endDate']
      }
      if (this.queries['checkedKinds'] !== []) {
        query += '&' + this.queries['checkedKinds'].map(x => 'kind=' + x).join('&')
      }
      if (this.queries['checkedPurposes'] !== []) {
        query += '&' + this.queries['checkedPurposes'].map(x => 'purpose=' + x).join('&')
      }
      if (this.queries['checkedPlaces'] !== []) {
        query += '&' + this.queries['checkedPlaces'].map(x => 'place=' + x).join('&')
      }
      return query
    },
    attributes: function () {
      if (this.targetAttributeList === 'kind') {
        return this.kinds
      }
      if (this.targetAttributeList === 'purpose') {
        return this.purposes
      }
      if (this.targetAttributeList === 'place') {
        return this.places
      }
      return []
    }
  },
  mounted () {
    axios
      .get('http://localhost:8080/api/v1/kind/')
      .then(response => (this.kinds = response.data))
    axios
      .get('http://localhost:8080/api/v1/purpose/')
      .then(response => (this.purposes = response.data))
    axios
      .get('http://localhost:8080/api/v1/place/')
      .then(response => (this.places = response.data))
  },
  components: {
    'balance-table': Table
  }
}
</script>

<style scoped>
#contents {
  float: left;
  width: 800px;
}
#attribute {
  float: left;
  width: 280px;
}
</style>
