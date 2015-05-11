require 'test_helper'

describe 'LanguagesController' do
  before do
    @language = create(:language, name: 'html')
  end
  let(:date_range) { [3.months.ago, 2.months.ago, 1.month.ago, Date.today].map(&:beginning_of_month) }
  let(:create_all_months) do
    date_range.each { |date| create(:all_month, month: date) }
  end

  describe 'index' do
    it 'should return languages' do
      get :index
      must_respond_with :ok
      must_render_template :index
      assigns(:languages).count.must_equal 2
      assigns(:languages).last.must_equal @language
    end

    it 'should filter by name' do
      get :index, query: @language.nice_name
      must_respond_with :ok
      must_render_template :index
      assigns(:languages).count.must_equal 1
      assigns(:languages).first.must_equal @language
    end

    it 'should not return if invalid query' do
      get :index, query: 'Im banana'
      must_respond_with :ok
      must_render_template :index
      assigns(:languages).count.must_equal 0
    end

    it 'should sort by name' do
      get :index, sort: 'name'
      must_respond_with :ok
      must_render_template :index
      assigns(:languages).count.must_equal 2
      assigns(:languages).last.must_equal @language
    end

    it 'should respond to xml request' do
      get :index, format: :xml
      must_respond_with :ok
      must_render_template :index
      assigns(:languages).count.must_equal 2
      response.status.must_equal 200
    end
  end

  describe 'show' do
    it 'should load language facts' do
      create(:language_fact, language: @language)
      get :show, id: @language.name
      must_respond_with :ok
      must_render_template :show
      assigns(:language_facts).count.must_equal 1
      assigns(:language_facts).first.must_equal language_fact
    end

    it 'should not load language_facts if xml request' do
      create(:language_fact, language: @language)
      get :show, id: @language.name, format: :xml
      must_respond_with :ok
      must_render_template :show
      assigns(:language_facts).must_equal nil
    end
  end

  describe 'chart' do
    it 'should render json data' do
      create_all_months
      get :chart, language_name: @language.name
      must_respond_with :ok

      response_data = JSON.parse(response.body)
      response_data['series'].count.must_equal 1
      response_data['series'][:name].must_equal @language.name
    end

    it 'should support muliple language names' do
      create_all_months
      language = create(:language)
      create(:language_fact, language: @language, loc_changed: 25, month: 3.month.ago.beginning_of_month)
      create(:language_fact, language: language, loc_changed: 25, month: 3.month.ago.beginning_of_month)
      get :chart, language_name: [@language.name, language.name]
      must_respond_with :ok
      response_data = JSON.parse(response.body)
      response_data['series'].count.must_equal 2
      response_data['series'].first['data'].must_equal [50.0, 0.0, 0.0]
      response_data['series'].second['data'].must_equal [50.0, 0.0, 0.0]
    end

    it 'should support different measures' do
      create_all_months
      create(:language_fact, language: @language, commits: 25, month: 3.month.ago.beginning_of_month)
      get :chart, language_name: @language.name, measure: 'commits'
      must_respond_with :ok
      response_data = JSON.parse(response.body)
      response_data['series'].count.must_equal 1
      response_data['series'].first['data'].must_equal [100.0, 0.0, 0.0]
    end
  end

  describe 'compare' do
    it 'should compare languages' do
      language = create(:language)
      get :compare, language_name: [@language.name, language.name]
      must_respond_with :ok
      must_render_template :compare
      assigns(:language_names).count.must_equal 2
    end

    it 'should return default languages if language is not present' do
      create(:language, name: 'java')
      create(:language, name: 'php')
      get :compare
      must_respond_with :ok
      must_render_template :compare
      assigns(:language_names).count.must_equal 4
      assigns(:language_names).must_equal %w(c html java php)
    end
  end
end
