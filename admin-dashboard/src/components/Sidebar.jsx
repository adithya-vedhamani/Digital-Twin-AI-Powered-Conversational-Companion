import React from "react";
import { List, ListItem, ListItemText, Box, Divider, Typography } from "@mui/material";
import { Link } from "react-router-dom";

const Sidebar = () => (
  <Box
    sx={{
      width: 250,
      height: "100vh",
      backgroundColor: "#2c3e50", // Dark background for contrast
      padding: 2,
      color: "#ecf0f1", // Light color for text
      boxShadow: "2px 0 5px rgba(0,0,0,0.1)", // Subtle shadow for depth
    }}
  >
    <Typography variant="h6" sx={{ color: "#ecf0f1", marginBottom: 3, fontWeight: 'bold' }}>
      My Dashboard
    </Typography>
    <List>
      <ListItem button component={Link} to="/" sx={{ "&:hover": { backgroundColor: "#34495e" } }}>
        <ListItemText primary="Dashboard" />
      </ListItem>
      <Divider sx={{ borderColor: "#34495e" }} />
      <ListItem button component={Link} to="/add-user" sx={{ "&:hover": { backgroundColor: "#34495e" } }}>
        <ListItemText primary="Add User" />
      </ListItem>
      <Divider sx={{ borderColor: "#34495e" }} />
      <ListItem button component={Link} to="/personality" sx={{ "&:hover": { backgroundColor: "#34495e" } }}>
        <ListItemText primary="Personality" />
      </ListItem>
      <Divider sx={{ borderColor: "#34495e" }} />
      <ListItem button component={Link} to="/simulate" sx={{ "&:hover": { backgroundColor: "#34495e" } }}>
        <ListItemText primary="Simulate Response" />
      </ListItem>
    </List>
  </Box>
);

export default Sidebar;
