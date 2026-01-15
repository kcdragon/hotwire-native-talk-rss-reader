import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeTheme()
    this.setupEventListener()
  }

  disconnect() {
    if (this.eventListener) {
      document.removeEventListener(this.eventListenerName(), this.eventListener)
    }
  }

  initializeTheme() {
    const stored = localStorage.getItem('themeMode')
    const isDark = stored
      ? stored === 'dark'
      : matchMedia('(prefers-color-scheme: dark)').matches

    if (isDark) {
      document.documentElement.classList.add('dark')
    }
  }

  setupEventListener() {
    this.eventListener = (event) => {
      const mode = event.detail?.mode
      const isDark = mode === 'dark' ? true
                    : mode === 'light' ? false
                    : !document.documentElement.classList.contains('dark')
      this.applyTheme(isDark)
    }
    document.addEventListener(this.eventListenerName(), this.eventListener)
  }

  toggle() {
    const isDark = !document.documentElement.classList.contains('dark')
    this.applyTheme(isDark)
  }

  applyTheme(dark) {
    document.documentElement.classList.toggle('dark', dark)
    localStorage.setItem('themeMode', dark ? 'dark' : 'light')
  }

  eventListenerName() {
    return 'basecoat:theme'
  }
}
