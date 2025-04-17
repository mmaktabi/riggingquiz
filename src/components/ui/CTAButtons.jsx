"use client"

import Image from "next/image";
import { useState } from "react";
import { Globe } from "lucide-react"; // Für das Browser-Icon

export default function CTAButtons() {
  const [showPopup, setShowPopup] = useState(false);
  const [popupMessage, setPopupMessage] = useState("");

  const handleStoreClick = (message) => {
    setPopupMessage(message);
    setShowPopup(true);
    setTimeout(() => setShowPopup(false), 3000); // Popup nach 3 Sekunden ausblenden
  };

  return (
    <div className="flex flex-col  gap-4 mt-4 ">
      {/* App Store & Google Play */}
      <div className="flex flex-col md:flex-row gap-4 items-center">
        <a onClick={() => {
          handleStoreClick("Du wirst zum App Store weitergeleitet...");
          window.open("https://apps.apple.com/de/app/riggingquiz/id6740346534", "_blank");
        }}>
          <Image src="/rigging/app_store.svg" width={200} height={154} alt="Apple Store Logo" className="cursor-pointer" />
        </a>
        <a onClick={() => {
          handleStoreClick("Du wirst zum App Store weitergeleitet...");
          window.open("https://play.google.com/store/apps/details?id=com.riggingschule.riggingquiz", "_blank");
        }}>
          <Image src="/rigging/google_store.png" width={222} height={164} alt="Google Play Logo" className="cursor-pointer" />
        </a>
      </div>

      {/* Trennlinie mit ODER */}
      <div className="flex items-center w-full max-w-[440px] my-4">
        <div className="flex-grow border-t border-gray-400"></div>
        <span className="px-4 text-gray-600 font-semibold">ODER</span>
        <div className="flex-grow border-t border-gray-400"></div>
      </div>

      {/* Jetzt im Browser spielen */}
      <a
        href="/spiel"
        className="bg-black text-white font-semibold py-3 px-6 rounded-lg shadow-lg flex items-center justify-center w-full max-w-[440px] hover:bg-gray-800 transition"
      >
        <Globe className="w-5 h-5 mr-2" /> Jetzt im Browser spielen
      </a>

      {/* Popup für Store Verfügbarkeit */}
      {showPopup && (
        <div className="fixed bottom-10 left-1/2 transform -translate-x-1/2 bg-black text-white px-4 py-2 rounded-md shadow-lg">
          {popupMessage}
        </div>
      )}
    </div>
  );
}
