import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import Sidebar from "./components/Sidebar";
import Dashboard from "./pages/Dashboard";
import AddUser from "./pages/AddUser";
import Personality from "./pages/Personality";
import Simulate from "./pages/Simulate";
import { Box } from "@mui/material";

const App = () => (
  <Router>
    <Navbar />
    <Box display="flex">
      <Sidebar />
      <Box flexGrow={1} p={3}>
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/add-user" element={<AddUser />} />
          <Route path="/personality" element={<Personality />} />
          <Route path="/simulate" element={<Simulate />} />
        </Routes>
      </Box>
    </Box>
  </Router>
);

export default App;
