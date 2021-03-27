import React from 'react'

import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

import Video from './Video.js'

function Mid() {

  const videosInfo = [
    {
      image : "https://via.placeholder.com/600/b0f7cc",
      title : "first",
      text : "I am first"
    },
    {
      image : "https://via.placeholder.com/600/b0f7cc",
      title : "second",
      text : "I am second"
    },
    {
      image : "https://via.placeholder.com/600/b0f7cc",
      title : "third",
      text : "I am third"
    },
    {
      image : "https://via.placeholder.com/600/b0f7cc",
      title : "fourth",
      text : "I am fourth"
    },
    
  ]

  const getRows = array => {
    let rows = {}
    let counter = 1
    array.items.forEach((item, idx) => {
      rows[counter] = rows[counter] ? [...rows[counter]] : []
      if (idx % 4 === 0 && idx !== 0) {
        counter++
        rows[counter] = rows[counter] ? [...rows[counter]] : []
        rows[counter].push(item)
      } else {
        rows[counter].push(item)
      }
    })
    return rows
  }
  
  return (
  <Container fluid style={{paddingTop: 60, display: 'grid'}}>
    {videosInfo.map((videoItem, idx) => (
      if (idx % 4 === 0){
        <Row>
      }
      
      <Col>
        <Video 
          thumbnailImg={videoItem.image} 
          videoTitle={videoItem.title} 
          videoDescription={videoItem.text}  />))},
      </Col>
      
      {if (idx % 3 === 0){
        </Row>
      }
    }
    )
    </Container>
}

export default Mid
