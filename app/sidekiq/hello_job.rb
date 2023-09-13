class HelloJob
  include Sidekiq::Job

  def perform(*args)
    puts "Hello From HelloJob background"
  end
end
