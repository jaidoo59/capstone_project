import React from 'react';

function TextInput({ text, setText }) {
  return (
    <div className="text-input-wrapper">
      <label className="label">Enter your text</label>
      <textarea
        value={text}
        onChange={(e) => setText(e.target.value)}
        rows="5"
        className="textarea"
        placeholder="Type something..."
      />
    </div>
  );
}

export default TextInput;