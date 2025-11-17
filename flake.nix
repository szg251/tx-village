{
  description = "Tx village - Cardano transaction builder ecosystem";

  inputs = {
    # LambdaBuffers as source of truth for many inputs
    lbf.url = "github:mlabs-haskell/lambda-buffers";
    lbf.inputs.flake-lang.follows = "flake-lang";

    # Flake monorepo toolkit
    flake-lang.url = "github:mlabs-haskell/flake-lang.nix?ref=szg251/use-haskell-nix-nixpkgs";

    haskell-nix.follows = "flake-lang/haskell-nix";

    # Nix
    nixpkgs.follows = "flake-lang/nixpkgs";
    cardano-devnet.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.follows = "lbf/flake-parts";

    # Code quality automation
    pre-commit-hooks.follows = "lbf/pre-commit-hooks";
    hci-effects.follows = "lbf/hci-effects";

    # Plutarch (Plutus validation scripts)
    plutarch.follows = "lbf/plutarch";

    # Light-weight wrapper around cardano-node
    ogmios = {
      url = "github:mlabs-haskell/ogmios-nix/v6.11.2";
      inputs.haskell-nix.follows = "haskell-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Local Cardano devnet for integration testing
    cardano-devnet.url = "github:mlabs-haskell/cardano-devnet-flake";

    cardano-node.url = "github:IntersectMBO/cardano-node/10.4.1";

    hydra.url = "github:cardano-scaling/hydra";

    # Tools for integration testing
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./pkgs.nix
        ./settings.nix
        ./pre-commit.nix
        inputs.process-compose-flake.flakeModule

        # Libraries
        ./tx-bakery/build.nix
        ./tx-bakery-ogmios/build.nix
        ./tx-indexer/build.nix
        ./ledger-sim/build.nix

        # Extras
        ./extras/tx-bakery-testsuite/validation/build.nix
        ./extras/tx-bakery-testsuite/tests/build.nix
        ./extras/tx-bakery-testsuite/tests/dev-environment.nix
        ./extras/diesel-derive-pg/build.nix
        ./extras/tx-bakery-testsuite/api/build.nix
        ./extras/tx-indexer-testsuite/build.nix
        ./extras/tx-indexer-testsuite/dev-environment.nix
      ];
      debug = true;
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
}
