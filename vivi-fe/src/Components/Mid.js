import React from 'react'

import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

import Video from './Video.js'

function Mid() {
  return (
  <Container fluid style={{paddingTop: 60}}>
  <Row>
    <Col><Video /></Col>
  </Row>
  </Container>
  )
}

export default Mid
