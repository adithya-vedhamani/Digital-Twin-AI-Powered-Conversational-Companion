import { useEffect, useState } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Box,
  Typography,
  CircularProgress,
  useTheme,
  useMediaQuery
} from "@mui/material";
import axios from "axios";

const UserTable = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const theme = useTheme();
  const isDesktop = useMediaQuery(theme.breakpoints.up('md'));

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        setLoading(true);
        const response = await axios.get("http://10.123.19.86:8000/users/");
        setUsers(response.data);
        setError(null);
      } catch (err) {
        setError("Failed to fetch users. Please try again later.");
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) {
    return (
      <Box 
        display="flex" 
        justifyContent="center" 
        alignItems="center" 
        minHeight="calc(100vh - 100px)"
        width="100%"
      >
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box 
        display="flex" 
        justifyContent="center" 
        alignItems="center" 
        minHeight="calc(100vh - 100px)"
        width="100%"
      >
        <Typography color="error">{error}</Typography>
      </Box>
    );
  }

  return (
    <Box
      sx={{
        height: 'auto',  // Allow the height to grow with the content
        width: '100%',  // Full width
        padding: theme.spacing(2),
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <Typography
        variant="h5"
        sx={{
          mb: 2,
          fontWeight: 'bold',
          color: theme.palette.text.primary
        }}
      >
        User List
      </Typography>

      <TableContainer
        component={Paper}
        sx={{
          flexGrow: 1,
          width: '100%',  // Ensure the table container spans full width
          overflow: 'auto',
          '&::-webkit-scrollbar': {
            width: '0.4em',
            height: '0.4em',
          },
          '&::-webkit-scrollbar-track': {
            background: theme.palette.background.default,
          },
          '&::-webkit-scrollbar-thumb': {
            backgroundColor: theme.palette.divider,
            borderRadius: '6px',
          },
          '&::-webkit-scrollbar-thumb:hover': {
            background: theme.palette.action.hover,
          },
        }}
      >
        <Table stickyHeader sx={{ minWidth: 350 }}>
          <TableHead>
            <TableRow>
              <TableCell
                sx={{
                  backgroundColor: theme.palette.background.paper,
                  fontWeight: 'bold',
                  width: '20%',  // Adjust width percentages as needed
                }}
              >
                ID
              </TableCell>
              <TableCell
                sx={{
                  backgroundColor: theme.palette.background.paper,
                  fontWeight: 'bold',
                  width: '80%',  // Adjust width percentages as needed
                }}
              >
                Name
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {users.map((user) => (
              <TableRow
                key={user.id}
                sx={{
                  '&:nth-of-type(odd)': {
                    backgroundColor: theme.palette.action.hover,
                  },
                  '&:hover': {
                    backgroundColor: theme.palette.action.selected,
                  },
                  transition: 'background-color 0.2s ease',
                }}
              >
                <TableCell 
                  component="th" 
                  scope="row"
                  sx={{
                    borderBottom: `1px solid ${theme.palette.divider}`,
                  }}
                >
                  {user.id}
                </TableCell>
                <TableCell
                  sx={{
                    borderBottom: `1px solid ${theme.palette.divider}`,
                  }}
                >
                  {user.name}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default UserTable;
