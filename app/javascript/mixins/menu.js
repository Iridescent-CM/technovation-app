export default {
  props: {
    regionalPitchEventsEnabled: {
      type: Boolean,
      required: false,
      default: false,
    },

    scoresAndCertificatesEnabled: {
      type: Boolean,
      required: false,
      default: false,
    },
  },

  methods: {
    subRouteIsActive(parentRouteId) {
      const parentRoute = this.$router.options.routes.find((parentRoute) => {
        if (Object.prototype.hasOwnProperty.call(parentRoute, 'children')) {
          return parentRoute.children.some((childRoute) => {
            return this.$route.name === childRoute.name
          })
        }

        return false
      })

      if (
        parentRoute &&
        Object.prototype.hasOwnProperty.call(parentRoute, 'meta') &&
        Object.prototype.hasOwnProperty.call(parentRoute.meta, 'routeId')
      ) {
        return parentRouteId === parentRoute.meta.routeId
      }

      return false
    },
  },
}