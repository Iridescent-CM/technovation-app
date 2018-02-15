export default function Judge (res) {
  this.id = res.id;
  this.name = res.name;
  this.email = res.email;
  this.location = res.location;

  this.highlighted = false;
  this.sendInvitation = false;
  this.recentlyAdded = false;

  this.prepareToInvite = (event) => {
    this.recentlyAdded = true;
    this.sendInvitation = true;
  };

  this.highlight = () => {
    this.highlighted = true;
  };

  this.unhighlight = () => {
    this.highlighted = false;
  };

  this.match = (pattern) => {
    var regexp = new RegExp(pattern, "i");

    return !!this.name.match(regexp) ||
      !!this.email.match(regexp);
  };

  this.highlightMatch = (prop, query) => {
    var regexp = new RegExp("(" + query + ")", "gi");
    return this[prop].replace(regexp, "<b>$1</b>");
  };

  this.afterAssign = () => {
    this.recentlyAdded = false;
    this.sendInvitation = false;
  };
};
