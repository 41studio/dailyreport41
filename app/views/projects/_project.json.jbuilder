json.extract! project, :id, :name, :description, :email_client, :email_project_manager, :created_at, :updated_at
json.url project_url(project, format: :json)