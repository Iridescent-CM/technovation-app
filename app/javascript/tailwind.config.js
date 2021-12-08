module.exports = {
  purge: [],
  darkMode: false,
  theme: {
    extend: {
      colors: {
        'energetic-blue': "#0075cf",
        'energetic-blue-600': { 600: '#0075cf' },
        'energetic-blue-light': '#539aef',
        'tg-green': '#43b02a',
        'tg-dark-green': '#3fa428',
        'tg-dark-blue': '#041E42',
        'tg-bright-blue': '#5bc2e7',
        'tg-gold': '#ffb81c',
        'tg-magenta': '#d0006f',
        'tg-orange': '#ff7500',
      },
      typography: {
        DEFAULT: {
          css: {
            a: {
              'text-decoration': 'none',
              '&:hover': {
                'text-decoration': 'underline'
              }
            }
          }
        }
      }
    }
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms')
  ],
}
