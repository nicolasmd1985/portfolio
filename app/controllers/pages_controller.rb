class PagesController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Recaptcha::Adapters::ControllerMethods
  
  # Rate limiting for contact form
  RATE_LIMIT = 5  # Maximum number of submissions
  RATE_LIMIT_WINDOW = 1.hour  # Time window for rate limiting
  RECAPTCHA_MIN_SCORE = 0.5  # Minimum score to consider the request valid

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
    @contact = Contact.new(contact_params.except(:recaptcha_token))

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

    # Rate limiting check
    ip = request.remote_ip
    key = "contact_form:#{ip}"
    submissions = Rails.cache.read(key) || 0

    if submissions >= RATE_LIMIT
      render json: { error: "Too many submissions. Please try again later." }, status: :too_many_requests
      return
    end

    # Verify reCAPTCHA v3
    if Rails.env.production?
      recaptcha_response = params[:contact][:recaptcha_token]
      
      begin
        verification_result = verify_recaptcha(
          model: @contact,
          response: recaptcha_response,
          action: 'contact_form',
          minimum_score: RECAPTCHA_MIN_SCORE
        )
        
        unless verification_result
          render json: { error: "reCAPTCHA verification failed" }, status: :unprocessable_entity
          return
        end
      rescue => e
        Rails.logger.error "reCAPTCHA verification error: #{e.message}"
        render json: { error: "reCAPTCHA verification error" }, status: :unprocessable_entity
        return
      end
    end

    respond_to do |format|
      if @contact.save
        # Increment submission count
        Rails.cache.write(key, submissions + 1, expires_in: RATE_LIMIT_WINDOW)
        
        # Send the email
        ContactMailer.contact_email(@contact).deliver_later

        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("contact_form", partial: "pages/contact_success"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { 
              type: "success",
              message: t('contact.success_message')
            })
          ]
        }
        format.html {
          redirect_to contact_path, notice: t('contact.success_message')
        }
      else
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("contact_form", partial: "pages/contact_form", locals: { contact: @contact }),
            turbo_stream.update("flash", partial: "shared/flash", locals: { 
              type: "error",
              message: t('contact.error_message')
            })
          ]
        }
        format.html {
          render :contact, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message, :website, :submitted_at, :recaptcha_token)
  end
end
