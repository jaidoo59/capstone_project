import React from 'react';

function VoiceSelector({ voice, setVoice }) {
  return (
    <div>
      <label className="block text-sm font-medium mb-2">Select Voice</label>
      <select
        value={voice}
        onChange={(e) => setVoice(e.target.value)}
        className="w-full border rounded-lg p-3 mb-4 focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        <option value="Abigail">Abigail (US Female)</option>
        <option value="Jonathan">Jonathan (US Male)</option>
        <option value="Stella">Stella (UK Female)</option>
        <option value="Bismark">Bismark (UK Male)</option>
      </select>
    </div>
  );
}

export default VoiceSelector;