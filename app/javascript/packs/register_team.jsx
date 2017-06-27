import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import $ from 'jquery';

class TeamRegistration extends Component {
   state = {
     query: "",
     teams: [],
     search_cache: [],
     searching: false,
     performed_search: false,
   }

  handleChange = (e) => {
    const searching = e.target.value.length >= 3 ? true : false;

    this.setState({
      searching: searching,
      performed_search: false,
      query: e.target.value,
    });
  }

  performSearch() {
    if (this.state.teams.length > 0) {
      const filteredExistingResults = this.state.search_cache.filter((team) => {
        return team.name.match(new RegExp("^" + this.state.query, "i"));
      });

      if (filteredExistingResults.length > 0) {
        this.setState({
          searching: false,
          performed_search: true,
          teams: filteredExistingResults,
        });
      } else {
        this.setState({
          searching: true,
          performed_search: false,
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
            search_cache: resp.results,
            searching: false,
            performed_search: true,
          });
        },

        error: (err) => {
          console.log("Error!", err.responseText);

          this.setState({
            teams: [],
            search_cache: [],
            searching: false,
            performed_search: true,
          });
        }
      });
    }
  }

  renderTeamList() {
    if (this.state.teams.length > 0 || this.state.performed_search) {
      return(
        <div>
          <p>Found {this.state.teams.length} results!</p>

          <ul>
            {this.listTeams()}
          </ul>
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
        <div>
          <span className="fa fa-spinner fa-spin" aria-hidden="true"></span>
          &nbsp;Searching...
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
        <div className="row stack align-center">
          <h1 className="heading1">
            Welcome to Technovation
          </h1>

          <div className="medium-7 columns major-focus-box">
            <label htmlFor="team_name">Register your team</label>

            <input
              value={this.state.query}
              onChange={this.handleChange}
              name="team_name"
              type="text"
              placeholder="Team Name" />

            {this.renderSearchingIndicator()}
            {this.renderTeamList()}
          </div>
        </div>
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
