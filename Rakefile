desc "run server"
task :default do
  sh "rackup"
end

desc "install dependencies"
task :install do
  sh "bundle install"
end

###
desc 'build css'
task :css do
  sh "sass views/styles.scss public/css/style.css"
end
