require "octokit"
require "gimp/version"

module Gimp
  class Mover
    def initialize(options)
      @client = Octokit::Client.new(access_token: options[:access_token])
      @source = options[:source]
      @destination = options[:destination]
      @exclude_labels = options[:exclude_labels] || []
      @known_labels = Set.new
    end

    def move_issue(id)
      issue = @client.issue(@source, id)
      labels = @client.labels_for_issue(@source, id)
      comments = @client.issue_comments(@source, id)

      labels.each { |label| ensure_label(label) }
      new_issue = @client.create_issue(@destination, issue.title, issue.body,
        assignee: issue.assignee ? issue.assignee.login : nil,
        labels: labels.map(&:name) - @exclude_labels)
      @client.add_comment(@destination, new_issue.number, "*Issue migrated from #{@source}##{issue.number}*")
      comments.each { |comment| @client.add_comment(@destination, new_issue.number, comment_text(comment)) }

      @client.close_issue(@source, id)
      new_issue.number
    end

    private

    def ensure_label(label)
      return if @exclude_labels.include?(label.name) || @known_labels.include?(label.name)
      @client.label(@destination, label.name)
      @known_labels << label.name
    rescue Octokit::NotFound
      @client.add_label(@destination, label.name, label.color)
      @known_labels << label.name
    end

    def comment_text(comment)
      "*@#{comment.user.login} commented at #{comment.created_at}*\n\n---\n\n#{comment.body}"
    end
  end
end
