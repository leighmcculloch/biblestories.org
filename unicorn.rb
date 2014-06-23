worker_processes Integer(ENV["WEB_CONCURRENCY"] || 1)
timeout 30
preload_app true
