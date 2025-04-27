# Pin npm packages by running ./bin/importmap

# Core modules
pin "application", preload: true

# Hotwired
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# Stimulus
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Controllers
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
