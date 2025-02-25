'use client'
import React, { useState } from 'react'
import PlusIcon from "../../../public/PlusIcon.svg"
import CrossIcon from "../../../public/CrossIcon.svg"
import { FiPlus, FiMinus } from "react-icons/fi";

const FAQ = () => {
    const [ActiveIndex, setActiveIndex] = useState(null)

    const Faqs = [
        {
            key: 1,
            question: "Ist das Spiel kostenlos?",
            answer: "Ja, das RiggingQuiz ist komplett kostenlos! Wir testen es aktuell als Pilotprojekt, um Feedback zu sammeln und es weiter zu verbessern.",
        },
        {
            key: 2,
            question: "Wer erstellt die Fragen?",
            answer: "Unsere Fragen werden von professionellen Veranstaltungstechnikern erstellt, um praxisnahe und realistische Szenarien zu gewährleisten.",
        },
        {
            key: 3,
            question: "Auf welchen Geräten kann ich das Spiel spielen?",
            answer: "Das RiggingQuiz ist sowohl auf iPhone als auch auf Android-Geräten sowie direkt im Web spielbar.",
        },
    ]

    const Faqs2 = [
      
        {
            key: 4,
            question: "Gibt es Support oder Hilfe?",
            answer: "Falls du Fragen oder technische Probleme hast, kannst du uns jederzeit kontaktieren. Wir helfen dir gerne weiter!",
        },
        {
            key: 5,
            question: "Wird das Spiel weiterentwickelt?",
            answer: "Ja! Wir arbeiten ständig daran, das RiggingQuiz mit neuen Fragen, Funktionen und Verbesserungen zu erweitern.",
        },
        {
            key: 6,
            question: "Kann ich selbst Fragen vorschlagen?",
            answer: "Ja, wir freuen uns über Vorschläge! Falls du eine Idee für eine spannende Frage hast, kontaktiere uns gerne.",
        },
    ]
  return (
    <>
              <div className='my-20 flex flex-col gap-9 max-w-[1250px] mx-auto px-5 '>

<h1 className='text-5xl font-medium font-display'>FAQs</h1>

    <div className='flex flex-col lg:flex-row gap-0 lg:gap-5'>

    <div className='flex-1 flex flex-col gap-3 font-body md:gap-5'>

<div className='w-full h-[2px] bg-[#D0D5DD]'></div>

{
Faqs.map((ele, index) => (
   <div key={index}>
       <div  className='transition py-3  rounded-xl flex flex-col justify-center  overflow-hidden'>
           <div className='flex justify-between items-center  cursor-pointer my-[13px] h-[84px]' onClick={() => { setActiveIndex(ActiveIndex == ele.key ? null : ele.key) }}>
               
               <h1 className="text-[20px] font-medium">{ele.question}</h1>

               <span className="text-2xl">
               {ActiveIndex === ele.key ? <FiMinus className="text-2xl" /> : <FiPlus className="text-2xl" />}
               </span>
           </div>


           <div
               className={`transition-all duration-300 ease-in-out overflow-hidden ${ActiveIndex === ele.key ? 'max-h-[1000px] ' : 'max-h-[0px] '}`}
           >
               <p className='text-[14px] font-light'>{ele.answer}</p>

               <p 
               className='text-[14px] font-light'

               dangerouslySetInnerHTML={{ __html: ele.answer2 }} />

           </div>

       </div>

       <div className='w-full h-[2px] bg-[#D0D5DD]'></div>
   </div>

))
}



</div>



<div className='flex-1 flex flex-col gap-3 font-body  md:gap-5'>

<div className='hidden lg:block w-full h-[2px] bg-[#D0D5DD]'></div>

{
Faqs2.map((ele, index) => (
   <div>

       <div key={index} className=' transition py-3  rounded-xl flex flex-col justify-center  overflow-hidden'>
           <div className='flex justify-between items-center  cursor-pointer my-[13px] h-[84px]' onClick={() => { setActiveIndex(ActiveIndex == ele.key ? null : ele.key) }}>
               <h1 className="text-[20px] font-medium">{ele.question}</h1>
               {ActiveIndex === ele.key ? <FiMinus className="text-2xl" /> : <FiPlus className="text-2xl" />}

           </div>


           <div
               className={`transition-all duration-300 ease-in-out overflow-hidden ${ActiveIndex === ele.key ? 'max-h-[1000px] ' : 'max-h-[0px] '}`}
           >
               <p className='text-[14px] font-light'>{ele.answer}</p>

   

               <p 
               className='text-[14px] font-light'

               dangerouslySetInnerHTML={{ __html: ele.answer2 }} />
           </div>

       </div>

       <div className='w-full h-[2px] bg-[#D0D5DD]'></div>
   </div>

))
}



</div>


          
    </div>


</div>
    </>
  )
}

export default FAQ
