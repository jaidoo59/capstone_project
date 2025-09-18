import React from 'react';

function AudioPlayer({ audioUrl }) {
  return (
    <div className="audio-section">
      <h2 className="audio-title">Your Audio:</h2>
      <audio 
        src={audioUrl} 
        controls 
        className="audio-player"
      />
      <a
        href={audioUrl || "#"}
        download="speech.mp3"
        className="download-link"
      >
        Download Audio
      </a>
    </div>
  );
}

export default AudioPlayer;