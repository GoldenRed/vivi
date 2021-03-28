import React, { useEffect, useState } from 'react';
import './App.css';

import Top from './Components/Top.js';
import Mid from './Components/Mid.js';

import 'bootstrap/dist/css/bootstrap.min.css';

const App = ()=>{

  const [missings, setMissings] = useState([]);




  return (
  <div className="App">
  <Top missings={missings}
   setMissings={setMissings} />
  
  <Mid missings={missings} />

  </div>
  );
};

export default App;