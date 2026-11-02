class Project < ApplicationRecord
  scope :featured, -> { where(featured: true).order(:position) }
  scope :ordered, -> { order(:position) }

  def tags_list
    (tags || "").split(",").map(&:strip).reject(&:blank?)
  end

  def live?
    url.present? && url != "#"
  end

  def key
    title.to_s.parameterize.underscore
  end

  def localized_title
    I18n.t("project_items.#{key}.title", default: title)
  end

  def localized_description
    I18n.t("project_items.#{key}.description", default: description)
  end

  def localized_category
    I18n.t("project_items.#{key}.category", default: category)
  end

  def self.display_projects
    projects = ordered.all
    return projects if projects.any?

    fallback_projects
  end

  def self.fallback_projects
    [
      new(
        title: "Backyard AI",
        category: "Generative AI Landscape",
        description: "Outdoor landscape transformation platform powered by multimodal generative AI (Google Gemini Vision & Nano Banana). Upload yard photos to analyze sunlight, boundaries, and soil layout, generating climate-adapted photorealistic landscaping with native flora while preserving home structures.",
        image: "projects/backyard.png",
        url: "https://nicolasmahecha.com/backyard/",
        tags: "Gemini Vision AI, Ruby on Rails API, React Native / Expo Web, Generative AI, Docker",
        status: "Live Demo",
        featured: true,
        position: 1,
        port: 3001
      ),
      new(
        title: "OrdenApp",
        category: "Enterprise Facilities SaaS",
        description: "Enterprise SaaS platform for facilities management, maintenance workflows, and real-time work order dispatching. Features live technician tracking, equipment lifecycle management, and operational analytics.",
        image: "projects/ordenapp.png",
        url: "https://nicolasmahecha.com/ordenapp/",
        tags: "Ruby on Rails, PostgreSQL, Redis, Hotwire, Nginx Reverse Proxy, Docker",
        status: "Live Platform",
        featured: true,
        position: 2,
        port: 3000
      ),
      new(
        title: "DrumPlay",
        category: "Interactive E-Drum Platform",
        description: "Interactive learning and practice platform for electronic drums (optimized for Alesis Nitro Mesh). Features a real-time dual-stave visual system comparing official MIDI tablature against acoustic transient audio transcription via DSP & Demucs with Web MIDI API.",
        image: "projects/drumplay.png",
        url: "https://nicolasmahecha.com/drumplay/",
        tags: "Web MIDI API, Python, DSP & Demucs, Audio Transcription, Gunicorn, Docker",
        status: "Live Interactive App",
        featured: true,
        position: 3,
        port: 5000
      ),
      new(
        title: "Alarmtronics Voice Dispatch",
        category: "Conversational Multimodal AI",
        description: "Real-time conversational AI voice receptionist for fire and intrusion alarm dispatch telephony. Engineered with low-latency bi-directional WebSockets bridging Telnyx TeXML audio streams with Google Gemini Live API for sub-second neural voice and barge-in response.",
        image: "projects/alarmtronics.png",
        url: "https://voz.nicolasmahecha.com",
        tags: "Gemini Live API, Telnyx TeXML Telephony, Python / FastAPI, WebSockets, Docker",
        status: "Live Voice System",
        featured: true,
        position: 4,
        port: 8000
      ),
      new(
        title: "Autonomous RV Off-Grid Energy Grid",
        category: "IoT Hardware & Solar Monitoring",
        description: "Off-grid smart energy ecosystem powered by ESP32 microcontrollers and Raspberry Pi. Complete field integration wiring solar charge controllers and battery monitors via industrial Modbus RTU and MQTT telemetry dashboards.",
        image: "smart_house.jpg",
        url: "#",
        tags: "ESP32, Raspberry Pi, Modbus RTU, MQTT Broker, Solar PV Control",
        status: "Hardware Case Study",
        featured: true,
        position: 5
      )
    ]
  end
end
