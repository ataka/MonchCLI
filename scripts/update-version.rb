#!/usr/bin/env ruby

VERSION_SWIFT = "./Sources/MonchCLI/version.swift"

def is_new_branch?()
  prev_head, new_head, checkout_type = ARGV
  return false unless checkout_type.to_i == 1
  return false unless prev_head == new_head
  return true
end

def get_branch_name()
  `git rev-parse --abbrev-ref HEAD`.chomp
end

def get_release_version(branch:)
  match = branch.match(/release\/(\d+.\d+.\d+)/)
  if match
    return true, match[1]
  else
    return false, ""
  end
end

def update_version(version:)
  swift_code = <<-EOS
enum Version {
    static let value = "#{version}"
}
  EOS

  File.open(VERSION_SWIFT, "w") { |f|
    f.write(swift_code)
  }
end

def git_commit(version:)
  `git add #{VERSION_SWIFT}`
  `git commit -m 'Set version #{version}'`
end

def main()
  exit 0 unless is_new_branch?()

  branch = get_branch_name()
  success, version = get_release_version(branch: branch)

  exit 0 unless success
  update_version(version: version)
  git_commit(version: version)
  p "Set version #{version}"
end

main()
