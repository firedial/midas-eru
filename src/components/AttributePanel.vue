<template>
  <div>
    <table>
      <tr>
        <th></th>
        <th>id</th>
        <th>name</th>
      </tr>
      <tr v-for="attributeElement in attributeCollections.attributeElements" :key="attributeElement.id">
        <td>
          <input type="checkbox" :value="attributeElement.id" :checked="isChecked(attributeElement.id)" @change="changeCheckbox(attributeElement.id)">
        </td>
        <td> {{ attributeElement.id }} </td>
        <td> {{ attributeElement.name }} </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'AttributePanel',
  props: ['attributeCollections', 'selectedAttributeElements'],
  methods: {
    changeCheckbox: function (id) {
      this.$emit('changeCheckbox', id)
    },
    isChecked: function (id) {
      return this.selectedAttributeElements.includes(id)
    }
  }

}
</script>
