require "parallel"

DEPLOYMENTS = (0..2).to_a
DEV = !!ENV["DEV"]

desc "Build and deploy the website from source"
task :deploy_all do
  Parallel.each(DEPLOYMENTS) do |deployment|
    system("DEPLOYMENT=#{deployment} bundle exec middleman build")
    # system("DEPLOYMENT=#{deployment} bundle exec middleman cdn") if !DEV
  end
end

desc "Build and deploy the website from source"
task :deploy do
  system("bundle exec middleman build")
  # system("bundle exec middleman cdn") if !DEV
end

desc "Run the preview server at http://localhost:4567"
task :preview do
  system("bundle exec middleman server")
end
