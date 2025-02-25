"use client";
import { useState, useEffect } from "react";
import Cookie from "js-cookie";

export default function CookieBanner() {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const cookieConsent = Cookie.get("cookieConsent");
    if (!cookieConsent) {
      setIsVisible(true);
    }
  }, []);

  const acceptCookies = () => {
    Cookie.set("cookieConsent", "true", { expires: 365 }); // Zustimmung speichern
    setIsVisible(false);
  };

  const declineCookies = () => {
    Cookie.set("cookieConsent", "false", { expires: 365 }); // Ablehnung speichern
    setIsVisible(false);
  };

  if (!isVisible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-gray-900 text-white p-4 text-center z-50 shadow-md">
      <p className="mb-2">
        Diese Website verwendet Cookies, um Ihr Erlebnis zu verbessern. Mehr Informationen in unserer{" "}
        <a href="/datenschutz" className="underline text-yellow-400">
          Datenschutzerklärung
        </a>.
      </p>
      <div className="flex justify-center gap-4">
        <button
          onClick={acceptCookies}
          className="bg-yellow-500 hover:bg-yellow-600 text-black font-bold py-2 px-4 rounded"
        >
          Akzeptieren
        </button>
        <button
          onClick={declineCookies}
          className="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded"
        >
          Ablehnen
        </button>
      </div>
    </div>
  );
}
