namespace :cleanup do
  desc 'Destroys orphaned categories'
  task :categories, [:args] => :environment do |_, args|
    categories_to_destroy = Category.includes(:services).select{|c| c.services.length == 0}
    STDOUT.puts "Are you sure you want to destroy #{categories_to_destroy.count} categories? (only 'yes' will continue)"
    are_you_sure = STDIN.gets.strip
    if are_you_sure == 'yes'
      puts "Destroying categories without services"
      categories_to_destroy.each do |c|
        c.destroy
      end
    end
  end
end
