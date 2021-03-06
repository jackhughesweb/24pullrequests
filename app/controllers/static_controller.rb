class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.limit(200).sample(6)
    @users = User.order('pull_requests_count desc').includes(:pull_requests).limit(200).sample(24)
    @orgs = Organisation.with_user_counts.order_by_pull_requests.limit(200).sample(24)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)

    render layout: "homepage"
  end

  def about
    @contributors = User.contributors
  end

  def sponsors
  end

  def humans
    @contributors = load_contributors
    render "static/humans.txt.erb", content_type: "text/plain"
  end

  private

  def load_contributors
    Rails.application.config.contributors.map(&:login).map do |login|
      Octokit.user(login)
    end.compact
  end
end
