<script>
import { Line } from 'vue-chartjs'

export default {
  extends: Line,
  name: 'chart',
  props: ['sumData', 'isCumulative'],
  data () {
    return {
      options: {
        scales: {
          xAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'Month'
            }
          }]
        }
      }
    }
  },
  computed: {
    data: function () {
      return {
        labels: this.sumData.map(x => x['date']),
        datasets: [
          {
            label: 'Bar Dataset',
            data: this.doCumulate(),
            borderWidth: 1
          }
        ]
      }
    }
  },
  watch: {
    data: function () {
      this.renderChart(this.data, this.options)
    }
  },
  methods: {
    doCumulate: function () {
      if (this.isCumulative === false) {
        return this.sumData.map(x => x['amount_sum'])
      }

      let len = this.sumData.length
      let sum = 0
      let s = []
      for (let i = 0; i < len; i++) {
        sum += this.sumData[i]['amount_sum']
        s.push(sum)
      }

      return s
    }
  },
  mounted () {
    this.renderChart(this.data, this.options)
  }
}
</script>

<style>
</style>
