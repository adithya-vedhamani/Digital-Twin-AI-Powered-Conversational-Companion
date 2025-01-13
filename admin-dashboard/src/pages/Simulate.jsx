import React, { useState } from "react";
import { TextField, Button, Box } from "@mui/material";
import axios from "axios";

const Simulate = () => {
  const [formData, setFormData] = useState({ user_id: "", message: "" });
  const [response, setResponse] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.post("http://192.168.1.4:8000/simulate/", formData).then((res) => {
      setResponse(res.data.response);
    });
  };

  return (
    <Box>
      <Box component="form" onSubmit={handleSubmit}>
        <TextField
          name="user_id"
          label="User ID"
          value={formData.user_id}
          onChange={(e) => setFormData({ ...formData, user_id: e.target.value })}
          fullWidth
        />
        <TextField
          name="message"
          label="Message"
          value={formData.message}
          onChange={(e) => setFormData({ ...formData, message: e.target.value })}
          fullWidth
        />
        <Button type="submit" variant="contained">
          Simulate Response
        </Button>
      </Box>
      {response && (
        <Box mt={2}>
          <h3>Response:</h3>
          <p>{response}</p>
        </Box>
      )}
    </Box>
  );
};

export default Simulate;
