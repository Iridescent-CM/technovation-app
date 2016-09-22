desc "Perform a release"
task :release do
  sh "git co production"
  puts "-------------------------"
  puts ""

  sh "git merge master"
  puts "-------------------------"
  puts ""

  sh "git tag #{ENV.fetch('V')}"
  puts "-------------------------"
  puts ""

  sh "git push --all"
  puts "-------------------------"
  puts ""

  sh "git push --tags"
  exit
end
