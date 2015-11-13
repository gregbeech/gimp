require "octokit"
require "gimp/version"

module Gimp
  class Mover
    def initialize(options)
      @client = Octokit::Client.new(access_token: options.token)
      @options = options
      @source = options.source
      @destination = options.destination
      @known_labels = Set.new
    end

    def move_issue(id)
      issue = @client.issue(@source, id)
      labels = new_labels(@client.labels_for_issue(@source, id))
      comments = @client.issue_comments(@source, id)

      labels.each { |label| ensure_label(label) }
      new_issue = @client.create_issue(@destination, issue.title, issue.body,
        assignee: new_assignee(issue),
        labels: labels.map(&:name).uniq)
      @client.add_comment(@destination, new_issue.number, "*Issue migrated from #{@source}##{issue.number}*")
      comments.each { |comment| @client.add_comment(@destination, new_issue.number, comment_text(comment)) }

      @client.close_issue(@source, id)
      new_issue.number
    end

    private

    def new_labels(labels)
      opts = @options.labels
      return labels unless opts

      labels = case opts.exclude
               when nil then labels
               when true then []
               else labels.reject { |label| opts.exclude.include?(label.name) }
               end
      labels << opts.add.map { |name| Hashie::Mash.new(name: name, color: 'ffffff') } if opts.add?
      labels.flatten
    end

    def ensure_label(label)
      return if @known_labels.include?(label.name)
      @client.label(@destination, label.name)
      @known_labels << label.name
    rescue Octokit::NotFound
      @client.add_label(@destination, label.name, label.color)
      @known_labels << label.name
    end

    def new_assignee(issue)
      return nil if @options.unassign? || issue.assignee.nil?
      issue.assignee.login if @client.collaborator?(@destination, issue.assignee.login)
    end

    def comment_text(comment)
      "*@#{comment.user.login} commented at #{comment.created_at}*\n\n---\n\n#{comment.body}"
    end
  end
end
