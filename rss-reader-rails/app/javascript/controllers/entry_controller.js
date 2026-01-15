import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["markAsReadForm"]

  markAsRead() {
    this.markAsReadFormTarget.requestSubmit()
  }
}
