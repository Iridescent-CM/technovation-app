export default function Attendee (json) {
  this.id = parseInt(json.id);
  this.scope = json.scope;
  this.name = json.name;
  this.submission = json.submission;
  this.division = json.division;

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
}
