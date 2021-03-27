import React, { useEffect, useState } from 'react';
import './App.css';

import Top from './Components/Top.js';
import Mid from './Components/Mid.js';

import 'bootstrap/dist/css/bootstrap.min.css';

const App = ()=>{

  const [videos, setVideos] = useState([]);




  return (
  <div className="App">
  <Top setVideos={setVideos} />
  

  <Mid videos={videos} />

  </div>
  );
};

export default App;