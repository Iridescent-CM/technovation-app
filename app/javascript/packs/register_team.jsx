import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import $ from 'jquery';

class TeamRegistration extends Component {
   state = {
     query: "",
     teams: [],
     searching: false,
     searched: false,
   }

  handleChange = (e) => {
    const searching = e.target.value.length >= 3 ? true : false;

    this.setState({
      searching: searching,
      searched: false,
      query: e.target.value,
    });
  }

  performSearch() {
    if (this.state.teams.length > 0) {
      const filteredExistingResults = this.state.teams.filter((team) => {
        return team.name.match(new RegExp("^" + this.state.query, "i"));
      });

      if (filteredExistingResults.length > 0) {
        this.setState({
          searching: false,
          searched: true,
          teams: filteredExistingResults,
        });
      } else {
        this.setState({
          searching: true,
          searched: false,
          teams: [],
        });
      }
    } else {
      $.ajax({
        method: "GET",
        url: "/team_search",
        dataType: "json",
        contentType: "application/json",
        data: { q: this.state.query },

        success: (resp) => {
          this.setState({
            teams: resp.results,
            searching: false,
            searched: true,
          });
        },

        error: (err) => {
          console.log("Error!", err.responseText);

          this.setState({
            searching: false,
            searched: true,
          });
        }
      });
    }
  }

  renderTeamList() {
    if (this.state.searched) {
      return(
        <div className="row align-center">
          <div className="shrink columns">
            <p>Found {this.state.teams.length} results!</p>

            <ul>
              {this.listTeams()}
            </ul>
          </div>
        </div>
      );
    }
  }

  listTeams() {
    return this.state.teams.map((team) => {
      return(
        <li key={team.id}>
          <a href={team.link_to_path}>{team.name}</a>
        </li>
      );
    });
  }

  renderSearchingIndicator() {
    if (this.state.searching) {
      return(
        <div className="row align-center">
          <div className="shrink columns">
            <span className="fa fa-spinner fa-spin" aria-hidden="true"></span>
            &nbsp;Searching...
          </div>
        </div>
      );
    }
  }

  componentDidUpdate() {
    if (this.state.searching)
      this.performSearch();
  }

  render() {
    return(
      <div className="container">
        <div className="row">
          <div className="columns">
            <input
              value={this.state.query}
              onChange={this.handleChange}
              id="team_name"
              type="text"
              placeholder="Your team's name" />
          </div>
        </div>

        {this.renderSearchingIndicator()}
        {this.renderTeamList()}
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <TeamRegistration />,
    document.body.appendChild(document.createElement('div')),
  )
})
