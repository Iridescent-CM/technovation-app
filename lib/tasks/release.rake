desc "Perform a release"
task :release do
  sh "git co #{ENV.fetch('VM').sub('.', '-')}-stable"
  puts "-------------------------"
  puts ""

  sh "git merge master"
  puts "-------------------------"
  puts ""

  sh "git co production"
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
  exit
end
