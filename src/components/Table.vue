<template>
  <div class="hello">
    <table>
      <tr>
        <th>balance_id</th>
        <th>amount</th>
        <th>item</th>
        <th>kind_id</th>
        <th>purpose_id</th>
        <th>place_id</th>
        <th>date</th>
      </tr>
      <tr v-for="balance in balances" v-bind:key="balance.balance_id">
        <td> {{ balance.balance_id }} </td>
        <td> {{ balance.amount }} </td>
        <td> {{ balance.item }} </td>
        <td> {{ balance.kind_id }} </td>
        <td> {{ balance.purpose_id }} </td>
        <td> {{ balance.place_id }} </td>
        <td> {{ balance.date }} </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'Table',
  props: ['balances']
}
</script>
