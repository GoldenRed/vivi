import React, { useState } from 'react';
import Mid from './Mid.js';
import SearchBar from './SearchBar.js';


function SearchPage(){
  
  const [items, setItems] = useState([]);
  
  return(
    <div className="SearchPage">

    <SearchBar items={items}
    setItems={setItems} />

    <Mid items={items} />

    </div>
  )

}


export default SearchPage