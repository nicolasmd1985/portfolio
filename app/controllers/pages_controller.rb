class PagesController < ApplicationController
  def home
    @projects = Project.all rescue []
  end

  def about
  end

  def projects
    @projects = Project.all rescue []
  end

  def services
    @services = [
      {
        title: "Smart Device Integration",
        description: "Expert integration of smart home devices and IoT solutions for modern living.",
        icon: "mdi-home-automation",
        color: "neon-cyan"
      },
      {
        title: "Sustainable Energy",
        description: "Implementation of renewable energy solutions and eco-friendly technology.",
        icon: "mdi-solar-power-variant",
        color: "neon-green"
      },
      {
        title: "Software Development",
        description: "Custom software solutions and application development for your needs.",
        icon: "mdi-code-braces",
        color: "neon-violet"
      }
    ]
  end

  def contact
  end
end
