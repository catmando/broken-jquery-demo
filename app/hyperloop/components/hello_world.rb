class HelloWorld < Hyperloop::Component
  param :say
  render(DIV) { "I say hello you say: #{params.say}" }
end
