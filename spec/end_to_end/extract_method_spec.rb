describe 'extracting a method' do
  def extract_method(code, new_method_name, start_line, end_line, start_column, end_column)
  end

  it 'should extract without any local variables or args' do
    code = <<-RUBY
def foo
  puts "123"
end
RUBY
    extracted_code = <<-RUBY
def bar
  puts "123"
end

def foo
  bar
end
RUBY
    extract_method(code, 'bar', 2, 2, 0, 12).should == extracted_code
  end
end
