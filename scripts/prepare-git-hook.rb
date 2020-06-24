#!/usr/bin/env ruby

def main()
  hook_file = ARGV[0]
  scripts = <<-EOS
#!/bin/sh

if [ -x ./scripts/update-version.rb ]; then
    ./scripts/update-version.rb $1 $2 $3
fi
  EOS

  File.open(hook_file, "w") { |f|
    f.write(scripts)
  }
end

main()
