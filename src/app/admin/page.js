"use client";

export default function Admin() {
    return (
        <main className="w-full h-screen flex">
            <iframe
                src="https://rigging-c0661.web.app/admin"
                className="w-full h-full border-none"
                allow="
                fullscreen; 
                clipboard-read; 
                clipboard-write; 
                web-share; 
                camera; 
                microphone; 
                geolocation; 
                payment"
                title="Flutter App"
            />
        </main>
    );
}
