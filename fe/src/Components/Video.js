import React from 'react'

import Card from 'react-bootstrap/Card';


function Video({thumbnailImg, videoTitle, videoDescription }) {  
  return (
  <Card style={{ width: '18rem', flex: 1, margin: 20}}  className="box">
  <Card.Img variant="top" src={thumbnailImg} />
  <Card.Body>
    <Card.Title>{videoTitle}</Card.Title>
    <Card.Text>
      {videoDescription}
    </Card.Text>
  </Card.Body>
</Card>
  )
}

export default Video
