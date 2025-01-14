import React, { useState } from "react";
import { TextField, Button, Box, Typography, Container, Paper } from "@mui/material";
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
    <Container maxWidth="sm" sx={{ paddingTop: 5 }}>
      <Paper elevation={3} sx={{ padding: 4 }}>
        <Typography variant="h5" align="center" gutterBottom>
          Simulate User Interaction
        </Typography>
        <Box component="form" onSubmit={handleSubmit}>
          <TextField
            name="user_id"
            label="User ID"
            value={formData.user_id}
            onChange={(e) => setFormData({ ...formData, user_id: e.target.value })}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <TextField
            name="message"
            label="Message"
            value={formData.message}
            onChange={(e) => setFormData({ ...formData, message: e.target.value })}
            fullWidth
            margin="normal"
            variant="outlined"
            multiline
            rows={4}
          />
          <Box sx={{ display: "flex", justifyContent: "center", marginTop: 2 }}>
            <Button type="submit" variant="contained" color="primary">
              Simulate Response
            </Button>
          </Box>
        </Box>
        {response && (
          <Box mt={3} sx={{ backgroundColor: "#f4f4f4", padding: 2, borderRadius: "4px" }}>
            <Typography variant="h6">Response:</Typography>
            <Typography>{response}</Typography>
          </Box>
        )}
      </Paper>
    </Container>
  );
};

export default Simulate;
