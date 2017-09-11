# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This  filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::Descompose < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #    {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "descompose"

  # Replace the message with this value.
  config :input, :validate => :string


  public
  def register
    # Add instance variables
  end # def register

  public
  def filter(event)

    if @input
      # Replace the event message with our message as configured in the
      # config file.
      fieldArray = event.get(@input).scan(/[a-zA-Z]+=[^,]*/);
				for field in fieldArray
					name = field.split('=')[0].strip;
					value = field.split('=')[1];
					if value =~ /^[0-9]+$/
						event.set(name,value.to_i)
					elsif value =~ /^[0-9.]+$/
						event.set(name,value.to_f)
					else
						event.set(name,value.to_s)
					end
				end
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Descompose
