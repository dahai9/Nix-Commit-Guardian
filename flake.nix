{
  description = "Nix Commit Guardian - AI-powered commit message generator";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.buildNpmPackage {
        name = "nix-commit-guardian";
        version = "1.0.0";
        src = ./.;

        npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

        buildPhase = ''
          npm run build
        '';

        installPhase = ''
          mkdir -p $out/bin $out/lib/node_modules/nix-commit-guardian/dist
          cp -r dist/* $out/lib/node_modules/nix-commit-guardian/dist/
          cp -r node_modules $out/lib/node_modules/nix-commit-guardian/

          cat > $out/bin/nix-commit-guardian << 'EOF'
          #!/bin/sh
          exec ${pkgs.nodejs}/bin/node $out/lib/node_modules/nix-commit-guardian/dist/index.js "$@"
          EOF
          chmod +x $out/bin/nix-commit-guardian
        '';

        meta = with pkgs.lib; {
          description = "AI-powered commit message generator for NixOS";
          license = licenses.isc;
          platforms = platforms.linux;
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_20
          pkgs.pnpm
          pkgs.nodePackages.typescript
          pkgs.nodePackages.eslint
          pkgs.zsh
        ];

        shellHook = ''
          if [ -z "$ZSH_VERSION" ]; then
            export SHELL=${pkgs.zsh}/bin/zsh
            exec ${pkgs.zsh}/bin/zsh
          fi
        '';
      };
    };
}
