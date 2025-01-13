import React, { useEffect, useState } from "react";
import { Table, TableBody, TableCell, TableHead, TableRow, Paper } from "@mui/material";
import axios from "axios";

const UserTable = () => {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    axios.get("http://192.168.1.4:8000/users/").then((response) => {
      setUsers(response.data);
    });
  }, []);

  return (
    <Paper>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>ID</TableCell>
            <TableCell>Name</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {users.map((user) => (
            <TableRow key={user.id}>
              <TableCell>{user.id}</TableCell>
              <TableCell>{user.name}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Paper>
  );
};

export default UserTable;
