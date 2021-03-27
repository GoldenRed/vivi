import React, { useEffect, useState } from 'react';
import './App.css';

import Top from './components/Top.js';
import Mid from './components/Mid.js';

import 'bootstrap/dist/css/bootstrap.min.css';

const App = ()=>{

  const [videos, setVideos] = useState([]);


  const getData = async () => {
    const url = `http://jsonplaceholder.typicode.com/photos` 
    const response = await fetch(url);
    console.log(response);
  }

  return (
  <div className="App">
  <Top />

  <Mid />

  </div>
  );
};

export default App;