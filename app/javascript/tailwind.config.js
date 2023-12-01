module.exports = {
  content: [
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.{js,vue}",
    "./app/views/**/*",
  ],
  theme: {
    extend: {
      borderRadius: {
        "4xl": "2.5rem;",
      },
      colors: {
        "energetic-blue": "#0075cf",
        "energetic-blue-600": { 600: "#0075cf" },
        "energetic-blue-light": "#539aef",
        "tg-green": "#43b02a",
        "tg-dark-green": "#3fa428",
        "tg-dark-blue": "#041E42",
        "tg-bright-blue": "#5bc2e7",
        "tg-gold": "#ffb81c",
        "tg-dark-gold": "#e5a51b",
        "tg-magenta": "#d0006f",
        "tg-orange": "#ff7500",
        success: "#DFF2BF",
        "success-txt": "#4F8A10",
        alert: "#FFBABA",
        "alert-txt": "#D8000C",
      },
      height: {
        "fit-content": "fit-content",
      },
      typography: {
        DEFAULT: {
          css: {
            a: {
              "text-decoration": "none",
              "&:hover": {
                "text-decoration": "underline",
              },
            },
          },
        },
      },
      fontFamily: {
        rubik: ["Rubik", "sans-serif"],
      },
    },
  },
  plugins: [require("@tailwindcss/typography"), require("@tailwindcss/forms")],
};
