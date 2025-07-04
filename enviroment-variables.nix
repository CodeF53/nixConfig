{ inputs, ... }:

let
  tomlContent = builtins.readFile inputs.env-toml;
  envConfig = builtins.fromTOML tomlContent;
in {
  environment.sessionVariables = {
    GOOGLE_AI_API_KEY = envConfig.gemini_key or (throw "gemini_key not found in env.toml!");
    DEBUG_ENV_CONFIG = builtins.toJSON envConfig;
  };
}
