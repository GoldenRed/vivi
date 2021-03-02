import React from 'react'
import 'antd/dist/antd.css';

import './App.css';
import Top from './Components/Top';
import Recommendations from './Components/Recommendations';
import { Layout } from 'antd';

const { Footer } = Layout;

function App() {
  return (
    <div className="app">

    <Layout>
  
      <Top />
      <Recommendations />



      <Footer> Check it out at https://goldenred.github.io/ </Footer>

    </Layout>
  
    </div>
  );
}

export default App;
