class EmailAddressesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.split(/,\s*/).each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors[email.downcase] << (options[:message] || "is not an email")
      end
    end
  end
end
