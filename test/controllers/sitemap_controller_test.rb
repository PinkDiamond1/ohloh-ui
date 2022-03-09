# frozen_string_literal: true

require 'test_helper'
require 'test_helpers/xml_parsing_helpers'

class SitemapControllerTest < ActionController::TestCase
  before do
    @projects = []
    @accounts = []
    5.times { @projects << create(:project) }
    5.times { @accounts << create(:account) }
  end

  describe 'index' do
    it 'should return show page urls' do
      get :index, params: { format: 'xml' }
      assert_response :ok

      xml = xml_hash(@response.body)['sitemapindex']

      _(xml['xmlns']).must_equal 'http://www.sitemaps.org/schemas/sitemap/0.9'
      _(xml['sitemap'].size).must_equal 2
      _(xml['sitemap'].first['loc']).must_equal 'http://test.host/sitemaps/projects/1.xml'
      _(xml['sitemap'].first['lastmod']).must_equal Time.current.strftime('%Y-%m-%d')
      _(xml['sitemap'].last['loc']).must_equal 'http://test.host/sitemaps/accounts/1.xml'
      _(xml['sitemap'].last['lastmod']).must_equal Time.current.strftime('%Y-%m-%d')
    end
  end

  describe 'show' do
    it 'should return projects urls' do
      get :show, params: { ctrl: 'projects', page: '1', format: 'xml' }
      assert_response :ok

      xml = xml_hash(@response.body)['urlset']
      active_count = Project.active.count
      urls = xml['url'].map { |url| url['loc'] }

      _(xml['xmlns']).must_equal 'http://www.sitemaps.org/schemas/sitemap/0.9'
      _(xml['url'].size).must_equal active_count
      _(urls).must_include "http://test.host/p/#{@projects.first.vanity_url}"
      _(urls).must_include "http://test.host/p/#{@projects.second.vanity_url}"
      _(urls).must_include "http://test.host/p/#{@projects.third.vanity_url}"
      _(urls).must_include "http://test.host/p/#{@projects.fourth.vanity_url}"
      _(urls).must_include "http://test.host/p/#{@projects.last.vanity_url}"
      _(xml['url'].map { |url| url['lastmod'] }).must_equal [Time.current.strftime('%Y-%m-%d')] * active_count
      _(xml['url'].map { |url| url['priority'] }).must_equal ['0.8'] * active_count
      _(xml['url'].map { |url| url['changefreq'] }).must_equal ['daily'] * active_count
    end

    it 'should return accounts urls' do
      get :show, params: { ctrl: 'accounts', page: '1', format: 'xml' }
      assert_response :ok

      xml = xml_hash(@response.body)['urlset']
      active_count = Account.active.count
      urls = xml['url'].map { |url| url['loc'] }

      _(xml['xmlns']).must_equal 'http://www.sitemaps.org/schemas/sitemap/0.9'
      _(xml['url'].size).must_equal active_count
      _(urls).must_include "http://test.host/accounts/#{@accounts.first.login}"
      _(urls).must_include "http://test.host/accounts/#{@accounts.second.login}"
      _(urls).must_include "http://test.host/accounts/#{@accounts.third.login}"
      _(urls).must_include "http://test.host/accounts/#{@accounts.fourth.login}"
      _(urls).must_include "http://test.host/accounts/#{@accounts.last.login}"
      _(xml['url'].map { |url| url['lastmod'] }).must_equal [Time.current.strftime('%Y-%m-%d')] * active_count
      _(xml['url'].map { |url| url['priority'] }).must_equal ['0.6'] * active_count
      _(xml['url'].map { |url| url['changefreq'] }).must_equal ['daily'] * active_count
    end
  end
end
