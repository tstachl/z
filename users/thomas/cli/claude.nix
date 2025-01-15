{ outputs, ... }:
{
  home.sessionVariables = {
    ANTHROPIC_API_KEY = "${outputs.lib.readSecret "claude"}";
  };
}
