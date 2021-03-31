import React, { useState } from 'react';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';
import Button from 'react-bootstrap/Button';


function SearchBar({setItems, items}) {

  const [searchquery, setSearchquery] = useState("");


  const getData = async (e) => {
    e.preventDefault()
    const response = await fetch(`https://t6njbak1ya.execute-api.us-east-1.amazonaws.com/alpha/search?q=` + searchquery);
    const data = await response.json();
    setItems(data.hits.hits);
  }

  const updateSearchquery = (e) => {
    e.preventDefault();
    setSearchquery(e.target.value);
  }
  
  return(
    <Form style={{marginTop:'10%', marginLeft:'10%', marginRight: '10%', width:'80%'}}>
    <FormControl onChange={updateSearchquery} type="text" placeholder="Search" className="mr-sm-2" />
    <Button type="submit" onClick={getData} variant="outline-info">Search</Button>
    </Form>
  )
}


export default SearchBar;
