json.extract! report, :id, :subject, :body, :email_to, :email_cc, :email_bcc, :reported_at, :note, :created_at, :updated_at
json.url report_url(report, format: :json)