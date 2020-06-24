#!/usr/bin/env ruby

def main()
  hook_file = ARGV[0]
  scripts = <<-EOS
#!/bin/sh

./scripts/update-version.rb $1 $2 $3
  EOS

  File.open(hook_file, "w") { |f|
    f.write(scripts)
  }
end

main()
