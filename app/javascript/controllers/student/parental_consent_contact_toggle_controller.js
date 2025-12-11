import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "emailField", "phoneNumberField", "checkbox"]
  }

  initialize() {
    this.toggle()
  }

  toggle(){
   if(this.checkboxTarget.checked) {
     this.showPhone()
   } else {
     this.showEmail()
   }
  }

  showEmail(){
    this.emailFieldTarget.style.display = "block"
    this.phoneNumberFieldTarget.style.display = "none"
  }

  showPhone(){
    this.phoneNumberFieldTarget.style.display = "block"
    this.emailFieldTarget.style.display = "none"
  }
}
