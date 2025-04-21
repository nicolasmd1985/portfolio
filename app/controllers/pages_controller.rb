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
    @contact = Contact.new
  end

  def create_message
    @contact = Contact.new(contact_params)

    # Bot prevention: Check honeypot field
    if params[:contact][:website].present?
      head :ok
      return
    end

    # Bot prevention: Check submission timing
    submission_time = params[:contact][:submitted_at].to_i
    if Time.current.to_i - submission_time < 3
      head :ok
      return
    end

    respond_to do |format|
      if @contact.valid?
        # Here you would typically send the email
        # ContactMailer.contact_email(@contact).deliver_later

        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "contact_form",
            partial: "pages/contact_success"
          )
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "contact_form",
            partial: "pages/contact_form",
            locals: { contact: @contact }
          )
        }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message, :website, :submitted_at)
  end
end
