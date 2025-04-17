import Footer from "@/components/custom/footer";

export default function Impressum() {
  return (
    <main >
      <div className=" pt-20 pb-20 mx-auto px-5 md:px-20 py-10">
      <h1 className="text-3xl font-bold pt-20 mb-4">Impressum</h1>
        <p className="mb-2"><strong>Sabine Hößel</strong></p>
        <p className="mb-2">Schweinfurter Straße 28, D-97076 Würzburg</p>
        <p className="mb-2">Telefon: 0931 45 28 67 10</p>
        <p className="mb-4">E-Mail: info@apex-riggingschule.de</p>

        <h2 className="text-2xl font-semibold mt-6 mb-2">Vertretungsberechtigte</h2>
        <p>Sabine Hößel (Geschäftsführer)</p>

        <h2 className="text-2xl font-semibold mt-6 mb-2">Zuständige Kammer</h2>
        <p>IHK Würzburg D</p>

        <h2 className="text-2xl font-semibold mt-6 mb-2">Umsatzsteuer-ID</h2>
        <p>DE 229 476 820</p>

        <h2 className="text-2xl font-semibold mt-6 mb-2">Haftungsausschluss</h2>
        <p>
          Trotz sorgfältiger inhaltlicher Kontrolle übernehmen wir keine Haftung für die Inhalte
          externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.
        </p>
        <br />
        <hr />
        <h2 className="text-2xl font-bold  mt-6 mb-2">Entwicklung und Design</h2>
        <p className="text-1xl font-semibold ">Moheeb Maktabi</p>
        <a href="mailto:info@mmaktabi.com" className="text-1xl font-semibold ">info@mmaktabi.com</a>

      </div>
      <Footer />

    </main>
  );
}
