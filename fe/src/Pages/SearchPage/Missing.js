import React from 'react'
import { Link } from 'react-router-dom';

import Card from 'react-bootstrap/Card';


function Missing({personName, profileImage, missingDescription, personId}) {  
  return (
  <Card style={{ width: '18rem', flex: 1, margin: 20}}  className="box">
  <Card.Img variant="top" src={profileImage} />
  <Card.Body>
    <Link to={`/item/${personId}`}>
      <Card.Title>{personName}</Card.Title>
    </Link>
    <Card.Text>
      {missingDescription}
    </Card.Text>
  </Card.Body>
</Card>
  )
}

export default Missing
