import "@fortawesome/fontawesome-svg-core/styles.css"
import { config } from "@fortawesome/fontawesome-svg-core"
config.autoAddCss = false;
import "./globals.css";

import { Inter, Poppins } from 'next/font/google'
import Head from "next/head";

const inter = Inter({
  subsets: ['latin'],
  weight: ['100', '200', '300', '400', '500', '600', '700', '800', '900'], // All available weights
  variable: '--font-inter'
})

const poppins = Poppins({
  subsets: ['latin'],
  weight: ['100', '200', '300', '400', '500', '600', '700', '800', '900'], // All available weights
  variable: '--font-poppins'
})
export const metadata = {
  title: "RiggingQuiz",
  description: "RiggingQuiz - Dein Rigging Wissen erweitern, auffrischen, oder auf die Probe stellen. Das interaktive RiggingQuiz für Veranstaltungstechniker. Teste dein Wissen überall, jederzeit!",
  icons: {
    icon: "/favicon.ico",
    shortcut: "/favicon.ico",
    apple: "/favicon.ico",// iOS-Unterstützung
  },

  keywords: [
    // Kernbegriffe Apex Riggingschule
    "Apex Riggingschule",
    "Riggingschule Deutschland",
    "Professionelle Riggingausbildung",

    // Sachkunde und Zertifizierungen
    "Sachkunde Veranstaltungs-Rigging",
    "Sachkunde Anschlagmittel Veranstaltungstechnik",
    "Sachkunde Traversensysteme",
    "PSA Sachkunde Absturzschutz",
    "Prüfung PSA gegen Absturz",
    "Zertifizierter Rettungsrigger",

    // Technische Fachbereiche
    "Elektrokettenzüge Veranstaltungstechnik",
    "Statik für Rigging",
    "Grundlagen Statik Veranstaltungstechnik",
    "CAD Planung Rigging",
    "Traversenkonstruktion",
    "Lastberechnung Rigging",

    // Sicherheits- und Rettungsthemen
    "Persönliche Schutzausrüstung Absturz",
    "PSA Anwender Rettung",
    "Sicherheitskonzepte Rigging",
    "Arbeitssicherheit Veranstaltungstechnik",
    "Erste Hilfe Rigging",

    // Equipment und Bedienung
    "Sicheres Bedienen Arbeitsbühnen",
    "Hebezeuge Veranstaltungstechnik",
    "Rigging-Hardware",
    "Anschlagtechniken",

    // Elektrotechnik und Zusatzbereiche
    "Elektrotechnik für Veranstaltungen",
    "Bühnenbeleuchtung Rigging",
    "Stromversorgung Events",

    // Ausbildung und Weiterbildung
    "Riggingkurse Deutschland",
    "Riggingseminare praxisnah",
    "Riggingausbildung zertifiziert",
    "Riggingweiterbildung",
    "Riggingfortbildung",
    "Workshops Veranstaltungs-Rigging",
    "Rigging Schulungen",

    // Zielgruppen und Anwendung
    "Veranstaltungstechniker Ausbildung",
    "Bühnentechnik Rigging",
    "Eventrigging Schulung",
    "Rigging für Konzerte",
    "Theaterrigging Kurs",

    // Allgemeine Begriffe
    "Rigging Know-how",
    "Veranstaltungssicherheit",
    "Professionelles Rigging",
    "Rigging Standards",
    "Rigging Zertifikate",
    "Veranstaltungstechnik Quiz",
    "Quiz Veranstaltungstechnik",

  ],
};

export default function RootLayout({ children }) {
  return (
    <html lang="de">

      <body className={`${inter.className} ${poppins.className}`} suppressHydrationWarning={true}>
        {children}
      </body>
    </html>
  );
}
