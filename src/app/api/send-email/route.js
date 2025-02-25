import { NextResponse } from "next/server";
import nodemailer from "nodemailer";

export async function POST(req) {
  try {
    const { name, email, message } = await req.json();

    if (!name || !email || !message) {
      return NextResponse.json({ error: "Alle Felder sind erforderlich!" }, { status: 400 });
    }

    // SMTP-Transporter für United Domains
    const transporter = nodemailer.createTransport({
      host: "smtp.udag.de", // United Domains SMTP-Server
      port: 587, // TLS Port
      secure: false, // false für STARTTLS, true für SSL (Port 465)
      auth: {
        user: process.env.EMAIL_USER, // E-Mail-Adresse
        pass: process.env.EMAIL_PASS, // Passwort
      },
      tls: {
        rejectUnauthorized: false, // Falls SSL/TLS Probleme auftreten
      },
    });

    // E-Mail an dich
    await transporter.sendMail({
      from: "support@apex-riggingschule.de",
      to: "info@mmaktabi.com", // Deine Adresse
      subject: "RiggingQuiz - Neue Support-Anfrage",
      text: `Eine Neue Support-Anfrage in RiggingQuiz\n\nName: ${name}\nE-Mail: ${email}\n\nNachricht:\n${message}`,
      cc: "info@apex-riggingschule.de"
    });

    // Bestätigungsmail an den Nutzer
    await transporter.sendMail({
      from: "support@apex-riggingschule.de",
      to: email,
      subject: "RiggingQuiz - Bestätigung deiner Anfrage",
      text: `Hallo ${name},\n\nWir haben deine Anfrage erhalten und melden uns bald.\n\nDeine Nachricht:\n${message}\n\nViele Grüße,\nDein Support-Team\nRiggingQuiz`,
    });

    return NextResponse.json({ message: "E-Mail erfolgreich gesendet!" }, { status: 200 });
  } catch (error) {
    console.error("Fehler beim Senden der E-Mail:", error);
    return NextResponse.json({ error: "Fehler beim Senden der E-Mail." }, { status: 500 });
  }
}
