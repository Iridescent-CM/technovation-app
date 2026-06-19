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
    if (this.errorElement) {
      this.errorElement.remove();
    }
    this.setSubmitDisabled(false);
  }

  validate() {
    const birthdate = this.selectedBirthdate();
    const tooYoung = birthdate && this.ageOn(new Date(), birthdate) < this.minimumValue;

    this.errorElement.hidden = !tooYoung;
    this.setSubmitDisabled(tooYoung);
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
    const wrapper = document.createElement("div");
    wrapper.className = "minimum-age-error";
    wrapper.setAttribute("role", "alert");
    wrapper.setAttribute("aria-live", "polite");
    wrapper.hidden = true;

    const message = document.createElement("p");
    message.className = "minimum-age-error__message";
    message.textContent = `You must be at least ${this.minimumValue} years old.`;

    wrapper.appendChild(message);
    this.element.appendChild(wrapper);
    return wrapper;
  }
}
