require "fileutils"

desc "Perform a release"
task :release do
  releasing = VersionReleasing.new(ARGV[1])

  releasing.run_command("git checkout master")
  releasing.promote_pending_version
  releasing.tag_promoted_version
  releasing.align_major_branches
  releasing.run_command("git checkout master")
  releasing.run_command("git push --tags")
  releasing.run_command("git push --all")

  # prevent Rake from running the `updating_version_part` ARG as another task
  exit
end

class VersionReleasing
  include FileUtils

  def initialize(part)
    @updating_version_part = part || "patch"
    @current_version = File.read("./VERSION")
  end

  def run_command(cmd, options = {})
    sh(cmd) do |ok, _|
      if ok
        puts "-------------------------"
        puts ""
      elsif options[:fallback]
        run_command(options[:fallback])
      end
    end
  end

  def align_major_branches
    run_command(
      "git checkout -b #{stable_branch}",
      fallback: "git checkout #{stable_branch}"
    )
    run_command("git merge master")
    run_command("git checkout production")
    run_command("git merge #{stable_branch}")
  end

  def tag_promoted_version
    run_command("git tag #{@current_version}")
  end

  def promote_pending_version
    File.open("./VERSION", "wb") do |f|
      f.puts(new_version)
    end

    run_command("git commit VERSION -m 'Release VERSION at #{@current_version}'")
  end

  private
  def current_major
    @current_major ||= @current_version.split('.')[0].to_i
  end

  def current_minor
    @current_minor ||= @current_version.split('.')[1].to_i
  end

  def current_patch
    @current_patch ||= @current_version.split('.')[2].to_i
  end

  def new_version
    @new_version ||= case @updating_version_part
                     when "patch"
                       "#{current_major}.#{current_minor}.#{current_patch + 1}"
                     when "minor"
                       "#{current_major}.#{current_minor + 1}.0"
                     when "major"
                       "#{current_major + 1}.0.0"
                     else
                       raise "Unrecognized version part: #{@updating_version_part}"
                     end
  end

  def new_major
    @new_major ||= new_version.split('.')[0].to_i
  end

  def new_minor
    @new_minor ||= new_version.split('.')[1].to_i
  end

  def stable_branch
   @stable_branch ||= "#{new_major}-#{new_minor}-stable"
  end
end
