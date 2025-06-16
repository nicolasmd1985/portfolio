class Contact < ApplicationRecord
  include Recaptcha::Adapters::ControllerMethods
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { minimum: 3, maximum: 200 }
  validates :message, presence: true, length: { minimum: 10, maximum: 2000 }
  
  # Prevent common spam patterns
  validate :no_spam_patterns
  validate :verify_recaptcha, on: :create
  
  private
  
  def no_spam_patterns
    spam_patterns = [
      /\b(viagra|cialis|levitra)\b/i,
      /\b(loan|mortgage|debt)\b/i,
      /\b(casino|poker|betting)\b/i,
      /\b(bitcoin|crypto|nft)\b/i,
      /\b(weight loss|diet|supplement)\b/i
    ]
    
    if message.present? && spam_patterns.any? { |pattern| message.match?(pattern) }
      errors.add(:message, "contains spam-like content")
    end
    
    if subject.present? && spam_patterns.any? { |pattern| subject.match?(pattern) }
      errors.add(:subject, "contains spam-like content")
    end
  end

  def verify_recaptcha
    return if Rails.env.test?
    
    unless verify_recaptcha?(model: self, response: recaptcha_response)
      errors.add(:base, "reCAPTCHA verification failed")
    end
  end
end