<template>
  <div id="main">
    <div id="search">
      <div id="dateRange">
        startDate: <input type="date" v-model="queries.startDate">
        endDate: <input type="date" v-model="queries.endDate">
      </div>
      <span>
        moveIgnore: <input type="checkbox" v-model="queries.moveIgnore">
      </span>
      <br/>
      <span>
        <input type="radio" value="none" v-model="queries.groupByDate">
        <label for="none">none</label>
        <input type="radio" value="day" v-model="queries.groupByDate">
        <label for="day">day</label>
        <input type="radio" value="week" v-model="queries.groupByDate">
        <label for="month">week</label>
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
      <button v-on:click="search">search</button>
    </div>
    <attribute-select-panel
      :attributesCollections="attributesCollections"
      :selectedAttributesElements="selectedAttributesElements"
      @changeCheckbox="changeCheckbox"
    />
    <div id="contents">
      <!-- router-link :to="{ path: 'Main', query: this.queries}">search</router-link -->
      <balance-table v-if="chartPanel === CHART_PANEL_NAME.BALANCE" v-bind:balances="balances"/>
      <sum-table v-if="chartPanel === CHART_PANEL_NAME.ATTRIBUTE" v-bind:sums="balances"/>
      <attribute-bar v-if="chartPanel === CHART_PANEL_NAME.ATTRIBUTE" v-bind:sumData="balances"/>
      <date-chart v-if="chartPanel === CHART_PANEL_NAME.DATE" v-bind:sumData="sumData" v-bind:isCumulative="true"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import BalanceTable from '@/components/BalanceTable'
import SumTable from '@/components/SumTable'
import AttributeBar from '@/components/AttributeBar'
import DateChart from '@/components/DateChart'
import AttributeSelectPanel from '@/components/AttributeSelectPanel'
export default {
  name: 'Main',
  data () {
    return {
      CHART_PANEL_NAME: {
        BALANCE: 'balance',
        ATTRIBUTE: 'attribute',
        DATE: 'date'
      },
      balances: [],
      sumData: {'label': [], 'data': []},
      kinds: [],
      purposes: [],
      places: [],
      viewPanel: 'none',
      queries: {
        moveIgnore: false,
        startDate: '',
        endDate: '',
        checkedKinds: [],
        checkedPurposes: [],
        checkedPlaces: [],
        groupByDate: 'none',
        groupByCollection: 'none'
      }
    }
  },
  methods: {
    search: function () {
      this.balances = []
      if (this.chartPanel === this.CHART_PANEL_NAME.DATE) {
        axios
          .get('http://localhost:8080/api/v1/chart/', {params: this.getQueryParams})
          .then(response => (this.sumData = response.data))
      } else if (this.chartPanel === this.CHART_PANEL_NAME.ATTRIBUTE) {
        axios
          .get('http://localhost:8080/api/v1/sum/', {params: this.getQueryParams})
          .then(response => (this.sumData = response.data))
      } else if (this.chartPanel === this.CHART_PANEL_NAME.BALANCE) {
        axios
          .get('http://localhost:8080/api/v1/balance/', {params: this.getQueryParams})
          .then(response => (this.balances = response.data))
      } else {
        // ここには来ない想定
      }
    },
    changeCheckbox: function (selectedAttributesElements) {
      this.queries.checkedKinds = selectedAttributesElements['kind']
      this.queries.checkedPurposes = selectedAttributesElements['purpose']
      this.queries.checkedPlaces = selectedAttributesElements['place']
    }
  },
  computed: {
    getQueryParams: function () {
      var query = {}

      if (this.queries['moveIgnore'] === true) {
        query['move'] = 'ignore'
      }

      if (this.queries['startDate'] !== '') {
        query['start'] = this.queries['startDate']
      }
      if (this.queries['endDate'] !== '') {
        query['end'] = this.queries['endDate']
      }

      query['kind'] = this.queries['checkedKinds']
      query['purpose'] = this.queries['checkedPurposes']
      query['place'] = this.queries['checkedPlaces']

      if (this.queries['groupByDate'] !== 'none') {
        query['groupByDate'] = this.queries['groupByDate']
      }

      if (this.queries['groupByCollection'] !== 'none') {
        query['attributeName'] = this.queries['groupByCollection']
      }

      return query
    },
    chartPanel: function () {
      if (this.queries['groupByDate'] !== 'none') {
        return this.CHART_PANEL_NAME.DATE
      }
      if (this.queries['groupByCollection'] !== 'none') {
        return this.CHART_PANEL_NAME.ATTRIBUTE
      }

      return this.CHART_PANEL_NAME.BALANCE
    },
    attributesCollections: function () {
      var kindCollections = {}
      kindCollections['attributeElements'] = this.kinds
      kindCollections['attributeCategories'] = []
      kindCollections['attributeGroups'] = []

      var purposeCollections = {}
      purposeCollections['attributeElements'] = this.purposes
      purposeCollections['attributeCategories'] = []
      purposeCollections['attributeGroups'] = []

      var placeCollections = {}
      placeCollections['attributeElements'] = this.places
      placeCollections['attributeCategories'] = []
      placeCollections['attributeGroups'] = []

      return {'kind': kindCollections, 'purpose': purposeCollections, 'place': placeCollections}
    },
    selectedAttributesElements: function () {
      var selected = {}

      selected['kind'] = this.queries.checkedKinds
      selected['purpose'] = this.queries.checkedPurposes
      selected['place'] = this.queries.checkedPlaces

      return selected
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
    'sum-table': SumTable,
    'attribute-select-panel': AttributeSelectPanel
  }
}
</script>

<style scoped>
#search {
  background-color: #6ABC6E;
}
#attribute {
  background-color: #6ABC6E;
}
#contents {
  float: left;
  width: 800px;
}
#attribute {
  float: left;
  width: 280px;
}
</style>
