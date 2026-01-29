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
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "nix-commit-guardian";
        version = "1.0.0";
        src = ./.;

        buildInputs = with pkgs; [
          nodejs_20
          pnpm
        ];

        buildPhase = ''
          # 使用 pnpm 安装依赖
          pnpm install --frozen-lockfile
          # 编译 TypeScript
          pnpm run build
        '';

        installPhase = ''
          mkdir -p $out/bin $out/lib/node_modules/nix-commit-guardian
          cp -r dist $out/lib/node_modules/nix-commit-guardian/
          cp -r node_modules $out/lib/node_modules/nix-commit-guardian/

          # 创建可执行文件
          cat > $out/bin/nix-commit-guardian << 'EOF'
          #!/bin/sh
          exec ${pkgs.nodejs_20}/bin/node $out/lib/node_modules/nix-commit-guardian/dist/index.js "$@"
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
