import React from 'react'

import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

import Video from './Video.js'

function Mid({videos}) {

  
  return (
  <Container style={{paddingTop: 60, display: 'flex', flexWrap: 'wrap'}}>
    {videos.map((videoItem, idx) => (

      <Row key={idx}>
        <Video 
          thumbnailImg={videoItem.thumbnailUrl} 
          videoTitle={videoItem.title} 
          videoDescription={videoItem.thumbnailUrl}  />
      </Row>
        )
      )
    }
    </Container>
  )

}

export default Mid
