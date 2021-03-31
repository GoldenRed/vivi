import React, {useState, useEffect} from 'react';
import { ListGroup, ListGroupItem } from 'react-bootstrap';
import Card from 'react-bootstrap/Card';



function Item({ match }) {  

  useEffect(() => {
    fetchItem();
  }, []);


  const [item, setItem] = useState({});

  const fetchItem = async () => {
    const response = await fetch(`https://t6njbak1ya.execute-api.us-east-1.amazonaws.com/alpha/getDocument/` + match.params.id);
    const data = await response.json();
    console.log(data)
    setItem(data.hits.hits);
    console.log(item)

  }
  return (
<Card style={{ width: '18rem', marginTop: '10%' }}>
  <Card.Img variant="top" src={item.image_url} />
  <Card.Body>
    <Card.Title>item.name</Card.Title>
    <Card.Text>
    {item.description}
    </Card.Text>
  </Card.Body>
  <ListGroup className="list-group-flush">
    <ListGroupItem>Cras justo odio</ListGroupItem>
    <ListGroupItem>Dapibus ac facilisis in</ListGroupItem>
    <ListGroupItem>Vestibulum at eros</ListGroupItem>
  </ListGroup>
  <Card.Body>
    <Card.Link href="#">Card Link</Card.Link>
    <Card.Link href="#">Another Link</Card.Link>
  </Card.Body>
</Card>
  )
}

export default Item
