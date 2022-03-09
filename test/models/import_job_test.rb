# frozen_string_literal: true

require 'test_helper'

class ImportJobTest < ActiveSupport::TestCase
  describe 'progress_message' do
    it 'should return required message' do
      job = ImportJob.create
      _(job.progress_message).must_equal 'Step 2 of 3: Importing source code into database'
    end
  end
end
