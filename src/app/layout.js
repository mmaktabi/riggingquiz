import "@fortawesome/fontawesome-svg-core/styles.css"
import { config } from "@fortawesome/fontawesome-svg-core"
config.autoAddCss = false;
import "./globals.css";

import { Inter, Poppins } from 'next/font/google'

const inter = Inter({
  subsets: ['latin'],
  weight: ['100', '200', '300', '400', '500', '600', '700', '800', '900'], // All available weights
  variable:'--font-inter'
})

const poppins = Poppins({
  subsets: ['latin'],
  weight: ['100', '200', '300', '400', '500', '600', '700', '800', '900'], // All available weights
   variable:'--font-poppins'
})

export const metadata = {
  title: "RiggingQuiz - Teste dein Rigging-Wissen",
  description: "Das interaktive RiggingQuiz für Veranstaltungstechniker. Teste dein Wissen überall, jederzeit!",
  icons: {
    icon: "/favicon.ico", // Standard-Icon
    shortcut: "/favicon.ico", // Alternative für Browser
    apple: "/favicon.ico", // iOS-Unterstützung
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={`${inter.className} ${poppins.className}`}>
        {children}
        </body>
    </html>
  );
}
