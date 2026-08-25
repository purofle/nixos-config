{ inputs, ... }:

{
  networking.hostName = "Mac-mini";

  system.primaryUser = "purofle";
  users.users.purofle.home = "/Users/purofle";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.rev or inputs.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
