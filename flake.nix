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

        pnpmDeps =
          pkgs.runCommand "pnpm-deps"
            {
              nativeBuildInputs = [
                pkgs.pnpm
                pkgs.cacert
              ];
              outputHashAlgo = "sha256";
              outputHashMode = "recursive";
              outputHash = "sha256-efW4j50/z8gFwrw2y1OYacn9bjTf8JK2OY077rfLQ5I=";
            }
            ''
              cp ${./pnpm-lock.yaml} pnpm-lock.yaml
              pnpm fetch --store-dir $out
            '';

        # Avoid re-fetching on git dirty state
        FORCE_GIT_SOURCE = "1";

        buildInputs = with pkgs; [
          nodejs_20
          pnpm
        ];

        buildPhase = ''
          export HOME=$(mktemp -d)

          # Copy pnpm store to writable directory
          cp -r $pnpmDeps $HOME/pnpm-store
          chmod -R +w $HOME/pnpm-store

          pnpm config set store-dir $HOME/pnpm-store

          # 使用 pnpm 安装依赖
          pnpm install --frozen-lockfile --offline
          # 编译 TypeScript
          pnpm run build
        '';

        installPhase = ''
          mkdir -p $out/bin $out/lib/node_modules/nix-commit-guardian
          cp -r dist $out/lib/node_modules/nix-commit-guardian/
          cp -r node_modules $out/lib/node_modules/nix-commit-guardian/

          # 创建可执行文件
          cat > $out/bin/nix-commit-guardian << EOF
          #!/bin/sh
          exec ${pkgs.nodejs_20}/bin/node $out/lib/node_modules/nix-commit-guardian/dist/index.js "\$@"
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
