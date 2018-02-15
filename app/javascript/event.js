import _ from "lodash";

export default function (event) {
  this.id = event.id || "";

  this.name = event.name || "";
  this.city = event.city || "";
  this.venue_address = event.venue_address || "";
  this.eventbrite_link = event.eventbrite_link || "";

  this.division_names = event.division_names || [];
  this.division_ids = event.division_ids || [];

  this.day = event.day || "";
  this.date = event.date || "";
  this.time = event.time || "";
  this.tz = event.tz || "";

  this.starts_at = event.starts_at || "";
  this.ends_at = event.ends_at || "";

  this.errors = event.errors || {};

  this.url = event.url;

  this.managing = false;
  this.selectedJudges = [];

  this.addJudge = (judge) => {
    judge.prepareToInvite();
    this.selectedJudges.push(judge);
  };

  this.selectedJudgeIds = () => {
    return _.map(this.selectedJudges, (j) => { return j.id; });
  };

  this.afterSave = () => {
    _.each(this.selectedJudges, (judge) => {
      judge.afterAssign();
    });
  };
};
