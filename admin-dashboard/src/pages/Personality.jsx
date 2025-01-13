import React, { useState } from "react";
import { TextField, Button, Box } from "@mui/material";
import axios from "axios";

const Personality = () => {
  const [formData, setFormData] = useState({
    user_id: "",
    entries: [{ question: "", response: "" }],
  });

  const handleChange = (e, index) => {
    const newEntries = [...formData.entries];
    newEntries[index][e.target.name] = e.target.value;
    setFormData({ ...formData, entries: newEntries });
  };

  const addEntry = () => {
    setFormData({
      ...formData,
      entries: [...formData.entries, { question: "", response: "" }],
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.post("http://192.168.1.4:8000/personality/", formData).then(() => {
      alert("Personality data added successfully");
    });
  };

  return (
    <Box component="form" onSubmit={handleSubmit}>
      <TextField
        name="user_id"
        label="User ID"
        value={formData.user_id}
        onChange={(e) => setFormData({ ...formData, user_id: e.target.value })}
        fullWidth
      />
      {formData.entries.map((entry, index) => (
        <div key={index}>
          <TextField
            name="question"
            label="Question"
            value={entry.question}
            onChange={(e) => handleChange(e, index)}
            fullWidth
          />
          <TextField
            name="response"
            label="Response"
            value={entry.response}
            onChange={(e) => handleChange(e, index)}
            fullWidth
          />
        </div>
      ))}
      <Button onClick={addEntry}>Add Entry</Button>
      <Button type="submit" variant="contained">
        Submit
      </Button>
    </Box>
  );
};

export default Personality;
