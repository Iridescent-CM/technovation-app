<script>
  export default {
    props: {
      section: {
        type: String,
        default: '',
      }
    },

    data () {
      return {
        mutableSection: '',
      }
    },

    created () {
      this.setSection(this.section)
    },

    methods: {
      isSection (section) {
        return this.mutableSection === section
      },

      setSection (section) {
        this.mutableSection = section
        history.replaceState(history.state, '', `#!${this.mutableSection}`)
      },
    }
  }
</script>