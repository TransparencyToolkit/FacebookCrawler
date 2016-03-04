load "lib/facebookcrawler.rb"

puts "Getting object from Graph API: " + ARGV[1]

FacebookCrawler.new()
FacebookCrawler.get_object_recursive(ARGV[0], ARGV[1], 'start', 0)
