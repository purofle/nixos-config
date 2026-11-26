# Re-broadcast HomeKit mDNS services from containers (OrbStack/Docker) to the LAN.
# Based on https://github.com/lpbas/homekit-mdns-broadcaster (MIT), trimmed down to
# HomeKit only, with correct TXT unescaping and periodic re-resolve so changes of
# c#/s#/port in the container are picked up without a restart.
#
# Find instance names with: dns-sd -B _hap._tcp
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.homekit-mdns-broadcaster;
  home = config.users.users.${config.system.primaryUser}.home;

  script = pkgs.writeScript "homekit-mdns-broadcaster" (
    "#!${pkgs.python3}/bin/python3 -I\n" + builtins.readFile ./homekit-mdns-broadcaster.py
  );
in
{
  options.services.homekit-mdns-broadcaster = {
    enable = lib.mkEnableOption "re-broadcasting container HomeKit mDNS services to the LAN";

    services = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = [ "HASS Bridge F6F76A" ];
      description = "mDNS instance names to re-broadcast (as shown by `dns-sd -B _hap._tcp`).";
    };

    serviceTypes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "_hap._tcp" ];
      description = "Service types tried in order for each name.";
    };

    interval = lib.mkOption {
      type = lib.types.ints.positive;
      default = 30;
      description = "Seconds between re-resolving the container's advertisement.";
    };

    logFile = lib.mkOption {
      type = lib.types.str;
      default = "${home}/Library/Logs/homekit-mdns-broadcaster.log";
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.user.agents.homekit-mdns-broadcaster.serviceConfig = {
      ProgramArguments = [
        "${script}"
        "--interval"
        (toString cfg.interval)
      ]
      ++ lib.concatMap (t: [
        "--service-type"
        t
      ]) cfg.serviceTypes
      ++ cfg.services;
      EnvironmentVariables.PYTHONUNBUFFERED = "1";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = cfg.logFile;
      StandardErrorPath = cfg.logFile;
    };
  };
}
