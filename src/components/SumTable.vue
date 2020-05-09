<template>
  <div class="hello">
    <span>sum: {{ amountSum }}</span>
    <table>
      <tr>
        <th>id</th>
        <th>attribute</th>
        <th>amount</th>
        <th>date</th>
      </tr>
      <tr v-for="sum in sums" v-bind:key="sum.id">
        <td> {{ sum.id }} </td>
        <td> {{ sum.attribute_id }} </td>
        <td> {{ sum.amount_sum }} </td>
        <td> {{ sum.date }} </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'SumTable',
  props: ['sums'],
  computed: {
    amountSum: function () {
      return this.sums.map(x => x.amount_sum).reduce((a, b) => a + b, 0)
    }
  }
}
</script>
