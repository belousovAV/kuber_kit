class KuberKit::Actions::ImageCompiler
  include KuberKit::Import[
    "image_compiler.image_dependency_resolver",
    "shell.local_shell",
    "tools.logger",
    "ui",
    image_compiler: "image_compiler.action_handler",
  ]

  Contract ArrayOf[Symbol], Hash => Any
  def call(image_names, options)
    build_id = generate_build_id

    resolved_dependencies = []
    dependencies = image_dependency_resolver.get_next(image_names)

    while (dependencies - resolved_dependencies).any?
      compile_simultaneously(dependencies, build_id)
      resolved_dependencies += dependencies
      dependencies = image_dependency_resolver.get_next(image_names, resolved: resolved_dependencies)
    end

    compile_simultaneously(image_names - resolved_dependencies, build_id)
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
  end

  private
    def compile_simultaneously(image_names, build_id)
      task_group = ui.create_task_group
      image_names.map do |image_name|

        logger.info("Started compiling: #{image_name.to_s.green}")
        task_group.add("Compiling #{image_name.to_s.yellow}") do |task|
          image_compiler.call(local_shell, image_name, build_id)

          task.update_title("Compiled #{image_name.to_s.green}")
          logger.info("Finished compiling: #{image_name.to_s.green}")
        end
        
      end
      task_group.wait
    end

    def generate_build_id
      Time.now.strftime("%H%M%S")
    end
end