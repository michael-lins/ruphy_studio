class GitOperationsController < ApplicationController

  def index
  end

  def commit
    if params[:message].present?
      repo = Rugged::Repository.new(Rails.root.to_s)
      index = repo.index
      index.add_all
      index.write

      options = {}
      options[:tree] = index.write_tree(repo)
      options[:author] = { email: "michael@malvins.studio", name: "Michael Lins", time: Time.now }
      options[:committer] = options[:author]
      options[:message] = params[:message]
      options[:parents] = repo.empty? ? [] : [repo.head.target].compact
      options[:update_ref] = 'HEAD'

      Rugged::Commit.create(repo, options)
      flash[:notice] = 'Commit was successful!'
    else
      flash[:alert] = 'Commit message cannot be empty!'
    end
    redirect_to git_operations_path
  end

  def push
    begin
      repo = Rugged::Repository.new(Rails.root.to_s)
      remote = repo.remotes['origin']
      remote.push(["refs/heads/main"], credentials: Rugged::Credentials::UserPassword.new(
        username: ENV['GIT_USERNAME'],
        password: ENV['GIT_PASSWORD']
      ))
      flash[:notice] = 'Push was successful!'
    rescue => e
      flash[:alert] = "Push failed: #{e.message}"
    end
    redirect_to git_operations_path
  end

end
