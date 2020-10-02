class Indocker::Actions::ConfigurationLoader
  include Indocker::Import[
    "core.infra_store",
    "core.image_store",
    "core.configuration_store",
    "tools.logger",
    "ui",
    "configs"
  ]

  Contract Hash => Any
  def call(options)
    root_path   = options[:path] || File.join(Dir.pwd, configs.indocker_dirname)
    images_path = options[:images_path] || File.join(root_path, configs.images_dirname)
    infra_path  = options[:infra_path]  || File.join(root_path, configs.infra_dirname)
    configurations_path  = options[:configurations_path]  || File.join(root_path, configs.configurations_dirname)
    configuration_name   = options[:configuration] || :_default_

    logger.info "Launching indocker with:"
    logger.info "  Root path: #{root_path.yellow}"
    logger.info "  Images path: #{images_path.yellow}"
    logger.info "  Infrastructure path: #{infra_path.yellow}"
    logger.info "  Configurations path: #{configurations_path.yellow}"
    logger.info "  Configuration name: #{configuration_name.yellow}"

    configuration_store.define(:_default_)
    configuration_store.load_definitions(configurations_path)
    Indocker.set_configuration_name(configuration_name)

    infra_store.load_infra_items(infra_path)

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(images_path)
      task.update_title("Loaded #{files.count} image definitions")
    end
  end
end