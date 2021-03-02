import React from 'react';
import { Layout } from 'antd';
import './Top.css';

import Searchbar from './Searchbar.js';


const { Header } = Layout;

function Top() {
  return (
    <div className="top">

    <Header style={{ position: 'fixed', zIndex: 1, width: '100%' }}>

      <div className="logo" />
      
      <Searchbar />
      


    </Header>

      
    </div>
  )
}

export default Top

