{
  description = "TS dev shell (pnpm + zsh)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_20
          pkgs.pnpm
          pkgs.nodePackages.typescript
          pkgs.nodePackages.eslint
          pkgs.zsh
        ];

        shellHook = ''
          # 进入 devShell 自动切到 zsh（避免递归）
          if [ -z "$ZSH_VERSION" ]; then
            export SHELL=${pkgs.zsh}/bin/zsh
            exec ${pkgs.zsh}/bin/zsh
          fi
        '';
      };
      templates.default = {
        path = ./.;
        description = "TypeScript CLI template with Nix";
      };
    };
}
