require 'pp'
require 'ruby2ruby'

class Array
  def comments
    []
  end
  
  def sexp_type
    first
  end

  def to_sexp
    Sexp.from_array(Rubinius::AST::Block.new(first.line, self).to_sexp)
  end
end

describe 'extracting a method' do
  def to_ruby(ast)
    Ruby2Ruby.new.process(ast.to_sexp)
  end

  def find_body(method_definition, start_line, end_line)
    body = method_definition.body.array
    body.select { |i| (start_line..end_line).include? i.line }
  end

  def create_new_method(new_method_name, body)
    code = <<-RUBY
def #{new_method_name}
  #{to_ruby(body)}
end
RUBY
    to_ruby(code)
  end

  def replace_body(method_definition, start_line, end_line, new_method_name)
    method_definition.body.array = ["#{new_method_name}()".to_ast]
    to_ruby(method_definition)
  end

  def extract_method(code, new_method_name, start_line, end_line, start_column, end_column)
    ast = code.to_ast
    body = find_body(ast, start_line, end_line)
    n = create_new_method(new_method_name, body)
    p = replace_body(ast, start_line, end_line, new_method_name)

    "#{n}\n\n#{p}"
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
