<template>
  <div>
    <attribute-panel
      :attributeCollections="attributesCollections['kind']"
      :selectedAttributeElements="selectedAttributesElements['kind']"
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
  }
}
</script>
