import React from 'react';

const Footer = () => {
  return (
    <footer className="px-5 py-5">
      <div className="bg-[#01315E] max-w-[1250px] mx-auto px-5 md:px-10 py-10 rounded-lg flex flex-col ">
        
        {/* Kontakt & Links */}
        <div className="flex flex-col md:flex-row gap-5 justify-center text-center md:text-left items-center md:items-start">
          
          {/* Logo (Links) */}
          <div className="flex-shrink-0">
          <a href="/" className="text-[14px] font-semibold text-white hover:underline">
          <img src="/rigging/app_logo.png" width={200} height={200} alt="RiggingQuiz Logo" className="rounded-lg" />
          </a>
          </div>

          {/* Kontaktinformationen */}
          <div className="flex flex-col gap-6 px-20">
            
            {/* E-Mail */}
            <div>
              <div className="flex items-center gap-2 justify-center md:justify-start">
                <img src="/Mail.svg" alt="E-Mail Icon" />
                <span className="text-sm font-medium text-[#98A2B3]">E-Mail</span>
              </div>
              <a href="mailto:info@apex-riggingschule.de" className="text-[15px] font-semibold text-white hover:underline">
                info@apex-riggingschule.de
              </a>
            </div>

            {/* Kontaktformular */}
            <div>
              <div className="flex items-center gap-2 justify-center md:justify-start">
                <img src="/Leave.svg" alt="Kontakt Icon" />
                <span className="text-sm font-medium text-[#98A2B3]">Kontakt</span>
              </div>
              <a href="/support" className="text-[14px] font-semibold text-white hover:underline">
              Support
            </a>
            </div>
          </div>

          {/* Rechtliche Links */}
          <div className="flex flex-col gap-2">
            <a href="/" className="text-[14px] font-semibold text-white hover:underline">
              Home
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
    </footer>
  );
};

export default Footer;
