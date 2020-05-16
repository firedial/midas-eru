<script>
import { HorizontalBar } from 'vue-chartjs'

export default {
  extends: HorizontalBar,
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
        labels: this.sumData.map(x => x['attribute_id']),
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
