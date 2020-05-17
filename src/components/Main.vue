<template>
  <div class="main">
    <div id="search">
      <span>
        aaa {{ queries }} <br/>
        startDate: <input type="date" v-model="queries.startDate">
        endDate: <input type="date" v-model="queries.endDate">
        moveIgnore: <input type="checkbox" v-model="queries.moveIgnore">
      </span>
      <br/>
      <span>
        <input type="radio" value="none" v-model="queries.groupByDate">
        <label for="none">none</label>
        <input type="radio" value="day" v-model="queries.groupByDate">
        <label for="day">day</label>
        <input type="radio" value="month" v-model="queries.groupByDate">
        <label for="month">month</label>
        <input type="radio" value="year" v-model="queries.groupByDate">
        <label for="year">year</label>
        <input type="radio" value="fiscal_year" v-model="queries.groupByDate">
        <label for="fiscal_year">fiscal_year</label>
      </span>
      <br/>
      <span>
        <input type="radio" value="none" v-model="queries.groupByCollection">
        <label for="none">none</label>
        <input type="radio" value="kind" v-model="queries.groupByCollection">
        <label for="kind">kind</label>
        <input type="radio" value="purpose" v-model="queries.groupByCollection">
        <label for="purpose">purpose</label>
        <input type="radio" value="place" v-model="queries.groupByCollection">
        <label for="place">place</label>
      </span>
      <button v-on:click="getBalances">get</button>
    </div>
    <div id="contents">
      <balance-table v-if="viewPanel === 'balanceTable' && doGroupBy === false" v-bind:balances="balances"/>
      <sum-table v-if="viewPanel === 'sumTable' && doGroupBy === true" v-bind:sums="balances"/>
      <attribute-bar v-if="viewPanel === 'horizontalBar'" v-bind:sumData="balances"/>
      <date-chart v-if="viewPanel === 'horizontalBar'" v-bind:sumData="balances"/>
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
import BalanceTable from '@/components/BalanceTable'
import SumTable from '@/components/SumTable'
import AttributeBar from '@/components/AttributeBar'
import DateChart from '@/components/DateChart'
export default {
  name: 'Main',
  data () {
    return {
      balances: [],
      kinds: [],
      purposes: [],
      places: [],
      targetAttributeList: 'kind',
      viewPanel: 'balanceTable',
      queries: {
        moveIgnore: false,
        startDate: '',
        endDate: '',
        checkedKinds: [],
        checkedPurposes: [],
        checkedPlaces: [],
        groupByDate: 'none',
        groupByCollection: 'none'
      },
      chartData: {
        labels: ['January', 'February', 'March', 'April', 'May'],
        datasets: [
          {
            label: 'Sample1',
            data: [28, 20, 30, 40, 50],
            backgroundColor: [
              'rgba(255, 99, 132, 0.2)',
              'rgba(54, 162, 235, 0.2)',
              'rgba(255, 206, 86, 0.2)',
              'rgba(75, 192, 192, 0.2)',
              'rgba(153, 102, 255, 0.2)',
              'rgba(255, 159, 64, 0.2)'
            ],
            borderColor: [
              'rgba(255, 99, 132, 1)',
              'rgba(54, 162, 235, 1)',
              'rgba(255, 206, 86, 1)',
              'rgba(75, 192, 192, 1)',
              'rgba(153, 102, 255, 1)',
              'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
          }
        ]
      }
    }
  },
  methods: {
    getBalances: function () {
      if (this.doGroupBy) {
        axios
          .get('http://localhost:8080/api/v1/sum/?' + this.query + '&' + this.groupByQuery)
          .then(response => (this.balances = response.data))
      } else {
        axios
          .get('http://localhost:8080/api/v1/balance/?' + this.query)
          .then(response => (this.balances = response.data))
      }
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
      if (this.queries['checkedKinds'].length > 0) {
        query += '&' + this.queries['checkedKinds'].map(x => 'kind=' + x).join('&')
      }
      if (this.queries['checkedPurposes'].length > 0) {
        query += '&' + this.queries['checkedPurposes'].map(x => 'purpose=' + x).join('&')
      }
      if (this.queries['checkedPlaces'].length > 0) {
        query += '&' + this.queries['checkedPlaces'].map(x => 'place=' + x).join('&')
      }
      return query
    },
    groupByQuery: function () {
      var query = '2=2'
      if (this.queries['groupByDate'] !== 'none') {
        query += '&groupByDate=' + this.queries['groupByDate']
      }
      if (this.queries['groupByCollection'] !== 'none') {
        query += '&attributeName=' + this.queries['groupByCollection']
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
    },
    doGroupBy: function () {
      if (this.queries['groupByDate'] !== 'none' || this.queries['groupByCollection'] !== 'none') {
        return true
      }
      return false
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
    'balance-table': BalanceTable,
    'attribute-bar': AttributeBar,
    'date-chart': DateChart,
    'sum-table': SumTable
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
