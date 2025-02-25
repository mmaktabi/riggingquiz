import Image from "next/image";
import React from "react";

// Kategorie-Daten als Array, um Wiederholungen zu vermeiden
const categories = [
  {
    image: "/rigging/category_1.png",
    title: "Anschlagmittel",
    description:
      "Meistere die sichere Verbindung! Lerne alles über Schäkel, Stahlseile, Rundschlingen und Ketten – ihre Anwendung und Eignung. Teste dein Wissen und werde Profi-Anschläger!",
  },
  {
    image: "/rigging/category_2.png",
    title: "Traversen und Lastverteilung",
    description:
      "Meistere die Kunst der Lastverteilung! Hier lernst du alles über Traversen, Kräfteverteilung und deren Einsatz in der Veranstaltungstechnik. Teste dein Wissen und werde zum Experten für sichere Traversensysteme!",
  },
  {
    image: "/rigging/category_4.png",
    title: "Bühnenkinetik",
    description:
      "Perfekte Kontrolle über Bewegung! Hier lernst du alles über Hebezeuge, Kettenzüge und das sichere Bewegen von Lasten auf der Bühne. Teste dein Wissen und werde zum Experten für Bühnendynamik!",
  },
  {
    image: "/rigging/category_3.png",
    title: "Sicherheit und Vorschriften",
    description:
      "Sicherheit geht vor! Hier lernst du alles über elektrische Schutzmaßnahmen, Spannungsarten und Sicherheitsregeln in der Veranstaltungstechnik. Teste dein Wissen und werde zum Sicherheitsprofi!",
  },
];

// Wiederverwendbare Kategorie-Karte als separate Komponente
const CategoryCard = ({ image, title, description }) => (
    <div className="flex flex-col gap-3 shadow-Shadow2 rounded-xl p-6 h-full justify-between">
      <div className="flex gap-2 items-center">
        <Image src={image} width={100} height={100} alt={title} />
        <p className="text-[22px] font-semibold ">{title}</p>
      </div>
      <p className="text-[15px] ">{description}</p>
    </div>
  );
  
const Kategories = () => {
  return (
    <div className="font-body py-[80px] max-w-[1250px] mx-auto px-5 flex flex-col gap-10">
      <h1 className="text-[36px] font-bold">Rigging-Kategorien</h1>

      <div className="flex flex-col gap-[24px] lg:gap-0 md:flex-row">
        {/* Linke Spalte */}
        <div className="flex flex-col gap-[24px] flex-1 items-center justify-center">
          {categories.slice(0, 2).map((category, index) => (
            <CategoryCard key={index} {...category} />
          ))}
        </div>

        {/* Portrait-Bild in der Mitte */}
        <div className="px-10  lg:block w-[350px] h-[580px] relative">
  <Image
    src="/rigging/1-portrait.png"
    fill
    className="object-contain"
    alt="Rigging Portrait"
  />
</div>

        {/* Rechte Spalte */}
        <div className="flex flex-col gap-[24px] flex-1 items-center justify-center">
          {categories.slice(2, 4).map((category, index) => (
            <CategoryCard key={index} {...category} />
          ))}
        </div>
      </div>
    </div>
  );
};

export default Kategories;
