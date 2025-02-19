import  { useState } from "react";
import { TextField, Button, Box, Typography, Card, CardContent, Grid } from "@mui/material";
import axios from "axios";
import API_BASE_URL from "../config";

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
    axios.post(`${API_BASE_URL}/personality/`, formData).then(() => {
      alert("Personality data added successfully");
    });
  };

  return (
    <Box sx={{ maxWidth: "600px", margin: "0 auto", padding: 3 }}>
      <Card variant="outlined">
        <CardContent>
          <Typography variant="h5" gutterBottom>
            Personality Data Entry
          </Typography>
          
          <Box component="form" onSubmit={handleSubmit} sx={{ display: "flex", flexDirection: "column", gap: 3 }}>
            {/* User ID Input */}
            <TextField
              name="user_id"
              label="User ID"
              value={formData.user_id}
              onChange={(e) => setFormData({ ...formData, user_id: e.target.value })}
              fullWidth
              variant="outlined"
              required
            />
            
            {/* Dynamic Question and Response Fields */}
            {formData.entries.map((entry, index) => (
              <Grid container spacing={2} key={index}>
                <Grid item xs={12} md={6}>
                  <TextField
                    name="question"
                    label="Question"
                    value={entry.question}
                    onChange={(e) => handleChange(e, index)}
                    fullWidth
                    variant="outlined"
                    required
                  />
                </Grid>
                <Grid item xs={12} md={6}>
                  <TextField
                    name="response"
                    label="Response"
                    value={entry.response}
                    onChange={(e) => handleChange(e, index)}
                    fullWidth
                    variant="outlined"
                    required
                  />
                </Grid>
              </Grid>
            ))}
            
            {/* Add Entry and Submit Buttons */}
            <Box sx={{ display: "flex", gap: 2 }}>
              <Button onClick={addEntry} variant="outlined" sx={{ flexGrow: 1 }}>
                Add Entry
              </Button>
              <Button type="submit" variant="contained" sx={{ flexGrow: 1 }}>
                Submit
              </Button>
            </Box>
          </Box>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Personality;
