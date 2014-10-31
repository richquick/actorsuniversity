require 'zeus/rails'

class CustomPlan < Zeus::Rails
  def teaspoon_console
    require 'teaspoon/console'
    @console = ::Teaspoon::Console.new({})
  end

  def teaspoon(argv=ARGV)
    @console.execute({}, argv)
  end
  # def my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end

end

Zeus.plan = CustomPlan.new
