require 'pp'
require 'ruby2ruby'
require 'ruby_parser'

describe 'extracting a method' do
  def find_body(method_definition, start_line, end_line)
    method_definition[3][1][1]
  end

  def create_new_method(new_method_name, body)
    code = <<-RUBY
def #{new_method_name}
  #{Ruby2Ruby.new.process(body)}
end
RUBY
  end

  def replace_body(method_definition, start_line, end_line, new_method_name)
    method_definition[3][1][1] = RubyParser.new.parse(new_method_name)
    Ruby2Ruby.new.process(method_definition)
  end

  def extract_method(code, new_method_name, start_line, end_line, start_column, end_column)
    body = find_body(RubyParser.new.parse(code), start_line, end_line)
    n = create_new_method(new_method_name, body)
    p = replace_body(RubyParser.new.parse(code), start_line, end_line, new_method_name)

    "#{n}\n#{p}"
  end

  it 'should extract without any local variables or args' do
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
    extract_method(code, 'bar', 2, 2, 0, 12).strip.should == extracted_code.strip
  end
end
