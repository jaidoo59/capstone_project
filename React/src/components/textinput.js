import React from 'react';

function TextInput({ text, setText }) {
  return (
    <div>
      <label className="block text-sm font-medium mb-2">Enter your text</label>
      <textarea
        value={text}
        onChange={(e) => setText(e.target.value)}
        rows="5"
        className="w-full border rounded-lg p-3 mb-4 focus:outline-none focus:ring-2 focus:ring-blue-500"
        placeholder="Type something..."
      />
    </div>
  );
}

export default TextInput;