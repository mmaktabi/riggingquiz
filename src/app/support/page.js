"use client";

import { useState } from "react";
import Footer from "@/components/custom/footer";
import Link from "next/link";

export default function Support() {
  const [formData, setFormData] = useState({ name: "", email: "", message: "" });
  const [status, setStatus] = useState("");

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setStatus("Sende...");

    const response = await fetch("/api/send-email", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formData),
    });

    if (response.ok) {
      setStatus("Deine Nachricht wurde gesendet!");
      setFormData({ name: "", email: "", message: "" });
    } else {
      setStatus("Fehler beim Senden. Bitte versuche es erneut.");
    }
  };

  return (
    <main>
      <div className="max-w-3xl mx-auto pt-20 pb-20">
        <h1 className="text-3xl font-bold mb-4">Support</h1>
        <p className="mb-6">
          Viele Fragen beantworten wir bereits in unseren 
          <Link href="/" className="text-blue-600 hover:underline"> FAQs&nbsp;</Link> 
          (ganz unten auf der Startseite). Falls du dort keine Antwort findest, nutze das Formular unten.
        </p>

        {/* Formular */}
        <form onSubmit={handleSubmit} className="bg-gray-100 p-6 rounded-lg shadow-md">
          <label className="block mb-2 font-semibold">Name</label>
          <input
            type="text"
            name="name"
            value={formData.name}
            onChange={handleChange}
            required
            className="w-full p-2 border border-gray-300 rounded-md mb-4"
          />

          <label className="block mb-2 font-semibold">E-Mail</label>
          <input
            type="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            required
            className="w-full p-2 border border-gray-300 rounded-md mb-4"
          />

          <label className="block mb-2 font-semibold">Nachricht</label>
          <textarea
            name="message"
            value={formData.message}
            onChange={handleChange}
            required
            rows="5"
            className="w-full p-2 border border-gray-300 rounded-md mb-4"
          ></textarea>

          <button type="submit" 
              className='bg-gradient-to-r from-yellow-300 to-yellow-500 text-[#01315E] font-bold px-8 py-4 rounded-xl shadow-lg hover:scale-105 transition-all duration-300'>
            Nachricht senden
          </button>

          {status && <p className="mt-3 text-center text-sm text-gray-700">{status}</p>}
        </form>
      </div>

      <Footer />
    </main>
  );
}
