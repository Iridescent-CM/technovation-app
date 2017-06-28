import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import $ from 'jquery';

class TeamRegistrationForm extends Component {
  state = {
    team_name: this.props.teamName,
  }

  handleChange = (e) => {
    this.setState({
      team_name: e.target.value,
    });
  }

  handleClick = (e) => {
    $.ajax({
      method: "POST",
      url: this.props.url,

      beforeSend: (xhr) => {
        xhr.setRequestHeader(
          'X-CSRF-Token',
          $('meta[name="csrf-token"]').attr('content')
        );
      },

      data: {
        team: {
          name: this.state.team_name,
        },
      },

      success: (data) => {
        console.log(data);
      },

      error: (err) => {
        console.log(err.responseText);
      },
    });
  }

  render() {
    return(
      <div className="container">
        <div className="row align-center">
          <div className="columns large-6">
            <h1>Register your team</h1>

            <label htmlFor="team_name">
              First, tell us your team's name
            </label>

            <div className="input-group">
              <input
                className="input-group-field"
                name="team_name"
                type="text"
                value={this.state.team_name}
                onChange={this.handleChange}
              />

              <div className="input-group-button">
                <input
                  type="submit"
                  className="button"
                  value="Next"
                  onClick={this.handleClick}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const data = $('#react-register-team-data').data();

  ReactDOM.render(
    <TeamRegistrationForm {...data} />,
    document.body.appendChild(document.createElement('div')),
  )
})
