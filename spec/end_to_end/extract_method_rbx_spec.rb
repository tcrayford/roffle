require 'pp'
require 'ruby2ruby'
$LOAD_PATH.unshift(File.expand_path("../../../lib", __FILE__))
require 'roffle/refactorings/extract_method'

describe 'extracting a method' do
  it 'extract without any local variables or args' do
    code = <<-RUBY
def foo
  puts "123"
end
RUBY
    extracted_code = <<-RUBY
def bar
  puts("123")
end

def foo
  bar
end
RUBY
    Roffle::Refactorings::ExtractMethod.extract_method(code, 'bar', 2, 2, 0, 12).strip.should == extracted_code.strip
  end

  it 'ignores lines outside the refactoring' do
    code = <<-RUBY
def foo
  puts "123"
  puts "345"
end
RUBY
    extracted_code = <<-RUBY
def bar
  puts("123")
end

def foo
  bar
  puts("345")
end
RUBY
    Roffle::Refactorings::ExtractMethod.extract_method(code, 'bar', 2, 2, 0, 12).strip.should == extracted_code.strip
  end

  it 'write an rspec matcher that compares strings as parsed exps'
end

