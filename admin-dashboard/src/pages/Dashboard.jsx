import React from "react";
import { Box, Container, Typography, Paper } from "@mui/material";
import UserTable from "../components/UserTable";

const Dashboard = () => (
  <Box sx={{ backgroundColor: "#f5f5f5", minHeight: "100vh" }}>
    {/* Container to center the content */}
    <Container maxWidth="lg" sx={{ paddingTop: 5 }}>
      {/* Title Section */}
      <Typography variant="h3" gutterBottom sx={{ fontWeight: "bold", color: "#1976d2" }}>
        Dashboard
      </Typography>

      {/* Card for the Table Section */}
      <Paper elevation={3} sx={{ padding: 3, backgroundColor: "#fff" }}>
        {/* User Table Section */}
        <Typography variant="h6" gutterBottom sx={{ fontWeight: "bold", marginBottom: 2 }}>
          User Data
        </Typography>
        <UserTable />
      </Paper>
    </Container>
  </Box>
);

export default Dashboard;
