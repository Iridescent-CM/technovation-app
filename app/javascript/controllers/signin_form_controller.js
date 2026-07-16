import { Controller } from "@hotwired/stimulus";

// Keeps the Sign In submit button disabled until the password field has a value,
// so blank-password submits do not burn failed-attempt counts.
export default class extends Controller {
  static targets = ["password", "submit"];

  connect() {
    this.syncSubmitState();
  }

  syncSubmitState() {
    if (!this.hasPasswordTarget || !this.hasSubmitTarget) return;

    this.submitTarget.disabled = this.passwordTarget.value.trim() === "";
  }
}
