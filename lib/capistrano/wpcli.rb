# Load all tasks
files = Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')] 
files.each do |file| 
  load file
end