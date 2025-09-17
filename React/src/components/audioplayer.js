import React from 'react';

function AudioPlayer({ audioUrl }) {
  return (
    <div className="mt-6">
      <h2 className="text-lg font-semibold mb-2">Your Audio:</h2>
      <audio src={audioUrl} controls className="w-full mb-3" />
      <a
        href={audioUrl}
        download="speech.mp3"
        className="block text-center bg-green-600 text-white py-2 rounded-lg hover:bg-green-700"
      >
        Download Audio
      </a>
    </div>
  );
}

export default AudioPlayer;