import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import $ from 'jquery';

import TeamList from './team_list';

class TeamRegistration extends Component {
  state = {
    query: "",
    matched_teams: [],
    cached_results: [],
    should_search: false,
    performed_search: false,
  }

  componentDidUpdate() {
    if (this.state.should_search)
      this.performSearch();
  }

  handleChange = (e) => {
    const should_search = e.target.value.length >= 3 ? true : false;

    this.setState({
      should_search: should_search,
      performed_search: false,
      query: e.target.value,
    });
  }

  performSearch() {
    if (this.state.matched_teams.length > 0) {
      this._performLocalSearch();
    } else {
      this._performRemoteSearch();
    }
  }

  renderTeamList() {
    if (this.state.matched_teams.length > 0 || this.state.performed_search) {
      return(
        <div>
          <p>Found {this.state.matched_teams.length} results!</p>
          <TeamList teams={this.state.matched_teams} />
        </div>
      );
    }
  }

  renderSearchingIndicator() {
    if (this.state.should_search) {
      return(
        <div>
          <span className="fa fa-spinner fa-spin" aria-hidden="true"></span>
          &nbsp;Searching...
        </div>
      );
    }
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

  _performLocalSearch() {
    let should_search, performed_search, matched_teams;

    const filteredExistingResults = this.state.cached_results.filter((team) => {
      return team.name.match(new RegExp("^" + this.state.query, "i"));
    });

    if (filteredExistingResults.length > 0) {
      should_search = false;
      performed_search = true;
      matched_teams = filteredExistingResults;
    } else {
      should_search = true;
      performed_search = false;
      matched_teams = [];
    }

    this.setState({
      should_search,
      performed_search,
      matched_teams
    });
  }

  _performRemoteSearch() {
    $.ajax({
      method: "GET",
      url: "/team_search",
      dataType: "json",
      contentType: "application/json",
      data: { q: this.state.query },

      success: (resp) => {
        this.setState({
          matched_teams: resp.results,
          cached_results: resp.results,
          should_search: false,
          performed_search: true,
        });
      },

      error: (err) => {
        console.log("Error!", err.responseText);

        this.setState({
          matched_teams: [],
          cached_results: [],
          should_search: false,
          performed_search: true,
        });
      }
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <TeamRegistration />,
    document.body.appendChild(document.createElement('div')),
  )
})
