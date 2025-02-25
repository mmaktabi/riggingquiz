import React from 'react'

const MotivationSection = () => {
  return (
    <>
      <section className='bg-custom-gradient font-body'>
        <div className='flex flex-col items-center md:items-start max-w-[1250px] mx-auto px-5 py-20 text-center md:text-left'>

          {/* Motivationstext */}
          <div className='text-white flex flex-col gap-4'>
            <h1 className='text-[36px] font-bold'>
              Bist du bereit, dein Wissen im Bereich Rigging zu testen?
            </h1>

            <p className='text-[18px] font-medium leading-relaxed'>
              Stell dich der Herausforderung und teste dein Können im interaktiven <strong>RiggingQuiz</strong>! Ob Anfänger oder Profi –
              hier kannst du dein Wissen spielerisch erweitern und deine Fähigkeiten perfektionieren.
              Fordere dich selbst heraus, sammle Punkte und entwickle deine Fachkompetenz als <span className='text-yellow-500 font-bold'>Rigger</span> gezielt weiter.
              <br />
              <br />

              Das Quiz orientiert sich an den Ausbildungsstufen des Sachkundigen für Veranstaltungsrigging SQQ2 und kann zur Vertiefung des Fachwissens vom Level 1 bis hin zum Level 3 der Qualifikation beitragen.

              <br />
              <br />

              Das Quiz ersetzt nicht die Ausbildung durch einen qualifizierten Bildungsträger. Es dient vielmehr als ergänzende Lernhilfe, um das Fachwissen zu vertiefen und die theoretischen Grundlagen zu festigen. Die Plattform versteht sich als unterstützendes Werkzeug, das den Lernprozess begleitet, jedoch keine offizielle Qualifikation oder praktische Erfahrung ersetzt.

            </p>
          </div>

          {/* Button zum Spiel */}
          <div className='mt-6 flex w-full justify-end'>
            <a
              href="/spiel"
              className='bg-gradient-to-r from-yellow-300 to-yellow-500 text-[#01315E] font-bold px-8 py-4 rounded-xl shadow-lg hover:scale-105 transition-all duration-300'>
              Jetzt spielen 🎮
            </a>
          </div>

        </div>
      </section>
    </>
  )
}

export default MotivationSection
