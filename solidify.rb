require 'optparse'
require_relative 'solidify/solidus_app_builder'

def main
  options = parse_options
  Solidify::SolidusAppBuilder.new(get_app_name(options)).build
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = 'Usage: example.rb [options]'

    opts.on('-nNAME', '--name=NAME', 'Application name') do |name|
      options[:name] = name
    end

    opts.on('-h', '--help', 'Prints this help') do
      puts opts
      exit
    end
  end.parse!
  options
end

def get_app_name(options)
  return options[:name] if options.key?(:name)

  print 'Enter application name (default is ' \
        "#{Solidify::SolidusAppBuilder::DEFAULT_APP_NAME}): "
  name = gets.chomp.strip
  name
end

main if __FILE__ == $PROGRAM_NAME
