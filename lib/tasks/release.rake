desc "Perform a release"
task :release do
  sh "git checkout #{ENV.fetch('VM').sub('.', '-')}-stable"
  puts "-------------------------"
  puts ""

  sh "git merge master"
  puts "-------------------------"
  puts ""

  sh "git checkout production"
  puts "-------------------------"
  puts ""

  sh "git merge #{ENV.fetch('VM').sub('.', '-')}-stable"
  puts "-------------------------"
  puts ""

  sh "git tag #{ENV.fetch('VM')}.#{ENV.fetch('P')}"
  puts "-------------------------"
  puts ""

  sh "git push --all"
  puts "-------------------------"
  puts ""

  sh "git push --tags"
  puts "-------------------------"
  puts ""

  sh "git checkout master"
  exit
end
