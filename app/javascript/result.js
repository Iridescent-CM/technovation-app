export default function Result (res) {
  this.id = res.id;
  this.name = res.name;
  this.email = res.email;
  this.highlighted = false;

  this.display = res.name + " - " + res.email;

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

  this.highlightMatch = (query) => {
    var regexp = new RegExp("(" + query + ")", "gi");
    return this.display.replace(regexp, "<b>$1</b>");
  };
};
