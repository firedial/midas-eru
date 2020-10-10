<template>
  <div>
    <input type="radio" value="kind" v-model="selectedAttributeName">
    <label for="kind">kind</label>
    <input type="radio" value="purpose" v-model="selectedAttributeName">
    <label for="purpose">purpose</label>
    <input type="radio" value="place" v-model="selectedAttributeName">
    <label for="place">place</label>
    <attribute-panel
      :attributeCollections="getAttributeCollections"
      :selectedAttributeElements="getSelectedAttributeElements"
      @changeCheckbox="changeCheckbox"
    />
  </div>
</template>

<script>
import AttributePanel from '@/components/AttributePanel'
export default {
  name: 'AttributeSelectPanel',
  props: ['attributesCollections', 'selectedAttributesElements'],
  data () {
    return {
      selectedAttributeName: 'kind'
    }
  },
  components: {
    'attribute-panel': AttributePanel
  },
  computed: {
    getAttributeCollections: function () {
      return this.attributesCollections[this.selectedAttributeName]
    },
    getSelectedAttributeElements: function () {
      return this.selectedAttributesElements[this.selectedAttributeName]
    }
  },
  methods: {
    changeCheckbox: function (id) {
      var selected = {}

      if (this.selectedAttributeName === 'kind') {
        selected['kind'] = this.changeSelected(this.selectedAttributesElements['kind'], id)
        selected['purpose'] = this.selectedAttributesElements['purpose']
        selected['place'] = this.selectedAttributesElements['place']
      } else if (this.selectedAttributeName === 'purpose') {
        selected['kind'] = this.selectedAttributesElements['kind']
        selected['purpose'] = this.changeSelected(this.selectedAttributesElements['purpose'], id)
        selected['place'] = this.selectedAttributesElements['place']
      } else if (this.selectedAttributeName === 'place') {
        selected['kind'] = this.selectedAttributesElements['kind']
        selected['purpose'] = this.selectedAttributesElements['purpose']
        selected['place'] = this.changeSelected(this.selectedAttributesElements['place'], id)
      }

      this.$emit('changeCheckbox', selected)
    },
    changeSelected: function (selectedAttributeElements, id) {
      var hasId = false
      var l = selectedAttributeElements.length
      var r = []

      for (var i = 0; i < l; i++) {
        if (selectedAttributeElements[i] !== id) {
          r.push(selectedAttributeElements[i])
        } else {
          hasId = true
        }
      }
      if (!hasId) {
        r.push(id)
      }

      return r
    }
  }
}
</script>
