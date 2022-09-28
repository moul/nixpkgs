{ config, lib, ... }:

{
  # Stop `parallel` from displaying citation warning
  home.file.".parallel/will-cite".text = "";
}
