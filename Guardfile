# frozen_string_literal: true

guard :rspec, cmd: 'rspec' do
  watch(%r{^functions/.+\.rb$})

  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { 'spec' }
end

guard :rubocop, all_on_start: false do
  watch(%r{^bin/.+\.rb$})
  watch(%r{^functions/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end
