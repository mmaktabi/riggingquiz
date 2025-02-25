/** @type {import('tailwindcss').Config} */
import {fontFamily} from 'tailwindcss/defaultTheme'
module.exports = {
  darkMode: ["class"],
  content: [
    './pages/**/*.{js,jsx}',
    './components/**/*.{js,jsx}',
    './app/**/*.{js,jsx}',
    './src/**/*.{js,jsx}',
  ],
  prefix: "",
  theme: {
    extend: {
      boxShadow:{
        'Form-Shadow':'0px 0px 11px 5px rgb(0 0 0 / 0.1)',
        'Shadow2' : '0px 0px 17px 0px rgb(0 0 0 / 0.1)'
      },
      fontFamily: {
        'display': ["var(--font-poppins)", ...fontFamily.sans],
        'body': ["var(--font-inter)", ...fontFamily.sans]
      },
      backgroundImage: {
        'custom-gradient': 'linear-gradient(90deg, #01315E 0%, #7CA546 100%)',
      },
    }, 
  },
  plugins: [require("tailwindcss-animate")],
}