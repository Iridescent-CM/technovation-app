import Attendee from "./Attendee";

export default function (event) {
  this.id = event.id || "";
  this.fetchTeamsUrlRoot = event.fetchTeamsUrlRoot;
  this.fetchJudgesUrlRoot = event.fetchJudgesUrlRoot;

  this.name = event.name || "";
  this.city = event.city || "";
  this.venue_address = event.venue_address || "";
  this.event_link = event.event_link || "";

  this.division_names = event.division_names || [];
  this.division_ids = event.division_ids || [];

  this.day = event.day || "";
  this.date = event.date || "";
  this.time = event.time || "";
  this.tz = event.tz || "";

  this.starts_at = event.starts_at || "";
  this.ends_at = event.ends_at || "";

  this.capacity = event.capacity || null;

  this.officiality = event.officiality

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
    var existingIdx = Array.from(this.selectedJudges || []).findIndex(j => {
      return j.id === judge.id && j.email === judge.email
    });

    if (existingIdx === -1) {
      judge.addedToEvent();
      this.selectedJudges.push(judge);
    } else {
      return false;
    }
  };

  this.removeJudge = (judge) => {
    const existingIdx = Array.from(this.selectedJudges || []).findIndex(j => {
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
    const existingIdx = Array.from(this.selectedTeams || []).findIndex(t => t.id === team.id)

    if (existingIdx === -1) {
      team.addedToEvent();
      this.selectedTeams.push(team);
    } else {
      return false;
    }
  };

  this.removeTeam = (team) => {
    const existingIdx = Array.from(this.selectedTeams || []).findIndex(t => {
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
    return Array.from(this.selectedJudges || []).map(j => j.id)
  }

  this.selectedTeamIds = () => {
    return Array.from(this.selectedTeams || []).map(t => t.id)
  }

  this.judgeAssignmentsSaved = () => {
    Array.from(this.selectedJudges || []).forEach(judge => judge.assignmentSaved())
  }

  this.teamAssignmentsSaved = () => {
    Array.from(this.selectedTeams || []).forEach(t => t.assignmentSaved())
  }

  this.findTeam = (id) => {
    return Array.from(this.selectedTeams || [])
      .find(team => team.id === id)
  }

  this.findJudge = (id) => {
    return Array.from(this.selectedJudges || [])
      .find(judge => judge.id === id)
  }

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
    return this.selectedTeams.length >= 8
  }

  this.resultReadyForList = (result, list) => {
    let attendee = new Attendee(result)

    Array.from(result.assignments.judge_ids || []).forEach(id => {
      const idx = Array.from(this.selectedJudges || []).findIndex(j => j.id === id)
      if (idx !== -1)
        attendee.assignedJudgeFoundInEvent(this.selectedJudges[idx])
    })

    Array.from(result.assignments.team_ids || []).forEach(id => {
      const idx = Array.from(this.selectedTeams || []).findIndex(t => t.id === id)
      if (idx !== -1)
        attendee.assignedTeamFoundInEvent(this.selectedTeams[idx])
    })

    const idx = Array.from(list || []).findIndex(i => i.id === attendee.id)

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
            Array.from(resp.data || []).forEach(result => {
              // Need to massage this data since serializers modify the JSON structure
              result.attributes.id = result.id
              opts.event.resultReadyForList(result.attributes, opts.list)
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
