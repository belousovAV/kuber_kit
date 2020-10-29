require 'cli/ui'

class Indocker::UI::Interactive
  class TaskGroup < CLI::UI::SpinGroup
  end

  def create_task_group
    init_if_needed
    TaskGroup.new
  end

  def create_task(title, &block)
    init_if_needed
    CLI::UI::Spinner.spin(title, &block)
  end

  def print_info(title, text)
    CLI::UI::Frame.open(title) do
      puts text
    end
  end

  def print_error(title, text)
    CLI::UI::Frame.open(title, color: :red) do
      puts text
    end
  end

  def print_warning(title, text)
    CLI::UI::Frame.open(title, color: :yellow) do
      puts text
    end
  end

  private
    def init
      @initialized = true
      ::CLI::UI::StdoutRouter.enable
    end

    def init_if_needed
      init unless @initialized
    end
end