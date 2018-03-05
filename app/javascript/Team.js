export default function Team (res) {
  this.id = parseInt(res.id);
  this.name = res.name;
  this.division = res.division;
  this.scope = res.scope;
  this.viewUrl = res.view_url;
  this.viewSubmissionUrl = res.view_submission_url;
  this.submissionName = res.submission;

  this.status = res.status || "status missing (bug)";
  this.humanStatus = res.human_status || "status missing (bug)";
  this.statusExplained = res.status_explained;

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

  this.location = res.location;

  this.highlighted = false;
  this.sendInvitation = false;
  this.recentlyAdded = false;
  this.recentlyInvited = false;

  this.highlight = () => {
    this.highlighted = true;
  };

  this.unhighlight = () => {
    this.highlighted = false;
  };

  this.match = (namePattern) => {
    var name_spec = new RegExp(namePattern, "i");

    return !!this.name.match(name_spec);
  };

  this.highlightMatch = (prop, query) => {
    var regexp = new RegExp("(" + query + ")", "gi");
    return this[prop].replace(regexp, "<b>$1</b>");
  };

  this.afterAssign = () => {
    if (this.sendInvitation) {
      this.recentlyInvited = true;
      this.sendInvitation = false;
    }

    if (this.recentlyAdded)
      this.recentlyAdded = false;
  };
};
