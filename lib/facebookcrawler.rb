require 'omniauth-facebook'
require 'koala'
require 'pry'

class FacebookCrawler

  # Graph Instance
  @graph = Koala::Facebook::API.new("OAUTH_TOKEN")

  def self.get_object_recursive(save_path, object_id, after, count)
    return if after == "done"

    count += 1

    if after == "start"
      comments = @graph.get_object(object_id,
        limit: 200,
        order: 'chronological')
    else
      comments = @graph.get_object(object_id,
        limit: 200,
        order: 'chronological',
        after: after)
        # Object of next page of data
    end


    # You can also get an array describing the URL for the next page: [path, arguments]
    # This is useful for storing page state across multiple browser requests
    next_page =  comments.next_page
    next_page_params = comments.next_page_params

    puts "Saving " + comments.length.to_s + " items to " + save_path + "comments_" + count.to_s + ".json"

    # Save as JSON
    saver = File.write(save_path + "comments_" + count.to_s + ".json", comments.to_json)

    if next_page_params[1]
      get_object_recursive(save_path, object_id, next_page_params[1]["after"], count)
    else
      get_object_recursive(save_path, object_id, 'done', count)
    end
  end
end
