'use client'
import Image from 'next/image'
import React from 'react'

const Header = () => {
    return (
        <header className='px-0 mx-auto right-0 left-0 top-0  z-40'>
            <nav className='flex justify-between items-center bg-white shadow-sm py-2 pr-8 pl-8'>
             
   <div className="w-full md:w-1/2 flex justify-center md:justify-start mb-10 md:mb-0">
       
            </div>
                
                   <div className="flex flex-col md:flex-row gap-4 mt-4 items-center md:items-start">
                        
                                <a href="https://play.google.com" className='text-sm font-medium text-[#101828] w-fit border-b-2 border-white cursor-pointer hover:border-black'>
                                Im Browser spielen                               
                                 </a>
                             
                              </div>
            </nav>
        </header>
    )
}

export default Header
