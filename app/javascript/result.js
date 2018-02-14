export default function Result (res) {
  this.id = res.id;
  this.name = res.name;
  this.email = res.email;
  this.location = res.location;

  this.highlighted = false;

  this.highlight = () => {
    this.highlighted = true;
  };

  this.unhighlight = () => {
    this.highlighted = false;
  };

  this.highlightedClass = () => {
    if (this.highlighted)
      return "autocomplete-list__result--highlighted"
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
};
