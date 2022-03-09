# frozen_string_literal: true

module JobApiHelper
  def current_step_at(step_at)
    step_at&.to_datetime&.strftime('%B %d, %Y %H:%M')
  end

  def last_updated(updated_at)
    time_ago_in_words(updated_at.to_datetime) if updated_at
  end

  def status_tag(status)
    case status
    when Job::STATUS_SCHEDULED  then %w[scheduled label-warning]
    when Job::STATUS_QUEUED     then %w[queued label-warning]
    when Job::STATUS_RUNNING    then %w[running label-primary]
    when Job::STATUS_FAILED     then %w[failed label-danger]
    when Job::STATUS_COMPLETED  then %w[completed label-success]
    end
  end

  def worker_host(worker_id)
    return unless worker_id

    "on #{link_to Worker.find(worker_id).hostname, '#'}".html_safe
  end

  def job_progress(job)
    return unless [1, 3, 5].include?(job['status'])

    case job['status']
    when 1
      css = ['progress progress-xs progress-striped active', 'progress-bar progress-bar-success']
    when 3
      css = ['progress progress-xs', 'progress-bar progress-bar-danger']
    when 5
      css = ['progress progress-xs', 'progress-bar progress-bar-success']
    end
    show_job_progress(job, css)
  end

  def show_job_progress(job, css)
    percent = percentage_completed(job)
    haml_tag(:div, class: css[0]) do
      # rubocop:disable Lint/EmptyBlock
      haml_tag(:div, class: css[1], style: "width: #{percent}%") {}
      # rubocop:enable Lint/EmptyBlock
    end
  end

  def percentage_completed(job)
    return unless job['current_step']

    (job['current_step'].fdiv(job['max_steps']) * 100).round
  end

  def step_message(job)
    return unless job['current_step']

    "Step #{job['current_step']} of #{job['max_steps']}"
  end
end
