// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"

// Debug Turbo Drive navigation
document.addEventListener("turbo:load", () => {
  console.log("🟢 Turbo Load: Page loaded via Turbo Drive")
})

document.addEventListener("turbo:before-visit", (event) => {
  console.log("🔵 Turbo Before Visit:", event.detail.url)
})

document.addEventListener("turbo:visit", (event) => {
  console.log("🟡 Turbo Visit Started:", event.detail.url)
})

document.addEventListener("turbo:submit-start", () => {
  console.log("📝 Turbo Form Submission Started")
})

// Log any Turbo errors
document.addEventListener("turbo:load-error", (event) => {
  console.error("❌ Turbo Load Error:", event.detail.error)
})
