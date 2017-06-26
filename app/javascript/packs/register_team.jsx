import React from 'react'
import ReactDOM from 'react-dom'

const TeamRegistration = props => (
  <div className="row">
    <div className="small-12 medium-4 column">col 1</div>
    <div className="small-12 medium-4 column">col 2</div>
    <div className="small-12 medium-4 column">col 3</div>
  </div>
);

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <TeamRegistration />,
    document.body.appendChild(document.createElement('div')),
  )
})
