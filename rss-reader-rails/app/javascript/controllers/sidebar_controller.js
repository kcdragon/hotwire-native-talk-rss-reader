import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static STORAGE_KEY = 'sidebarState'
  static targets = ["sidebar"]
  static values = {
    initialOpen: { type: Boolean, default: true },
    initialMobileOpen: { type: Boolean, default: false },
    breakpoint: { type: Number, default: 768 }
  }

  connect() {
    this.initializeSidebarState()
    this.updateState()
  }

  initializeSidebarState() {
    const stored = this.getStoredState()

    if (stored !== null) {
      // Use stored preference if available
      this.open = stored
    } else {
      // Fall back to size-based defaults for first-time users
      const breakpoint = this.breakpointValue
      this.open = breakpoint > 0
        ? (window.innerWidth >= breakpoint ? this.initialOpenValue : this.initialMobileOpenValue)
        : this.initialOpenValue
    }
  }

  getStoredState() {
    try {
      const stored = localStorage.getItem(this.constructor.STORAGE_KEY)
      return stored !== null ? stored === 'true' : null
    } catch (e) {
      console.warn('localStorage unavailable for sidebar state:', e)
      return null
    }
  }

  updateState() {
    const sidebarComponent = this.sidebarTarget
    sidebarComponent.setAttribute('data-sidebar-initialized', 'true')
    sidebarComponent.setAttribute('aria-hidden', !this.open)
    
    if (this.open) {
      sidebarComponent.removeAttribute('inert')
    } else {
      sidebarComponent.setAttribute('inert', '')
    }
  }

  setState(state) {
    this.open = state
    this.updateState()
    this.saveState(state)
  }

  saveState(state) {
    try {
      localStorage.setItem(this.constructor.STORAGE_KEY, state ? 'true' : 'false')
    } catch (e) {
      console.warn('Failed to save sidebar state:', e)
    }
  }

  open() {
    this.setState(true)
  }

  close() {
    this.setState(false)
  }

  handleClick(event) {
    const target = event.target
    const sidebarComponent = this.sidebarTarget
    const nav = sidebarComponent.querySelector('nav')
    const breakpoint = this.breakpointValue
    const isMobile = window.innerWidth < breakpoint

    // Close sidebar on mobile when clicking links (unless data-keep-mobile-sidebar-open is present)
    if (isMobile && (target.closest('a, button') && !target.closest('[data-keep-mobile-sidebar-open]'))) {
      if (document.activeElement) document.activeElement.blur()
      this.setState(false)
      return
    }

    // Close sidebar when clicking outside (on sidebar background or outside nav)
    if (target === sidebarComponent || (nav && !nav.contains(target))) {
      if (document.activeElement) document.activeElement.blur()
      this.setState(false)
    }
  }

  toggle() {
    this.setState(!this.open)
  }
}
