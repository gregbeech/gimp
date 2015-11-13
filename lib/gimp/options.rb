module Gimp
  class Options < SimpleDelegator
    def initialize(defaults)
      super(@options = Hashie::Mash.new(defaults))
    end

    def parse!(args)
      parser.parse!(args)
      self
    end

    def valid?
      @options.token? && @options.source? && @options.destination? && @options.issues?
    end

    def usage
      parser.to_s
    end

    private

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = 'Usage: gimp [options]'
        opts.on('-t', '--token ACCESS_TOKEN', 'GitHub access token') do |access_token|
          @options.access_token = access_token
        end
        opts.on('-s', '--source SOURCE', 'Source repository') do |source|
          @options.source = source
        end
        opts.on('-d', '--destination DESTINATION', 'Destination repository') do |destination|
          @options.destination = destination
        end
        opts.on('-i', '--issues ISSUES', Array, 'Issue numbers') do |issues|
          @options.issues = issues
        end
        opts.on('--exclude-labels [LABELS]', Array, 'Exclude labels', ' (exclude specific labels if LABELS supplied)') do |labels|
          @options.labels ||= Hashie::Mash.new
          @options.labels.exclude = labels || true
        end
        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          @options.verbose = v
        end
        opts.on_tail("-h", "--help", "Show this message") do
          @options.help = true
        end
        opts.on_tail("--version", "Show version") do
          @options.version = true
        end
      end
    end
  end
end