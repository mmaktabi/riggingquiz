import Kategories from "@/components/custom/kategories";
import MotivationSection from "@/components/custom/motivationsection";
import FAQ from "@/components/custom/faq";
import Footer from "@/components/custom/footer";
import CTAButtons from "@/components/ui/CTAButtons";
import Image from "next/image";
import CookieBanner from "@/components/custom/cookie-banner";

export default function Home() {
  return (
    <>
    <CookieBanner />

      <section className="font-body">

        {/* Hero Section */}
        <div className="max-w-[1540px] mx-auto relative overflow-hidden">
        <div className="hidden md:block py-7">
</div>


          <div className="flex flex-col w-full md:flex-row justify-between items-center max-w-[1250px] mx-auto py-10 md:py-20 px-5 md:px-0">
            {/* Bild-Bereich */}
            <div className="w-full md:w-1/2 flex justify-center md:justify-center ">

              <Image
                src="/rigging/app_logo.png"
                width={520} // Stelle sicher, dass das die Originalgröße ist
                height={250}
                className=" lg:block w-auto max-w-[520px] h-auto"
                alt="RiggingQuiz Logo"
                priority // Priorisiert das Laden für bessere Performance
              />

            </div>

            {/* Text-Bereich */}
            <div className="w-full md:w-1/2 flex flex-col gap-5 text-center md:text-left">
              <h1 className="text-[27px] md:text-[39px] font-semibold leading-tight">
                <span className="font-extrabold text-[#01315E]">
                Dein Rigging Wissen erweitern, auffrischen, oder auf die Probe stellen. 
                </span>{" "}
              </h1>
              
              <p className="text-lg">
                Lernen war noch nie so{" "}
                <span className="font-bold text-yellow-600">
                  spannend, praxisnah und interaktiv!
                </span>{" "}
                Perfekt für angehende und erfahrene Rigger, die ihr Wissen spielerisch erweitern möchten.{" "}
   
              </p>

              {/* CTA-Buttons eingebunden */}
              <CTAButtons />
            </div>
          </div>
        </div>
      </section>

      {/* Weitere Abschnitte */}
      <MotivationSection />
      <Kategories />
      <FAQ />
      <Footer />
    </>
  );
}
