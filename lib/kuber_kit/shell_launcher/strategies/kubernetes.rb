class KuberKit::ShellLauncher::Strategies::Kubernetes < KuberKit::ShellLauncher::Strategies::Abstract
  include KuberKit::Import[
    "core.artifact_path_resolver",
    "shell.kubectl_commands",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell => Any
  def call(shell)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    if kubeconfig_path.is_a?(KuberKit::Core::ArtifactPath)
      kubeconfig_path = artifact_path_resolver.call(kubeconfig_path)
    end

    deployer_namespace = KuberKit.current_configuration.deployer_namespace
    if deployer_namespace
      kubectl_commands.set_namespace(shell, deployer_namespace, kubeconfig_path: kubeconfig_path)
    end

    env_vars = [
      "KUBECONFIG=#{kubeconfig_path}", 
      "KUBER_KIT_SHELL_CONFIGURATION=#{KuberKit.current_configuration.name}"
    ]

    if configs.shell_launcher_sets_configration
      env_vars << "KUBER_KIT_CONFIGURATION=#{KuberKit.current_configuration.name}"
    end

    shell.replace!(env: ["KUBECONFIG=#{kubeconfig_path}", "KUBER_KIT_SHELL_CONFIGURATION=#{KuberKit.current_configuration.name}"])
  end
end