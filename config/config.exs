import Config

config(:quantlab, :file_module, File)

import_config "#{config_env()}.exs"
