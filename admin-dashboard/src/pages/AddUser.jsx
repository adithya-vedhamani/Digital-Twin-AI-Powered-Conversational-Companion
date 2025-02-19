import { useState } from "react";
import { TextField, Button, Box, Typography, Container, Paper } from "@mui/material";
import axios from "axios";
import API_BASE_URL from "../config";

const AddUser = () => {
  const [formData, setFormData] = useState({
    name: "",
    age: "",
    sex: "",
    location: "",
    education: "",
    professional_details: "",
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    axios.post(`${API_BASE_URL}/users/`, formData).then(() => {
      alert("User added successfully");
    });
  };

  return (
    <Container maxWidth="sm" sx={{ paddingTop: 5 }}>
      <Paper elevation={3} sx={{ padding: 4 }}>
        <Typography variant="h5" align="center" gutterBottom>
          Add New User
        </Typography>
        <Box component="form" onSubmit={handleSubmit}>
          <TextField
            name="name"
            label="Name"
            value={formData.name}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <TextField
            name="age"
            label="Age"
            type="number"
            value={formData.age}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <TextField
            name="sex"
            label="Sex"
            value={formData.sex}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <TextField
            name="location"
            label="Location"
            value={formData.location}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <TextField
            name="education"
            label="Education"
            value={formData.education}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <TextField
            name="professional_details"
            label="Professional Details"
            multiline
            rows={4}
            value={formData.professional_details}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <Box sx={{ display: "flex", justifyContent: "center", marginTop: 2 }}>
            <Button type="submit" variant="contained" color="primary">
              Add User
            </Button>
          </Box>
        </Box>
      </Paper>
    </Container>
  );
};

export default AddUser;
