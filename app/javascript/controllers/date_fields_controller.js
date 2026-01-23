import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ["startDate", "endDate"];
  }

  setEndDateValues() {
    const startDate = this.startDateTarget;
    const endDate = this.endDateTarget;

    if (endDate.value.trim() == "") {
      endDate.value = startDate.value;
    }

    endDate.setAttribute("min", startDate.value);
  }
}
