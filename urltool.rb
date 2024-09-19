#!/usr/bin/env ruby
require 'uri'
require 'optparse'

def encode_content(file_content)
  URI.encode_www_form_component(file_content.join(" "))
end

def decode_content(file_content)
  URI.decode_www_form_component(file_content.join).gsub('%0A', "\n")
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: url_tool.rb [options] input_file.txt"

  opts.on('-E', '--encode', 'Encode the content (URL encode)') do
    options[:mode] = :encode
  end

  opts.on('-D', '--decode', 'Decode the content (URL decode)') do
    options[:mode] = :decode
  end

  opts.on('-o', '--output FILE', 'Specify output file') do |file|
    options[:output] = file
  end
end.parse!

if options[:mode].nil?
  puts "Error: You must specify --encode (-E) or --decode (-D)"
  exit 1
end

if ARGV.empty?
  puts "Error: You must provide an input file."
  exit 1
end

file_path = ARGV[0]
unless File.exist?(file_path)
  puts "Error: The file '#{file_path}' does not exist."
  exit 1
end

file_content = File.readlines(file_path)

result = case options[:mode]
         when :encode
           encode_content(file_content)
         when :decode
           decode_content(file_content)
         end

if options[:output]
  File.open(options[:output], 'w') { |file| file.write(result) }
else
  puts result
end
