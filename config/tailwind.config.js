const defaultTheme = require('tailwindcss/defaultTheme')
const path = require('path')

module.exports = {
  content: [
    './app/views/**/*.{erb,haml,html,slim}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,haml,html,slim}',
    './app/assets/stylesheets/**/*.css'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', require('tailwindcss/defaultTheme').fontFamily.sans],
      },
    },
  },
  plugins: [
    // Remove the backdrop-filter plugin since we're using built-in utilities
  ]
}
