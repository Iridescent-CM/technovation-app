import _ from "lodash";
import Attendee from "./Attendee";

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

  this.isFetchingJudges = false
  this.isFetchingTeams = false
  this.hasFetchedJudges = false
  this.hasFetchedTeams = false

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
      return j.id === judge.id && j.email === judge.email
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
      return j.id === judge.id && j.email === judge.email
    });

    if (existingIdx !== -1) {
      judge.removedFromEvent();
      this.selectedJudges.splice(existingIdx, 1);
    } else {
      return false;
    }
  };

  this.addTeam = (team) => {
    const existingIdx = _.findIndex(this.selectedTeams, t => t.id === team.id)

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

  this.judgeAssignmentsSaved = () => {
    _.each(this.selectedJudges, (judge) => { judge.assignmentSaved() });
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
    const event = this

    return new Promise((resolve, reject) => {
      if (event.isFetchingTeams || event.hasFetchedTeams) resolve()

      event.isFetchingTeams = true
      const url = event.fetchTeamsUrlRoot + "?event_id=" + event.id;

      event.getRemoteData({
        list: event.selectedTeams,
        url: url,
        event: event,
      }).then(() => {
        event.isFetchingTeams = false
        event.hasFetchedTeams = true
        resolve()
      }).catch((err) => { reject(err) })
    })
  }

  this.fetchJudges = (opts) => {
    const event = this

    return new Promise((resolve, reject) => {
      if (event.isFetchingJudges || event.hasFetchedJudges) resolve()

      event.isFetchingJudges = true
      const url = event.fetchJudgesUrlRoot + "?event_id=" + event.id;

      event.getRemoteData({
        list: event.selectedJudges,
        url: url,
        event: event,
      }).then(() => {
        event.isFetchingJudges = false
        event.hasFetchedJudges = true
        resolve()
      }).catch((err) => { reject(err) })
    })
  }

  this.teamListIsTooLong = () => {
    return this.selectedTeams.length >= 15
  }

  this.resultReadyForList = (result, list) => {
    let attendee = new Attendee(result)

    _.each(result.assignments.judge_ids, id => {
      const idx = _.findIndex(this.selectedJudges, j => j.id === id)
      if (idx !== -1)
        attendee.assignedJudgeFoundInEvent(this.selectedJudges[idx])
    })

    _.each(result.assignments.team_ids, id => {
      const idx = _.findIndex(this.selectedTeams, t => t.id === id)
      if (idx !== -1)
        attendee.assignedTeamFoundInEvent(this.selectedTeams[idx])
    })

    const idx = _.findIndex(list, i => i.id === attendee.id)

    if (idx === -1)
      list.push(attendee)
  }

  this.getRemoteData = (opts) => {
    return new Promise((resolve, reject) => {
      opts = opts || {}

      if (opts.list.length) {
        resolve()
      } else {
        $.ajax({
          method: "GET",
          url: opts.url,

          success (resp) {
            _.each(resp, (result) => {
              opts.event.resultReadyForList(result, opts.list)
            })
            resolve(resp)
          },

          error (err) { reject(err) },

          complete () {
            resolve()
          },
        });
      }
    })
  }
};
