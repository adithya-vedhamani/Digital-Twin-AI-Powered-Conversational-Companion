import { useState } from 'react';
import {
  List,
  ListItem,
  ListItemText,
  Box,
  Divider,
  Typography,
  ListItemIcon,
  Collapse,
  IconButton,
  useTheme
} from "@mui/material";
import { Link, useLocation } from "react-router-dom";
import {
  Dashboard as DashboardIcon,
  PersonAdd as PersonAddIcon,
  Group as GroupIcon,
  Person as PersonIcon,
  Delete as DeleteIcon,
  Edit as EditIcon,
  Psychology as PsychologyIcon,
  AutoFixHigh as SimulateIcon,
  MenuOpen as MenuOpenIcon
} from '@mui/icons-material';

const Sidebar = ({ collapsed, onCollapse }) => {
  const theme = useTheme();
  const location = useLocation();
  
  const menuItems = [
    { 
      title: 'Dashboard', 
      path: '/', 
      icon: <DashboardIcon /> 
    },
    { 
      title: 'User Management',
      items: [
        { title: 'Add User', path: '/add-user', icon: <PersonAddIcon /> },
        { title: 'All Users', path: '/get-all-users', icon: <GroupIcon /> },
        { title: 'User by ID', path: '/get-user-by-id', icon: <PersonIcon /> },
        { title: 'Delete User', path: '/delete-user', icon: <DeleteIcon /> },
        { title: 'Update User', path: '/update-user', icon: <EditIcon /> },
      ]
    },
    { 
      title: 'Features',
      items: [
        { title: 'Personality', path: '/personality', icon: <PsychologyIcon /> },
        { title: 'Simulate Response', path: '/simulate', icon: <SimulateIcon /> },
      ]
    }
  ];

  const [openSections, setOpenSections] = useState({
    'User Management': true,
    'Features': true
  });

  const toggleSection = (section) => {
    setOpenSections(prev => ({
      ...prev,
      [section]: !prev[section]
    }));
  };

  return (
    <Box
      sx={{
        width: collapsed ? 80 : 280,
        height: "100vh",
        backgroundColor: theme.palette.mode === 'dark' ? '#1e1e1e' : '#fff',
        borderRight: `1px solid ${theme.palette.divider}`,
        transition: 'width 0.3s ease',
        overflow: 'hidden',
        position: 'relative'
      }}
    >
      {/* Collapse Button */}
      <IconButton
        onClick={onCollapse}
        sx={{
          position: 'absolute',
          right: 10,
          top: 10,
          transform: collapsed ? 'rotate(180deg)' : 'none',
          transition: 'transform 0.3s ease'
        }}
      >
        <MenuOpenIcon />
      </IconButton>

      <Box p={collapsed ? 1 : 2} pt={5}>
        <Typography
          variant="h6"
          sx={{
            color: theme.palette.text.primary,
            marginBottom: 3,
            fontWeight: "bold",
            textAlign: collapsed ? 'center' : 'left',
            fontSize: collapsed ? '0.8rem' : '1.25rem'
          }}
        >
          {collapsed ? 'DB' : 'Dashboard'}
        </Typography>

        <List>
          {menuItems.map((item, index) => (
            item.items ? (
              <Box key={item.title}>
                {index > 0 && <Divider sx={{ my: 1 }} />}
                {!collapsed && (
                  <>
                    <ListItem
                      button
                      onClick={() => toggleSection(item.title)}
                      sx={{
                        py: 1,
                        backgroundColor: 'transparent',
                        '&:hover': {
                          backgroundColor: theme.palette.action.hover
                        }
                      }}
                    >
                      <ListItemText
                        primary={item.title}
                        sx={{
                          '& .MuiTypography-root': {
                            fontWeight: 'bold',
                            color: theme.palette.text.secondary
                          }
                        }}
                      />
                    </ListItem>
                    <Collapse in={openSections[item.title]} timeout="auto">
                      <List component="div" disablePadding>
                        {item.items.map((subItem) => (
                          <ListItem
                            button
                            component={Link}
                            to={subItem.path}
                            key={subItem.title}
                            selected={location.pathname === subItem.path}
                            sx={{
                              pl: 4,
                              py: 1,
                              '&.Mui-selected': {
                                backgroundColor: theme.palette.primary.main + '20',
                                '&:hover': {
                                  backgroundColor: theme.palette.primary.main + '30'
                                }
                              },
                              '&:hover': {
                                backgroundColor: theme.palette.action.hover
                              }
                            }}
                          >
                            <ListItemIcon sx={{ minWidth: 40 }}>
                              {subItem.icon}
                            </ListItemIcon>
                            <ListItemText primary={subItem.title} />
                          </ListItem>
                        ))}
                      </List>
                    </Collapse>
                  </>
                )}
              </Box>
            ) : (
              <ListItem
                button
                component={Link}
                to={item.path}
                key={item.title}
                selected={location.pathname === item.path}
                sx={{
                  py: 1,
                  justifyContent: collapsed ? 'center' : 'flex-start',
                  '&.Mui-selected': {
                    backgroundColor: theme.palette.primary.main + '20',
                    '&:hover': {
                      backgroundColor: theme.palette.primary.main + '30'
                    }
                  },
                  '&:hover': {
                    backgroundColor: theme.palette.action.hover
                  }
                }}
              >
                <ListItemIcon sx={{ minWidth: collapsed ? 0 : 40, mr: collapsed ? 0 : 2 }}>
                  {item.icon}
                </ListItemIcon>
                {!collapsed && <ListItemText primary={item.title} />}
              </ListItem>
            )
          ))}
        </List>
      </Box>
    </Box>
  );
};

export default Sidebar;