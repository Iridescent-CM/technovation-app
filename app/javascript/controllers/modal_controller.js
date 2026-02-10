import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static get targets() {
    return ["flashMessages"];
  }

  connect() {
    this.openModal();
    this.clearFlashMessages();
  }

  openModal() {
    Swal.fire({
      template: "#modal-content",
      width: "50%",
      showCloseButton: true,
      showConfirmButton: false,
    });
  }

  clearFlashMessages() {
    if (this.hasFlashMessagesTarget) {
      flashMessages.innerHTML = "";
    }
  }
}
