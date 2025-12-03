import { Controller } from "@hotwired/stimulus";
import { debounce } from "../../utilities/utilities"

export default class extends Controller {
  connect() {
    this.submit = debounce(this.submit.bind(this), 300);
  }

  search() {
    this.element.requestSubmit();
  }
}
