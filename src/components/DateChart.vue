<script>
import { Line } from 'vue-chartjs'

export default {
  extends: Line,
  name: 'chart',
  props: ['sumData'],
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
            data: this.sumData.map(x => x['amount_sum']),
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
  mounted () {
    this.renderChart(this.data, this.options)
  }
}
</script>

<style>
</style>
