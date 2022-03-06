# frozen_string_literal: true

class AddOauthApplicationIdToApiKeys < ActiveRecord::Migration[4.2]
  def change
    add_reference :api_keys, :oauth_application, index: true
    add_foreign_key :api_keys, :oauth_applications
  end
end
