import escapeRegExp from "escape-string-regexp";

export default function Attendee (json) {
  this.id = parseInt(json.id);
  this.scope = json.scope;
  this.name = json.name;
  this.links = json.links;
  this.selected = json.selected || false;

  // Judges, UserInvitations
  this.email = json.email;
  this.selectedForTeam = null;

  this.isSelectedForTeam = (team) => {
    return this.selectedForTeam === team
  }

  // Teams
  this.submission = json.submission;
  this.division = json.division;
  this.hovering = false;
  this.addingJudges = false;

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
