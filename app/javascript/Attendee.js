import escapeRegExp from "escape-string-regexp";

export default function Attendee (json) {
  this.id = parseInt(json.id);
  this.scope = json.scope;
  this.name = json.name;
  this.links = json.links;
  this.selected = json.selected || false;

  this.hovering = false;

  // Judges, UserInvitations
  this.email = json.email;
  this.assignedTeams = []
  this.addingTeams = false;

  this.isAssignedToTeam = (team) => {
    return this.assignedTeams.includes(team)
  }

  this.assignTeam = (team) => {
    const idx = _.findIndex(this.assignedTeams, t => {
      return t.id === team.id
    })

    if (idx === -1) {
      this.assignedTeams.push(team)
    }
  }

  this.unassignTeam = (team) => {
    const idx = _.findIndex(this.assignedTeams, t => {
      return t.id === team.id
    })

    if (idx !== -1) {
      this.assignedTeams.splice(idx, 1)
    }
  },

  // Teams
  this.submission = json.submission;
  this.division = json.division;
  this.addingJudges = false;

  this.assignedJudges = []

  this.isAssignedToJudge = (judge) => {
    return this.assignedJudges.includes(judge)
  }

  this.assignJudge = (judge) => {
    const idx = _.findIndex(this.assignedJudges, j => {
      return j.id === judge.id
    })

    if (idx === -1) {
      this.assignedJudges.push(judge)
    }
  }

  this.unassignJudge = (judge) => {
    const idx = _.findIndex(this.assignedJudges, j => {
      return j.id === judge.id
    })

    if (idx !== -1) {
      this.assignedJudges.splice(idx, 1)
    }
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
