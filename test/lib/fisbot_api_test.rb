# frozen_string_literal: true

require 'test_helper'

describe 'FisbotApi' do
  it 'must raise error when the api throws an exception' do
    WebMocker.code_location_find_by_failure('some_branch')
    _(-> { CodeLocation.find_by(branch: 'some_branch') }).must_raise(StandardError)
  end

  describe 'valid' do
    it 'must return false when attributes are not valid' do
      WebMocker.code_location_valid(valid_url: false)
      code_location = CodeLocation.new(url: 'fake_url', scm_type: :git)
      _(code_location).wont_be :valid?
    end

    it 'must return true when attributes are valid' do
      WebMocker.code_location_valid
      code_location = CodeLocation.new(url: WebMocker.rails_https_url)
      _(code_location).must_be :valid?
    end
  end
end
