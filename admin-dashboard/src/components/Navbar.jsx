import React from "react";
import { AppBar, Toolbar, Typography, Button, IconButton, Box } from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import AccountCircleIcon from "@mui/icons-material/AccountCircle";

const Navbar = () => (
  <AppBar position="static" sx={{ bgcolor: "#1976d2", boxShadow: "none" }}>
    <Toolbar sx={{ display: "flex", justifyContent: "space-between" }}>
      {/* Left Section: Logo and Title */}
      <Box display="flex" alignItems="center">
        <IconButton edge="start" color="inherit" aria-label="menu" sx={{ mr: 2 }}>
          <MenuIcon />
        </IconButton>
        <Typography variant="h6" component="div" sx={{ fontWeight: "bold" }}>
          Dashboard
        </Typography>
      </Box>

      {/* Right Section: Profile and Actions */}
      <Box display="flex" alignItems="center" gap={2}>
        <Button color="inherit" sx={{ textTransform: "none", fontSize: "16px" }}>
          Home
        </Button>
        <Button color="inherit" sx={{ textTransform: "none", fontSize: "16px" }}>
          About
        </Button>
        <IconButton color="inherit" edge="end" aria-label="profile">
          <AccountCircleIcon />
        </IconButton>
      </Box>
    </Toolbar>
  </AppBar>
);

export default Navbar;
