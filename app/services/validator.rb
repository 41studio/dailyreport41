class Validator

  def self.is_email?(email)
    email =~ email_regexp
  end

  private
    def self.email_regexp
      /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
end
