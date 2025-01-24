import { useState } from "react";
import { TextField, Button, Box, Typography, Container, Paper } from "@mui/material";
import axios from "axios";

const DeleteUser = () => {
  const [userId, setUserId] = useState("");

  const handleChange = (e) => {
    setUserId(e.target.value);
  };

  const handleDelete = (e) => {
    e.preventDefault();
    axios
      .delete(`http://10.123.19.86:8000/users/${userId}`)
      .then(() => {
        alert("User deleted successfully");
      })
      .catch((err) => {
        alert(`Error: ${err.response?.data?.detail || "Unable to delete user"}`);
      });
  };

  return (
    <Container maxWidth="sm" sx={{ paddingTop: 5 }}>
      <Paper elevation={3} sx={{ padding: 4 }}>
        <Typography variant="h5" align="center" gutterBottom>
          Delete User
        </Typography>
        <Box component="form" onSubmit={handleDelete}>
          <TextField
            name="userId"
            label="User ID"
            value={userId}
            onChange={handleChange}
            fullWidth
            margin="normal"
            variant="outlined"
          />
          <Box sx={{ display: "flex", justifyContent: "center", marginTop: 2 }}>
            <Button type="submit" variant="contained" color="error">
              Delete User
            </Button>
          </Box>
        </Box>
      </Paper>
    </Container>
  );
};

export default DeleteUser;
