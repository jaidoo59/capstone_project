import React from 'react';

function VoiceSelector({ voice, setVoice }) {
  return (
    <div>
      <label className="label">Select Voice</label>
      <select
        value={voice}
        onChange={(e) => setVoice(e.target.value)}
        className="select"
      >
        <option value="Joanna">Joanna (US Female)</option>
        <option value="Matthew">Matthew (US Male)</option>
        <option value="Amy">Amy (UK Female)</option>
        <option value="Brian">Brian (UK Male)</option>
      </select>
    </div>
  );
}

export default VoiceSelector;