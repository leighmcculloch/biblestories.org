DEPLOYMENT_COUNT = 3

desc "Build and deploy the website from source"
task :deploy_all do
  (0...DEPLOYMENT_COUNT).each do |deployment|
    system("DEPLOYMENT=#{deployment} bundle exec middleman build")
    system("DEPLOYMENT=#{deployment} bundle exec middleman cdn")
  end
end

desc "Build and deploy the website from source"
task :deploy do
  system("bundle exec middleman build")
  system("bundle exec middleman cdn")
end

desc "Run the preview server at http://localhost:4567"
task :preview do
  system("bundle exec middleman server")
end
