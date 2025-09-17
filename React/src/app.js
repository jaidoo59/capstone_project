import React, { useState } from 'react';
import './app.css';
import TextInput from './components/textinput';
import VoiceSelector from './components/Voiceselector';
import AudioPlayer from './components/audioplayer';

function App() {
  const [text, setText] = useState('');
  const [voice, setVoice] = useState('Abigail');
  const [audioUrl, setAudioUrl] = useState('');

  const handleSynthesize = async () => {
    if (!text.trim()) {
      alert("Please enter text");
      return;
    }

    try {
      const res = await fetch("https://YOUR_API_GATEWAY_URL/synthesize", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text, voice })
      });

      if (!res.ok) throw new Error("API error");

      const data = await res.json();
      setAudioUrl(data.url);
    } catch (err) {
      console.error(err);
      alert("Failed to synthesize speech");
    }
  };

  return (
    <div className="bg-[#607D8B] flex items-center justify-center min-h-screen">
      <div className="w-full max-w-lg bg-blue-50 p-6 rounded-2xl shadow-lg">
        <h1 className="text-2xl font-bold mb-4 text-center">Text to Speech</h1>
        <h6 className="text-2xl font-bold mb-4 text-center">Jonathan's Translation Site</h6>
        
        <TextInput text={text} setText={setText} />
        <VoiceSelector voice={voice} setVoice={setVoice} />
        
        <button 
          onClick={handleSynthesize}
          className="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700"
        >
          Convert to Speech
        </button>

        <AudioPlayer audioUrl={audioUrl} />
      </div>
    </div>
  );
}

export default App;