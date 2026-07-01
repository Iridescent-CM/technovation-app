import { Controller } from "@hotwired/stimulus";

// Validates the assembled date_of_birth `<select>`s when the form is submitted,
// mirroring the server-side rules (date of birth may be required or optional,
// and when provided must meet the minimum age). On an invalid submit it blocks
// and shows an inline error in the same `.field_with_errors > .error` markup the
// rest of the form uses. The Save button stays enabled, consistent with how
// first/last name validation behaves.
export default class extends Controller {
  static values = { minimum: Number, optional: Boolean };

  connect() {
    this.selects = Array.from(this.element.querySelectorAll("select"));
    if (this.selects.length < 3) return;

    this.form = this.element.closest("form");
    if (!this.form) return;

    this.errorElement = this.buildErrorElement();
    this.initialBirthdateKey = this.currentBirthdateKey();
    this.boundValidateOnSubmit = this.validateOnSubmit.bind(this);
    this.form.addEventListener("submit", this.boundValidateOnSubmit);
  }

  disconnect() {
    if (this.form && this.boundValidateOnSubmit) {
      this.form.removeEventListener("submit", this.boundValidateOnSubmit);
    }
  }

  validateOnSubmit(event) {
    const message = this.errorMessage();

    if (message) {
      // preventDefault blocks the submit; stopImmediatePropagation keeps the
      // event from bubbling to the document-level jQuery UJS handler, which
      // would otherwise disable the submit button (via data-disable-with) and
      // leave it stuck disabled since the form never actually submits.
      event.preventDefault();
      event.stopImmediatePropagation();
      this.showError(message);
      this.errorElement.scrollIntoView({ block: "center", behavior: "smooth" });
    } else {
      this.hideError();
    }
  }

  // Returns the error string to display, or null when the date is valid.
  errorMessage() {
    if (this.optionalValue && this.noFragmentsSelected()) {
      return null;
    }

    if (!this.allFragmentsSelected()) {
      if (this.optionalValue) {
        return "Please enter a complete date of birth.";
      }

      return "Date of birth is required.";
    }

    const birthdate = this.selectedBirthdate();
    if (birthdate === null) {
      if (this.optionalValue) {
        return "Please enter a complete date of birth.";
      }

      return "Date of birth is required.";
    }

    // Mentors may keep an existing under-18 DOB unchanged; the server only
    // enforces 18+ when date_of_birth_changed? — mirror that on submit.
    if (
      this.optionalValue &&
      this.initialBirthdateKey !== null &&
      this.currentBirthdateKey() === this.initialBirthdateKey
    ) {
      return null;
    }

    if (this.ageOn(new Date(), birthdate) < this.minimumValue) {
      return `You must be at least ${this.minimumValue} years old.`;
    }

    return null;
  }

  noFragmentsSelected() {
    return !this.anyFragmentSelected();
  }

  anyFragmentSelected() {
    return ["1i", "2i", "3i"].some((fragment) => {
      const select = this.selectForFragment(fragment);
      return select && select.value !== "";
    });
  }

  allFragmentsSelected() {
    return ["1i", "2i", "3i"].every((fragment) => {
      const select = this.selectForFragment(fragment);
      return select && select.value !== "";
    });
  }

  selectedBirthdate() {
    const year = this.valueForFragment("1i");
    const month = this.valueForFragment("2i");
    const day = this.valueForFragment("3i");

    if (!year || !month || !day) return null;

    const birthdate = new Date(year, month - 1, day);
    if (
      birthdate.getFullYear() !== year ||
      birthdate.getMonth() !== month - 1 ||
      birthdate.getDate() !== day
    ) {
      return null;
    }
    return birthdate;
  }

  currentBirthdateKey() {
    if (this.noFragmentsSelected()) return "";

    if (!this.allFragmentsSelected()) return null;

    const birthdate = this.selectedBirthdate();
    if (!birthdate) return null;

    return this.formatBirthdateKey(birthdate);
  }

  formatBirthdateKey(birthdate) {
    return `${birthdate.getFullYear()}-${
      birthdate.getMonth() + 1
    }-${birthdate.getDate()}`;
  }

  selectForFragment(fragment) {
    return this.selects.find((element) =>
      element.name.includes(`(${fragment})`)
    );
  }

  valueForFragment(fragment) {
    const select = this.selectForFragment(fragment);
    if (!select || select.value === "") return NaN;

    const parsed = parseInt(select.value, 10);
    return Number.isNaN(parsed) ? NaN : parsed;
  }

  ageOn(today, birthdate) {
    let age = today.getFullYear() - birthdate.getFullYear();
    const monthDiff = today.getMonth() - birthdate.getMonth();
    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthdate.getDate())
    ) {
      age -= 1;
    }
    return age;
  }

  showError(message) {
    this.messageElement.textContent = message;
    this.errorElement.style.display = "";
  }

  hideError() {
    this.errorElement.style.display = "none";
  }

  buildErrorElement() {
    // Mirror Rails' `.field_with_errors > .error` markup so the message picks
    // up the app's existing red validation-error styling.
    const wrapper = document.createElement("div");
    wrapper.className = "field_with_errors minimum-age-error";
    wrapper.style.display = "none";

    this.messageElement = document.createElement("span");
    this.messageElement.className = "error";

    wrapper.appendChild(this.messageElement);
    this.element.appendChild(wrapper);
    return wrapper;
  }
}
