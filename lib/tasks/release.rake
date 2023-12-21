require "fileutils"

desc "Perform a release"
task :release do
  releasing = VersionReleasing.new(ARGV[1])

  releasing.run_command("git checkout qa")

  releasing.promote_pending_version
  releasing.tag_promoted_version

  releasing.run_command(
    "git checkout -b #{releasing.stable_branch}",
    fallback: "git checkout #{releasing.stable_branch}"
  )

  releasing.run_command("git merge qa")
  releasing.run_command("git checkout master")
  releasing.run_command("git merge #{releasing.stable_branch}")
  releasing.run_command("git checkout production")
  releasing.run_command("git merge master")

  releasing.run_command("git checkout qa")
  releasing.run_command("git push --tags")
  releasing.run_command("git push origin #{releasing.stable_branch} master production qa")

  # prevent Rake from running the `updating_version_part` ARG as another task
  exit
end

class VersionReleasing
  include FileUtils

  attr_reader :stable_branch

  def initialize(part)
    @updating_version_part = part || "patch"
    @current_version = File.read("./VERSION")
    @stable_branch = "#{new_major}-#{new_minor}-stable"
  end

  def run_command(cmd, options = {})
    sh(cmd) do |ok, res|
      if ok
        puts "-------------------------"
        puts ""
      elsif options[:fallback]
        run_command(options[:fallback])
      else
        sh(cmd)
      end
    end
  end

  def tag_promoted_version
    run_command("git tag #{new_version}")
  end

  def promote_pending_version
    File.open("./VERSION", "wb") do |f|
      f.puts(new_version)
    end

    run_command("git commit VERSION -m 'Release VERSION at #{new_version}'")
  end

  private

  def current_major
    @current_major ||= @current_version.split(".")[0].to_i
  end

  def current_minor
    @current_minor ||= @current_version.split(".")[1].to_i
  end

  def current_patch
    @current_patch ||= @current_version.split(".")[2].to_i
  end

  def current_hotfix
    return @current_hotfix if defined?(@current_hotfix)
    split_by_hotfix = @current_version.split("HOTFIX.")

    @current_hotfix = if split_by_hotfix.size > 1
      split_by_hotfix.last.to_i
    else
      0
    end
  end

  def new_version
    @new_version ||= case @updating_version_part
    when "hotfix"
      "#{current_major}.#{current_minor}.#{current_patch}.HOTFIX.#{current_hotfix + 1}"
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
    @new_major ||= new_version.split(".")[0].to_i
  end

  def new_minor
    @new_minor ||= new_version.split(".")[1].to_i
  end
end
