# frozen_string_literal: true

require 'test_helper'
require 'test_helpers/commits_by_language_data'
require 'support/unclaimed_controller_test'

class PeopleControllerTest < ActionController::TestCase
  before do
    Account.destroy_all
    Person.destroy_all
    account = create(:account, name: 'Bubba Hotep')
    best_account_analysis = create(:best_account_analysis, account: account)
    account.update(best_vita_id: best_account_analysis.id)
    @claimed = create(:person, kudo_score: 12, kudo_rank: 3)
    # rubocop:disable Style/RescueModifier
    @claimed.update(id: account.id, account_id: account.id) rescue nil
    # rubocop:enable Style/RescueModifier
    @unclaimed = create(:person, kudo_score: 12, kudo_rank: 3, effective_name: 'Bubba Amon')
    @project1 = create(:project)
    @project2 = create(:project)
    best_account_analysis.account_analysis_fact.update_column(:commits_by_language, CommitsByLanguageData.construct)
    create(:name_fact, analysis_id: @project1.best_analysis_id, name_id: @unclaimed.name.id)
    create(:name_fact, analysis_id: @project2.best_analysis_id, name_id: @unclaimed.name.id)
    @unclaimed.name.update(name: 'Bubba Amon')
  end

  describe 'index' do
    it 'should render the people found' do
      get :index, params: { query: 'Bubba' }
      assert_response :ok
      _(response.body).must_match @claimed.account.name
      _(response.body).must_match @unclaimed.name.name
    end

    it 'must limit results when it exceeds OBJECT_MEMORY_CAP' do
      UnclaimedControllerTest.limit_by_memory_cap(self) do |people, unclaimed_tile_limit|
        _(people.length).must_equal unclaimed_tile_limit
      end
    end

    it 'should render the people page' do
      get :index
      assert_response :ok
      assert_template :index
    end
  end

  describe 'rankings' do
    it 'should render the people found' do
      get :rankings, params: { query: 'Bubba' }
      assert_response :ok
      _(response.body).must_match @claimed.account.name
      _(response.body).must_match @unclaimed.name.name
    end
  end
end
