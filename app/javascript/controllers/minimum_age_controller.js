import { Controller } from "@hotwired/stimulus";

// Validates the assembled date_of_birth `<select>`s against a minimum age.
// The year dropdown alone cannot enforce the minimum (a year 18 ago paired
// with a month/day still to come is under 18), so this checks the full date.
export default class extends Controller {
  static values = { minimum: Number };

  connect() {
    this.selects = Array.from(this.element.querySelectorAll("select"));
    if (this.selects.length < 3) return;

    this.errorElement = this.buildErrorElement();
    this.boundValidate = this.validate.bind(this);
    this.selects.forEach((select) =>
      select.addEventListener("change", this.boundValidate)
    );
    this.validate();
  }

  disconnect() {
    if (this.selects) {
      this.selects.forEach((select) =>
        select.removeEventListener("change", this.boundValidate)
      );
    }
    this.setSubmitDisabled(false);
  }

  validate() {
    const birthdate = this.selectedBirthdate();

    if (birthdate && this.ageOn(new Date(), birthdate) < this.minimumValue) {
      this.errorElement.style.display = "";
      this.setSubmitDisabled(true);
    } else {
      this.errorElement.style.display = "none";
      this.setSubmitDisabled(false);
    }
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

  valueForFragment(fragment) {
    const select = this.selects.find((element) =>
      element.name.includes(`(${fragment})`)
    );
    return select ? parseInt(select.value, 10) : NaN;
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

  setSubmitDisabled(disabled) {
    const form = this.element.closest("form");
    if (!form) return;
    const submit = form.querySelector(
      'input[type="submit"], button[type="submit"]'
    );
    if (submit) submit.disabled = disabled;
  }

  buildErrorElement() {
    // Mirror Rails' `.field_with_errors > .error` markup so the message picks
    // up the app's existing red validation-error styling.
    const wrapper = document.createElement("div");
    wrapper.className = "field_with_errors minimum-age-error";
    wrapper.style.display = "none";

    const message = document.createElement("p");
    message.className = "error";
    message.textContent = `You must be at least ${this.minimumValue} years old.`;

    wrapper.appendChild(message);
    this.element.appendChild(wrapper);
    return wrapper;
  }
}
