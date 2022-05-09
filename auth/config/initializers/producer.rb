class Producer
  def self.call(topic, **params)
    self.new.call(topic, params)
  end

  def call(topic, payload)
    puts "Produce: #{topic} - #{payload}"
  end
end
