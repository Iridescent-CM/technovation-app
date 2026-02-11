import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static get values() {
    return {
      url: String,
    };
  }

  change(event) {
    const currentParams = new URLSearchParams(window.location.search);
    const selectedLang = event.target.value;

    currentParams.set("lang", selectedLang);

    const urlWithParams = `${this.urlValue}?${currentParams.toString()}`;

    window.location.href = urlWithParams;
  }
}
