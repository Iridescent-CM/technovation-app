import _ from "lodash";

export default function (event) {
  this.id = event.id || "";

  this.name = event.name || "";
  this.city = event.city || "";
  this.venue_address = event.venue_address || "";
  this.eventbrite_link = event.eventbrite_link || "";

  this.division_names = event.division_names || [];
  this.division_ids = event.division_ids || [];

  this.day = event.day || "";
  this.date = event.date || "";
  this.time = event.time || "";
  this.tz = event.tz || "";

  this.starts_at = event.starts_at || "";
  this.ends_at = event.ends_at || "";

  this.errors = event.errors || {};

  this.url = event.url;

  this.managing = false;
  this.editing = false;
  this.managingJudges = false;
  this.managingTeams = false;

  this.selectedJudges = [];
  this.selectedTeams = [];

  this.addJudge = (judge) => {
    var existingIdx = this.selectedJudges.indexOf((j) => {
      return j.id == judge.id
    });

    if (existingIdx === -1) {
      judge.prepareToBeInvited();
      this.selectedJudges.push(judge);
    } else {
      console.log("Judge already added");
      return false;
    }
  };

  this.addTeam = (team) => {
    var existingIdx = this.selectedTeams.indexOf((t) => {
      return t.id == team.id
    });

    if (existingIdx === -1) {
      team.prepareToBeInvited();
      this.selectedTeams.push(team);
    } else {
      console.log("Team already added");
      return false;
    }
  };

  this.selectedJudgeIds = () => {
    return _.map(this.selectedJudges, 'id');
  };

  this.selectedTeamIds = () => {
    return _.map(this.selectedTeams, 'id');
  };

  this.afterSave = () => {
    _.each(this.selectedJudges, (judge) => {
      judge.afterAssign();
    });
  };

  this.afterTeamSave = () => {
    _.each(this.selectedTeams, (team) => {
      team.afterAssign();
    });
  };
};
