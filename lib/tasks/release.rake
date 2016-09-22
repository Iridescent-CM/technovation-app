desc "Perform a release"
task :release do
  sh "git co production"
  puts "-------------------------"
  puts ""

  sh "git merge master"
  puts "-------------------------"
  puts ""

  sh "git tag #{ENV.fetch('VM')}.#{ENV.fetch('P')}"
  sh "git tag -f #{ENV.fetch('VM')}-stable"
  puts "-------------------------"
  puts ""

  sh "git push --all"
  puts "-------------------------"
  puts ""

  sh "git push origin :refs/tags/#{ENV.fetch("VM")}-stable"
  sh "git push --tags"
  exit
end
