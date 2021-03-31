import React, { useState } from 'react';
import { Link } from 'react-router-dom';

import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';



function Top() {


  return (

    <Navbar bg="dark" expand="lg" variant="dark" fixed="top">
    <Navbar.Brand href="/">Displaced</Navbar.Brand>
    <Navbar.Collapse id="responsive-navbar-nav">
    <Nav className="mr-auto">
      <Link to="/">
        <Nav.Link href="/">Home</Nav.Link>
      </Link>
      <Link to="/submit">
        <Nav.Link href="submit">Submit</Nav.Link>
      </Link>
      <Link to="/about">
        <Nav.Link href="about">About</Nav.Link>
      </Link>
    </Nav>
    </Navbar.Collapse>


  </Navbar>
  )
}

export default Top
