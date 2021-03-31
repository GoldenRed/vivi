import React from 'react';
import './App.css';


import { BrowserRouter, Route, Switch} from 'react-router-dom';
import Nav from './Pages/Nav.js';
import SearchPage from './Pages/SearchPage/SearchPage.js';
import About from './Pages/About/About.js';
import Submit from './Pages/Submit/Submit.js';
import Item from './Pages/SearchPage/Item.js';

import 'bootstrap/dist/css/bootstrap.min.css';

function App() {

  return (
  <BrowserRouter>
    <div className="App">
      <Nav />
      <Switch>
        <Route path="/" exact component={SearchPage} />
        <Route path="/item/:id" component={Item} />
        <Route path="/about" component={About} />
        <Route path="/submit" component={Submit} />
      </Switch>

    </div>
  </BrowserRouter>
  );
};

export default App;