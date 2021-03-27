import React from 'react'

import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';
import Button from 'react-bootstrap/Button';


function Top() {
  return (

    <Navbar bg="dark" expand="lg" variant="dark" fixed="top">
    <Navbar.Brand href="#home">Vivi :-)</Navbar.Brand>
    <Navbar.Collapse id="responsive-navbar-nav">
    <Nav className="mr-auto">
      <Nav.Link href="#home">Home</Nav.Link>
      <Nav.Link href="#upload">Upload</Nav.Link>
      <Nav.Link href="#about">About</Nav.Link>
    </Nav>
    </Navbar.Collapse>
    <Form inline>
      <FormControl type="text" placeholder="Search" className="mr-sm-2" />
      <Button variant="outline-info">Search</Button>
    </Form>

  </Navbar>
  )
}

export default Top
