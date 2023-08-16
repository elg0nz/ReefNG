require "temporal-ruby"

namespace = ENV["TEMPORAL_NAMESPACE"]

Temporal.configure do |config|
  config.host = ENV["TEMPORAL_HOST"]
  config.port = ENV["TEMPORAL_PORT"]
  config.namespace = namespace
  config.task_queue = ENV["TEMPORAL_TASK_QUEUE"]

  if ENV["TEMPORAL_TLS_ENABLED"] != "true"
    config.credentials = :this_channel_is_insecure
  end
end

begin
  Temporal.register_namespace(namespace, "reef-ng default namespace")
  Temporal.logger.info "Namespace created", {namespace: namespace}
rescue Temporal::NamespaceAlreadyExistsFailure
  Temporal.logger.info "Namespace already exists", {namespace: namespace}
end
