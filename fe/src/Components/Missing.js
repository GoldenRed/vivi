import React from 'react'

import Card from 'react-bootstrap/Card';


function Missing({personName, profileImage, missingDescription }) {  
  return (
  <Card style={{ width: '18rem', flex: 1, margin: 20}}  className="box">
  <Card.Img variant="top" src={profileImage} />
  <Card.Body>
    <Card.Title>{personName}</Card.Title>
    <Card.Text>
      {missingDescription}
    </Card.Text>
  </Card.Body>
</Card>
  )
}

export default Missing
