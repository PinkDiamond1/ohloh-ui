# frozen_string_literal: true

module DuplicateAssociations
  extend ActiveSupport::Concern

  included do
    belongs_to :good_project, class_name: 'Project', optional: true
    belongs_to :bad_project, class_name: 'Project', optional: true
    belongs_to :account, optional: true
  end
end
