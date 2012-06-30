describe 'extrating a method' do
  it 'should extract without any local variables or args' do
    code = <<-RUBY
def foo
  puts "123"
end
    RUBY
    extract_method(code, 2, 0, 12)
  end
end
