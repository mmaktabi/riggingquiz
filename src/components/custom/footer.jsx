import React from 'react';

const Footer = () => {
  return (
    <footer>
      <div className="bg-[#01315E] mx-auto px-5 md:px-20 py-10">
        {/* Haupt-Container: nebeneinander auf md+ */}
        <div className="flex flex-col md:flex-row justify-between items-center md:items-start text-center md:text-left">

          {/* Logo ganz links */}
          <div className="mb-10 md:mb-0">
            <a href="/" className="text-[14px] font-semibold text-white hover:underline">
              <img src="/rigging/app_logo.png" width={200} height={200} alt="RiggingQuiz Logo" className="rounded-lg" />
            </a>
          </div>

          {/* Rechte Seite: Kontakt & rechtliche Links nebeneinander */}
          <div className="flex flex-col md:flex-row gap-12 md:gap-24 items-center md:items-start">

    

            {/* Rechtliche Links */}
            <div className="flex flex-col gap-2 md:px-20">
            <a href="/" className="text-[14px] font-semibold text-white hover:underline">
                Home
              </a>
              <a href="/support" className="text-[14px] font-semibold text-white hover:underline">
                Kontaktformular
              </a>
         
              <a href="/impressum" className="text-[14px] font-semibold text-white hover:underline">
                Impressum
              </a>
              <a href="/datenschutz" className="text-[14px] font-semibold text-white hover:underline">
                Datenschutzerklärung
              </a>
            </div>

          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
