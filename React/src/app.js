import React, { useState } from 'react';
import './app.css';
import { API_CONFIG } from './config';
import TextInput from './components/textinput';
import VoiceSelector from './components/Voiceselector';
import AudioPlayer from './components/audioplayer';

function App() {
  const [text, setText] = useState('');
  const [voice, setVoice] = useState('Joanna');
  const [audioUrl, setAudioUrl] = useState('');

  const handleSynthesize = async () => {
    if (!text.trim()) {
      alert("Please enter text");
      return;
    }

    try {
      const res = await fetch(`${API_CONFIG.API_GATEWAY_URL}/convert`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text, voice })
      });

      if (!res.ok) throw new Error("API error");

      const data = await res.json();
      setAudioUrl(data.url || data.data?.audioUrl);
    } catch (err) {
      console.error(err);
      alert("Failed to synthesize speech");
    }
  };

  return (
    <div className="container">
      <h1 className="title">Text to Speech</h1>
      <h6 className="subtitle">Jonathan's Translation Site</h6>
      
      <TextInput text={text} setText={setText} />
      <VoiceSelector voice={voice} setVoice={setVoice} />
      
      <button 
        onClick={handleSynthesize}
        className="btn-primary"
      >
        Convert to Speech
      </button>

      <AudioPlayer audioUrl={audioUrl} />
    </div>
  );
}

export default App;