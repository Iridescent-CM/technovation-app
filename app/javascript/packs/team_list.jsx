import React from 'react';

const TeamList = props => {
  function renderList() {
    return props.teams.map((team) => {
      return(
        <li key={team.id}>
          <a href={team.link_to_path}>{team.name}</a>
        </li>
      );
    });
  }

  return(
    <ul className="lists--search-results">
      {renderList()}
    </ul>
  );
}

export default TeamList;
