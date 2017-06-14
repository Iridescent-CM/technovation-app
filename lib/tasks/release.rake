desc "Perform a release"
task :release do
  current_version = File.read("./VERSION")
  updating_version_part = ARGV[1].dup || "patch"

  current_major = current_version.split('.')[0].to_i
  current_minor = current_version.split('.')[1].to_i
  current_patch = current_version.split('.')[2].to_i

  case updating_version_part
  when "patch"
    new_version = "#{current_major}.#{current_minor}.#{current_patch + 1}"
  when "minor"
    new_version = "#{current_major}.#{current_minor + 1}.0"
  when "major"
    new_version = "#{current_major + 1}.0.0"
  else
    raise "Unrecognized version part: #{updating_version_part}"
  end

  new_major = new_version.split('.')[0].to_i
  new_minor = new_version.split('.')[1].to_i
  branch = "#{new_major}-#{new_minor}-stable"

  sh("git checkout -b #{branch}") do |ok, _|
    unless ok
      sh("git checkout #{branch}")
    end
  end

  puts "-------------------------"
  puts ""

  sh "git merge master"
  puts "-------------------------"
  puts ""

  sh "git checkout production"
  puts "-------------------------"
  puts ""

  sh "git merge #{branch}"
  puts "-------------------------"
  puts ""

  sh "git tag #{new_version}"
  puts "-------------------------"
  puts ""

  sh "git push --tags"
  puts "-------------------------"
  puts ""

  sh "git checkout master"
  puts "-------------------------"
  puts ""

  sh "git push --all"

  File.open("./VERSION", "wb") do |f|
    f.puts(new_version)
  end

  # prevent Rake from running the `updating_version_part` ARG as another task
  exit
end
