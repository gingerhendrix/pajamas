# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pajamas}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gareth Andrew"]
  s.date = %q{2009-04-18}
  s.email = %q{gingerhendrix@hotmail.com}
  s.executables = ["pj-tasks-list", "pj-tasks-list~", "pj-tasks-next", "pj-tasks-next~", "pj-tasks-done", "pj-tasks-done~"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "bin/pj-tasks-done",
    "bin/pj-tasks-list",
    "bin/pj-tasks-next",
    "lib/pajamas.rb",
    "lib/pajamas/commands.rb",
    "lib/pajamas/task.rb",
    "lib/pajamas/todo_file.rb",
    "spec/pajamas/commands_spec.rb",
    "spec/pajamas/task_spec.rb",
    "spec/pajamas/todo_file_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/gingerhendrix/pajamas}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{TODO}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/pajamas/todo_file_spec.rb",
    "spec/pajamas/commands_spec.rb",
    "spec/pajamas/task_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
