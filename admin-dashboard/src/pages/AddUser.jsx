import React, { useState } from "react";
import { TextField, Button, Box } from "@mui/material";
import axios from "axios";

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
    axios.post("http://192.168.1.4:8000/users/", formData).then(() => {
      alert("User added successfully");
    });
  };

  return (
    <Box component="form" onSubmit={handleSubmit}>
      <TextField name="name" label="Name" onChange={handleChange} fullWidth />
      <TextField name="age" label="Age" type="number" onChange={handleChange} fullWidth />
      <TextField name="sex" label="Sex" onChange={handleChange} fullWidth />
      <TextField name="location" label="Location" onChange={handleChange} fullWidth />
      <TextField name="education" label="Education" onChange={handleChange} fullWidth />
      <TextField
        name="professional_details"
        label="Professional Details"
        multiline
        rows={4}
        onChange={handleChange}
        fullWidth
      />
      <Button type="submit" variant="contained">
        Add User
      </Button>
    </Box>
  );
};

export default AddUser;
