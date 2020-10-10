<template>
  <div>
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
      } else if (this.selectedAttributeName === 'purpsoe') {
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
