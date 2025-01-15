import React, { useEffect, useState } from "react";
import {
  Box,
  Container,
  Typography,
  Paper,
  Grid,
  Card,
  CardContent,
  useTheme,
  Fade,
  Divider
} from "@mui/material";
import {
  People as PeopleIcon,
  TrendingUp as TrendingUpIcon,
  Assessment as AssessmentIcon,
} from '@mui/icons-material';
import UserTable from "../components/UserTable";
import axios from "axios";
import PropTypes from 'prop-types';

const StatCard = ({ icon, title, value, color }) => {
  const Icon = icon;
  return (
    <Card 
      sx={{ 
        height: '100%',
        transition: 'transform 0.2s, box-shadow 0.2s',
        '&:hover': {
          transform: 'translateY(-4px)',
          boxShadow: 4,
        }
      }}
    >
      <CardContent>
        <Box display="flex" alignItems="center" gap={2}>
          <Box
            sx={{
              backgroundColor: `${color}15`,
              borderRadius: '12px',
              p: 1.5,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center'
            }}
          >
            <Icon sx={{ fontSize: 32, color: color }} />
          </Box>
          <Box>
            <Typography color="textSecondary" variant="body2">
              {title}
            </Typography>
            <Typography variant="h5" sx={{ fontWeight: 'bold', mt: 0.5 }}>
              {value}
            </Typography>
          </Box>
        </Box>
      </CardContent>
    </Card>
  );
};
StatCard.propTypes = {
  icon: PropTypes.elementType.isRequired,
  title: PropTypes.string.isRequired,
  value: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
  color: PropTypes.string.isRequired,
};

const Dashboard = () => {
  const theme = useTheme();
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeUsers: 0,
    newUsersToday: 0,
  });

  useEffect(() => {
    // Fetch data from the API
    const fetchData = async () => {
      try {
        const response = await axios.get("http://192.168.1.6:8000/users/");
        const { users, active_users, new_users_today } = response.data;
        setStats({
          totalUsers: users ? users.length : 0,
          activeUsers: active_users,
          newUsersToday: new_users_today,
        });
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  return (
    <Box 
  sx={{ 
    backgroundColor: '#ffffff',  // Always set background to white
    height: "100vh", // Fix height to viewport
    display: "flex",
    flexDirection: "column"
  }}
>
<Divider sx={{ marginBottom: 3 }} />
      <Container 
        maxWidth={false}  // Make it full width
        sx={{ 
          pt: 4, 
          pb: 6,
          flexGrow: 1, 
          display: "flex", 
          flexDirection: "column" 
        }}
      >
        {/* Header Section */}
        <Fade in timeout={800}>
          <Box mb={4}>
            <Typography 
              variant="h3" 
              sx={{ 
                fontWeight: "800",
                color: theme.palette.primary.main,
                mb: 1
              }}
            >
              Match AI Admin Dashboard
            </Typography>
            <Typography variant="subtitle1" color="textSecondary">
              Welcome back! Here&apos;s what&apos;s happening with your users today.
            </Typography>
          </Box>
        </Fade>

        {/* Stats Section */}
        <Grid container spacing={3} sx={{ mb: 4 }}>
          <Grid item xs={12} sm={6} md={4}>
            <Fade in timeout={1000}>
              <div>
                <StatCard
                  icon={PeopleIcon}
                  title="Total Users"
                  value={stats.totalUsers}
                  color={theme.palette.primary.main}
                />
              </div>
            </Fade>
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <Fade in timeout={1200}>
              <div>
                <StatCard
                  icon={TrendingUpIcon}
                  title="Active Users"
                  value={stats.activeUsers}
                  color={theme.palette.success.main}
                />
              </div>
            </Fade>
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <Fade in timeout={1400}>
              <div>
                <StatCard
                  icon={AssessmentIcon}
                  title="New Users Today"
                  value={stats.newUsersToday}
                  color={theme.palette.info.main}
                />
              </div>
            </Fade>
          </Grid>
        </Grid>

        {/* Table Section */}
        <Fade in timeout={1600}>
          <Paper 
            elevation={0} 
            sx={{ 
              p: 3, 
              backgroundColor: theme.palette.background.paper,
              borderRadius: 2,
              border: `1px solid ${theme.palette.divider}`,
              '&:hover': {
                boxShadow: theme.shadows[4],
                transition: 'box-shadow 0.3s ease-in-out'
              },
              flexGrow: 1, 
              display: "flex", 
              flexDirection: "column"
            }}
          >
            <Box 
              display="flex" 
              justifyContent="space-between" 
              alignItems="center" 
              mb={3}
            >
              <Typography 
                variant="h5" 
                sx={{ 
                  fontWeight: "600",
                  color: theme.palette.text.primary 
                }}
              >
                User Data
              </Typography>
              <Typography 
                variant="body2" 
                sx={{ 
                  color: theme.palette.text.secondary,
                  backgroundColor: theme.palette.action.hover,
                  px: 2,
                  py: 0.5,
                  borderRadius: 1
                }}
              >
                Last updated: Today
              </Typography>
            </Box>
            <UserTable />
          </Paper>
        </Fade>
      </Container>
    </Box>
  );
};

export default Dashboard;
