import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "sign-in-with-oauth"
  static values = {
    startPath: String,
    tokenAuthPath: String,
  }

  interceptSubmit(event) {
    event.preventDefault()

    const startPath = this.startPathValue
    const tokenAuthPath = this.tokenAuthPathValue
    this.send("click", { startPath, tokenAuthPath })
  }
}
