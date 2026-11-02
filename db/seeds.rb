# Seed data for projects currently running in production and case studies
projects_data = [
  {
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
  },
  {
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
  },
  {
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
  },
  {
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
  },
  {
    title: "Autonomous RV Off-Grid Energy Grid",
    category: "IoT Hardware & Solar Monitoring",
    description: "Off-grid smart energy ecosystem powered by ESP32 microcontrollers and Raspberry Pi. Complete field integration wiring solar charge controllers and battery monitors via industrial Modbus RTU and MQTT telemetry dashboards.",
    image: "smart_house.jpg",
    url: "#",
    tags: "ESP32, Raspberry Pi, Modbus RTU, MQTT Broker, Solar PV Control",
    status: "Hardware Case Study",
    featured: true,
    position: 5,
    port: nil
  }
]

projects_data.each do |attrs|
  project = Project.find_or_initialize_by(title: attrs[:title])
  project.update!(attrs)
  puts "Seeded/Updated project: #{project.title}"
end
