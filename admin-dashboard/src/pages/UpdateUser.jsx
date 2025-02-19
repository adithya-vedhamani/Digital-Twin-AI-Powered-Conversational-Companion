import { useState } from "react";
import { TextField, Button, Box, Typography, Container, Paper, Grid, Divider } from "@mui/material";
import axios from "axios";
import API_BASE_URL from "../config";

const UpdateUser = () => {
  const [formData, setFormData] = useState({
    id: "",
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

  const handleUpdate = (e) => {
    e.preventDefault();
    axios
      .put(`${API_BASE_URL}/users/${formData.id}`, formData)
      .then(() => {
        alert("User updated successfully");
      })
      .catch((err) => {
        alert(`Error: ${err.response?.data?.detail || "Unable to update user"}`);
      });
  };

  return (
    <Container maxWidth="sm" sx={{ paddingTop: 5 }}>
      <Paper elevation={5} sx={{ padding: 4, backgroundColor: "#f5f5f5" }}>
        <Typography variant="h5" align="center" gutterBottom sx={{ color: "#1976d2", fontWeight: "bold" }}>
          Update User Details
        </Typography>

        <Divider sx={{ marginBottom: 3 }} />

        <Box component="form" onSubmit={handleUpdate}>
          <Grid container spacing={2}>
            <Grid item xs={12}>
              <TextField
                name="id"
                label="User ID"
                value={formData.id}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
                required
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                name="name"
                label="Name"
                value={formData.name}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                name="age"
                label="Age"
                type="number"
                value={formData.age}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                name="sex"
                label="Sex"
                value={formData.sex}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
                required
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                name="location"
                label="Location"
                value={formData.location}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
                required
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                name="education"
                label="Education"
                value={formData.education}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
                required
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                name="professional_details"
                label="Professional Details"
                value={formData.professional_details}
                onChange={handleChange}
                fullWidth
                margin="normal"
                variant="outlined"
                color="primary"
              />
            </Grid>
          </Grid>

          <Box sx={{ display: "flex", justifyContent: "center", marginTop: 3 }}>
            <Button
              type="submit"
              variant="contained"
              color="primary"
              sx={{ padding: "10px 20px", fontSize: "16px", fontWeight: "bold", borderRadius: "8px" }}
            >
              Update User
            </Button>
          </Box>
        </Box>
      </Paper>
    </Container>
  );
};

export default UpdateUser;
