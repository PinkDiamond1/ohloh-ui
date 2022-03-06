# frozen_string_literal: true

xml.response do
  xml.status 'success'
  xml.items_returned @affiliated_projects.length
  xml.items_available @affiliated_projects.total_entries
  xml.first_item_position @affiliated_projects.offset
  xml.result do
    xml.portfolio_projects do
      @affiliated_projects.each do |project|
        tms = project.best_analysis.try(:twelve_month_summary)
        ptms = project.best_analysis.try(:previous_twelve_month_summary)
        commits_diff = ptms.try(:commits_difference)
        committers_diff = ptms.try(:committers_difference)
        xml.project do
          xml.name project.name
          xml.activity project_activity_text(project, false)
          xml.primary_language project.main_language || 'N/A'
          xml.i_use_this project.user_count
          xml.community_rating project.rating_average.to_f.round(1).to_s

          xml.twelve_mo_activity_and_year_on_year_change do
            xml.commits tms.try(:commits_count)
            xml.change_in_commits commits_diff

            if commits_diff != 0 && ptms.commits_count.to_i != 0
              xml.percentage_change_in_commits((commits_diff.to_f.abs / ptms.commits_count.to_f.abs * 100).to_i)
            end

            xml.contributors tms.try(:committer_count)
            xml.change_in_contributors committers_diff

            if committers_diff != 0 && ptms.committer_count.to_i != 0
              xml.percentage_change_in_committers((committers_diff.to_f.abs / ptms.committer_count.to_f.abs * 100).to_i)
            end
          end
        end
      end
    end
  end
end
