import React, { useState } from 'react';

import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';
import Button from 'react-bootstrap/Button';


function Top({setMissings, missings}) {

  const [searchquery, setSearchquery] = useState("");


  const getData = async (e) => {
    e.preventDefault()
    const response = await fetch(`https://t6njbak1ya.execute-api.us-east-1.amazonaws.com/alpha/search?q=` + searchquery);
    const data = await response.json();
    setMissings(data.hits.hits);
  }

  const updateSearchquery = (e) => {
    e.preventDefault();
    setSearchquery(e.target.value);
  }
  


  return (

    <Navbar bg="dark" expand="lg" variant="dark" fixed="top">
    <Navbar.Brand href="#home">Displaced</Navbar.Brand>
    <Navbar.Collapse id="responsive-navbar-nav">
    <Nav className="mr-auto">
      <Nav.Link href="#home">Home</Nav.Link>
      <Nav.Link href="#submit">Submit</Nav.Link>
      <Nav.Link href="#about">About</Nav.Link>
    </Nav>
    </Navbar.Collapse>
    <Form inline>
      <FormControl onChange={updateSearchquery} type="text" placeholder="Search" className="mr-sm-2" />
      <Button type="submit" onClick={getData} variant="outline-info">Search</Button>
    </Form>

  </Navbar>
  )
}

export default Top
