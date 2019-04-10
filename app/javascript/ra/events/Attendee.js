import escapeRegExp from "escape-string-regexp";

export default function Attendee (json) {
  this.persisted = json['persisted?'];
  this.id = json.id;
  this.scope = json.scope;
  this.name = json.name;
  this.links = json.links;
  this.selected = json.selected || false;

  this.hovering = false;

  // Judges, UserInvitations
  this.email = json.email;
  this.addingTeams = false;
  this.assignedTeams = []

  this.isAssignedToTeam = (team) => {
    return this.assignedTeams.includes(team)
  }

  this.assignedTeamFoundInEvent = (team) => {
    verifyNotInList(team, this.assignedTeams, () => {
      this.assignedTeams.push(team)
      team.assignedJudgeFoundInEvent(this)
    })
  }

  this.assignTeam = (team) => {
    verifyNotInList(team, this.assignTeams, () => {
      this.assignedTeams.push(team)
      team.assignJudge(this)
    })
  }

  this.unassignTeam = (team) => {
    verifyInList(team, this.assignedTeams, (idx) => {
      this.assignedTeams.splice(idx, 1)
      team.unassignJudge(this)
    })
  },

  // Teams
  this.submission = json.submission;
  this.division = json.division;
  this.addingJudges = false;

  this.assignedJudges = []

  this.isAssignedToJudge = (judge) => {
    return this.assignedJudges.includes(judge)
  }

  this.assignedJudgeFoundInEvent = (judge) => {
    verifyNotInList(judge, this.assignedJudges, () => {
      this.assignedJudges.push(judge)
      judge.assignedTeamFoundInEvent(this)
    })
  }

  this.assignJudge = (judge) => {
    verifyNotInList(judge, this.assignedJudges, () => {
      notifyRemoteOfAssignmentChange({
        method: 'POST',
        other: judge,
        otherParam: 'judge_id',
        this: this,
        thisParam: 'team_id',
        callback: () => {
          this.assignedJudges.push(judge)
        },
      })
    })
  }

  function verifyNotInList(item, list, callback) {
    const idx = Array.from(list || []).findIndex(i => i.id === item.id)

    if (idx === -1 && !!callback) {
      callback(idx)
    } else {
      return idx === -1
    }
  }

  function verifyInList(item, list, callback) {
    const idx = Array.from(list || []).findIndex(i => i.id === item.id)

    if (idx !== -1 && !!callback) {
      callback(idx)
    } else {
      return idx !== -1
    }
  }

  function notifyRemoteOfAssignmentChange(opts) {
    const url = '/regional_ambassador/judge_assignments'
    const data = new FormData()

    data.append(`judge_assignment[${opts.otherParam}]`, opts.other.id)
    data.append(`judge_assignment[${opts.thisParam}]`, opts.this.id)
    data.append(`judge_assignment[model_scope]`, opts.other.scope)

    $.ajax({
      method: opts.method,
      url: url,
      data: data,
      contentType: false,
      processData: false,

      success: opts.callback,

      error: (err) => {
        console.error(err);
      },
    })
  }

  this.unassignJudge = (judge) => {
    verifyInList(judge, this.assignedJudges, (idx) => {
      notifyRemoteOfAssignmentChange({
        method: 'DELETE',
        other: judge,
        otherParam: 'judge_id',
        this: this,
        thisParam: 'team_id',
        callback: () => {
          this.assignedJudges.splice(idx, 1)
        },
      })
    })
  },

  this.status = json.status || "status missing (bug)";
  this.humanStatus = json.human_status || "status missing (bug)";
  this.statusExplained = json.status_explained;

  this.statusColor = (status => {
    switch(status) {
      case "ready":
        return "green";
      case "submission_incomplete":
        return "orange";
      default:
        return "red";
    };
  })(this.status);

  this.recentlyAdded = false;
  this.sendInvitation = false;

  this.addedToEvent = () => {
    this.recentlyAdded = true;
    this.sendInvitation = true;
    this.selected = true;
  };

  this.removedFromEvent = () => {
    this.recentlyAdded = false;
    this.sendInvitation = false;
    this.selected = false;
  };

  this.assignmentSaved = () => {
    if (this.sendInvitation) {
      this.recentlyInvited = true;
      this.sendInvitation = false;
    }

    if (this.recentlyAdded)
      this.recentlyAdded = false;
  };

  this.matchesQuery = (query) => {
    const escaped = escapeRegExp(query),
          pattern = new RegExp(escaped, "i");

    if (this.scope === "Team") {
      return this.name.match(pattern) ||
        this.submission.name.match(pattern);
    } else {
      return this.name.match(pattern) || this.email.match(pattern);
    }
  }
}
