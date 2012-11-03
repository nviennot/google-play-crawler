class AppQueryFetcher
  include Sidekiq::Worker
  sidekiq_options :queue => name.underscore

  def perform(app_query_id, page)
    query = AppQuery.find(app_query_id)
    start = page * Crawler::App::PER_PAGE
    # google is tight on 401
    start = [start, Crawler::App::MAX_START - Crawler::App::PER_PAGE].min
    self.class.save_apps(query, query.crawler(:start => start).crawl.apps)
  end

  def self.save_apps(query, apps)
    apps.each do |app|
      app = App.new(app)
      app.upsert
      unless app.price
        app = App.where(:id => app.id).first # mongoid workaround
        app.download_latest_apk!
      end
    end
    query.inc(:total_apps_fetched, apps.count) unless apps.empty?
  end
end
