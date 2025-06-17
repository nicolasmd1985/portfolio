import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove() {
    this.element.style.animation = 'slideOut 0.5s ease-out';
    this.element.addEventListener('animationend', () => {
      this.element.remove();
    });
  }
} 