import React from "react";
import { List, ListItem, ListItemText, Box } from "@mui/material";
import { Link } from "react-router-dom";

const Sidebar = () => (
  <Box sx={{ width: 250, height: "100vh", backgroundColor: "#f5f5f5", padding: 2 }}>
    <List>
      <ListItem button component={Link} to="/">
        <ListItemText primary="Dashboard" />
      </ListItem>
      <ListItem button component={Link} to="/add-user">
        <ListItemText primary="Add User" />
      </ListItem>
      <ListItem button component={Link} to="/personality">
        <ListItemText primary="Personality" />
      </ListItem>
      <ListItem button component={Link} to="/simulate">
        <ListItemText primary="Simulate Response" />
      </ListItem>
    </List>
  </Box>
);

export default Sidebar;
