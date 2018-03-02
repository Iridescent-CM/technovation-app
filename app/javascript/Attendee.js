export default function Attendee (json) {
  this.id = json.id;
  this.name = json.name;
  this.submission = json.submission;
  this.selected = false;

  this.toggleSelection = () => {
    this.selected = !this.selected;
  }
}
