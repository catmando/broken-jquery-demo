
module EventError
  def self.included(component)
    component.before_update do
      if (last_error = @__event_error_last_error)
        @__event_error_last_error = nil
        raise last_error
      end
    end
  end
  def raise_error(e)
    @__event_error_last_error = e
    force_update!
  end
  def guard_exception
    yield
  rescue Exception => e
    raise_error(e)
  end
end

class ErrorDemo < Hyperloop::Component

  state display_state: :raise_first

  after_error do |*args|
    mutate.display_state :show_error
    @last_error = args
  end

  class RaiseError < Hyperloop::Component
    #before_update { raise state.the_error if state.the_error }
    include EventError
    def broken_method
      raise "I broke at #{Time.now}"
    end
    render do
      BUTTON { 'click to raise an error' }
      .on(:click) { guard_exception { broken_method }}
    end
  end

  def render
    DIV do
      BUTTON { "mount hello" }.on(:click) { `hyperloop_mount_all()` }
      case state.display_state
      when :raise_first, :raise_another
        BUTTON { "make an#{'other' if state.display_state==:raise_another } error" }
        .on(:click) { mutate.display_state :raise_error }
      when :raise_error
        RaiseError()
      when :show_error
        DIV { "The last error was: #{@last_error}" }
        BUTTON { 'okay' }
        .on(:click) { mutate.display_state :raise_another }
      end
    end
  end
end
