import React from 'react'

import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

import Missing from './Missing.js'

function Mid({missings}) {

  
  return (
  <Container style={{paddingTop: 60, display: 'flex', flexWrap: 'wrap'}}>
    {missings.map((missingPerson, idx) => (
      console.log(missingPerson),
      <Row key={idx}>
        <Missing 
          personName={missingPerson._source.fields.name[0]} 
          profileImage={missingPerson._source.fields.image_url} 
          missingDescription={missingPerson._source.fields.description}  />
      </Row>
        )
      )
    }
    </Container>
  )

}

export default Mid
