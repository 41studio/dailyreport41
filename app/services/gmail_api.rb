class GmailApi
  APPLICATION_NAME = 'DailyReport41'
  SCOPE = ['https://mail.google.com/',
    'https://www.googleapis.com/auth/gmail.modify',
    'https://www.googleapis.com/auth/gmail.compose',
    'https://www.googleapis.com/auth/gmail.send'
  ]

  ##
  # Ensure valid credentials
  def initialize(user)
    @gmail = Gmail.connect(:xoauth2, user.email, user.fresh_token)
    return 'disconnected' unless @gmail.signed_in?
  end

  ##
  # compose the message first and send it later
  def compose(email_to, subject, message_body)
    email = @gmail.compose do
      to email_to
      subject subject
      body message_body
    end
    email
  end

  ##
  # deliver email directly
  def deliver(email_to, email_cc, email_bcc, subject, message_body, options={}, attachments=nil)
    email = @gmail.deliver do
      to email_to
      cc email_cc if email_cc.present?
      bcc email_bcc if email_bcc.present?
      subject subject

      ##
      # handle format type
      if options[:format].eql?('html')
        html_part do
          content_type 'text/html; charset=UTF-8'
          body message_body
        end
      else
        text_part do
          body message_body
        end
      end

      ##
      # handle attachments
      if attachments.is_a?(String)
        add_file(attachments)
      elsif attachments.is_a?(Array)
        attachments.each do |attachment|
          add_file(attachments)
        end
      end
    end
    email.message_id
  end

  ##
  # send email
  def deliver!(email)
    @gmail.deliver(email)
    email.message_id
  end

  ##
  # TODO fix find email
  # find email by message_id
  def find_by_message_id(message_id)
    @gmail.inbox.find(message_id: message_id)
  end
end
