import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    storageKey: { type: String, default: "pardon_our_dust_banner_dismissed" },
  };

  connect() {
    if (localStorage.getItem(this.storageKeyValue) === "true") {
      this.element.remove();
      return;
    }

    this.element.style.display = "";
  }

  dismiss() {
    localStorage.setItem(this.storageKeyValue, "true");
    this.element.remove();
  }
}
