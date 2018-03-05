export default function Attendee (json) {
  this.id = parseInt(json.id);
  this.scope = json.scope;
  this.name = json.name;
  this.submission = json.submission;
  this.division = json.division;
  this.links = json.links;

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

  this.selected = false;
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
}
