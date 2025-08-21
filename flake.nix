{
  description = "A development environment for PhraseSync";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            nodePackages.npm
            nodePackages.pnpm
            esbuild
            typescript
          ];
          shellHook = ''
            # Ensure dev environment has needed environment variables
            export PATH="$PWD/node_modules/.bin:$PATH"

            # Configure pnpm to *not* ignore build scripts within this shell
            # This bypasses the need for 'pnpm approve-builds'
            export npm_config_ignore_scripts=false

            # Create pnpm workspace config
            if [ ! -f ./pnpm-workspace.yaml ]; then
              touch ./pnpm-workspace.yaml
              echo "onlyBuiltDependencies:
              - esbuild
              - sharp" > ./pnpm-workspace.yaml
            fi

            echo "Development environment ready!"
          '';
        };
      });
}
