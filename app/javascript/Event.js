import _ from "lodash";
import Attendee from "./Attendee";
import Judge from "./Judge";

export default function (event) {
  this.id = event.id || "";
  this.fetchTeamsUrlRoot = event.fetchTeamsUrlRoot;
  this.fetchJudgesUrlRoot = event.fetchJudgesUrlRoot;

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

  this.toggleManaging = (prop) => {
    var wasManaging = this[prop];

    this.managingJudges = false;
    this.managingTeams = false;
    this.managing = false;
    this.editing = false;

    this[prop] = !wasManaging;
    this.managing = this[prop];
  };

  this.addJudge = (judge) => {
    var existingIdx = _.findIndex(this.selectedJudges, j => {
      return j.id == judge.id
    });

    if (existingIdx === -1) {
      judge.addedToEvent();
      this.selectedJudges.push(judge);
    } else {
      console.log("Judge already added");
      return false;
    }
  };

  this.removeJudge = (judge) => {
    const existingIdx = _.findIndex(this.selectedJudges, j => {
      return j.id === judge.id;
    });

    if (existingIdx !== -1) {
      judge.removedFromEvent();
      this.selectedJudges.splice(existingIdx, 1);
    } else {
      return false;
    }
  };

  this.addTeam = (team) => {
    const existingIdx = _.findIndex(this.selectedTeams, t => {
      return t.id === team.id
    });

    if (existingIdx === -1) {
      team.addedToEvent();
      this.selectedTeams.push(team);
    } else {
      console.log("Team already added");
      return false;
    }
  };

  this.removeTeam = (team) => {
    const existingIdx = _.findIndex(this.selectedTeams, t => {
      return t.id === team.id;
    });

    if (existingIdx !== -1) {
      team.removedFromEvent();
      this.selectedTeams.splice(existingIdx, 1);
    } else {
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

  this.teamAssignmentsSaved = () => {
    _.each(this.selectedTeams, t => { t.assignmentSaved() });
  };

  this.findTeam = (id) => {
    return _.find(this.selectedTeams, (team) => {
      return team.id === parseInt(id);
    });
  };

  this.findJudge = (id) => {
    return _.find(this.selectedJudges, (judge) => {
      return judge.id === parseInt(id);
    });
  };

  this.fetchTeams = (opts) => {
    var event = this,
        url = event.fetchTeamsUrlRoot + "?event_id=" + event.id;

    opts = opts || {};
    opts.onComplete = opts.onComplete || function () { return false; };

    if (event.selectedTeams.length) {
      opts.onComplete();
      return false;
    } else {
      $.ajax({
        method: "GET",
        url: url,

        success: (resp) => {
          _.each(resp, (result) => {
            var team = new Attendee(result);
            event.selectedTeams.push(team)
          });
        },

        error: (err) => {
          console.log(err);
        },

        complete: () => {
          opts.onComplete()
        },
      });
    }
  };

  this.fetchJudges = (opts) => {
    var event = this,
        url = event.fetchJudgesUrlRoot + "?event_id=" + event.id;

    opts = opts || {};
    opts.onComplete = opts.onComplete || function () { return false; };

    if (event.selectedJudges.length) {
      opts.onComplete();
      return false;
    } else {
      $.ajax({
        method: "GET",
        url: url,

        success: (resp) => {
          _.each(resp, (result) => {
            var judge = new Judge(result);
            event.selectedJudges.push(judge)
          });
        },

        error: (err) => {
          console.log(err);
        },

        complete: () => {
          opts.onComplete();
        },
      });
    }
  };
};
