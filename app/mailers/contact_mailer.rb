class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    mail(
      to: "nicolasmelectronic@gmail.com",
      subject: "New Contact Form Submission: #{@contact.subject}"
    )
  end
end 