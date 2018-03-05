export default function Attendee (json) {
  this.id = parseInt(json.id);
  this.scope = json.scope;
  this.name = json.name;
  this.submission = json.submission;
  this.division = json.division;

  this.selected = false;

  this.toggleSelection = () => {
    this.selected = !this.selected;
  }

  this.recentlyAdded = false;
  this.sendInvitation = false;

  this.prepareToBeInvited = (event) => {
    this.recentlyAdded = true;
    this.sendInvitation = true;
  };
}
