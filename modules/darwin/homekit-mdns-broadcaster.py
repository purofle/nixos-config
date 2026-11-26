import argparse
import logging
import re
import shlex
import signal
import subprocess
import sys
import time

DNS_SD = "/usr/bin/dns-sd"
REACHED_RE = re.compile(r"can be reached at (\S+?)\.?:(\d+)")

parser = argparse.ArgumentParser(description="Re-broadcast HomeKit mDNS services from OrbStack/Docker to the LAN")
parser.add_argument("names", nargs="+", help="mDNS instance names (see: dns-sd -B _hap._tcp)")
parser.add_argument("--service-type", action="append", dest="types", help="service types to try, default _hap._tcp")
parser.add_argument("--interval", type=int, default=30, help="seconds between re-resolves")
parser.add_argument("--resolve-timeout", type=float, default=2.0)
args = parser.parse_args()
types = args.types or ["_hap._tcp"]

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s: %(message)s", stream=sys.stdout)
log = logging.getLogger()


def own_hostname():
    try:
        out = subprocess.run(["/usr/sbin/scutil", "--get", "LocalHostName"], capture_output=True, text=True)
        return out.stdout.strip().lower() + ".local"
    except Exception:
        return None


def resolve(name, stype, skip_host):
    """Return (host, port, txt list) from the container's advertisement, ignoring our own re-broadcast."""
    proc = subprocess.Popen([DNS_SD, "-L", name, stype, "local"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    try:
        out, _ = proc.communicate(timeout=args.resolve_timeout)
    except subprocess.TimeoutExpired:
        proc.terminate()
        out, _ = proc.communicate()
    lines = out.splitlines()
    for i, line in enumerate(lines):
        m = REACHED_RE.search(line)
        if not m:
            continue
        host, port = m.group(1).lower(), m.group(2)
        if host == skip_host:
            continue
        # dns-sd prints TXT on the next line, shell-escaped; shlex undoes exactly that.
        txt_line = lines[i + 1] if i + 1 < len(lines) and not REACHED_RE.search(lines[i + 1]) else ""
        try:
            txt = shlex.split(txt_line)
        except ValueError:
            log.warning("cannot parse TXT for %s: %r", name, txt_line)
            continue
        return host, port, txt
    return None


registrations = {}  # name -> (proc, (stype, port, txt))


def stop(name):
    proc, _ = registrations.pop(name)
    proc.terminate()
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        proc.kill()


def cleanup(signum=None, frame=None):
    log.info("stopping, removing %d registration(s)", len(registrations))
    for name in list(registrations):
        stop(name)
    sys.exit(0)


signal.signal(signal.SIGINT, cleanup)
signal.signal(signal.SIGTERM, cleanup)

me = own_hostname()
log.info("watching %s (types %s), own host %s", args.names, types, me)

while True:
    for name in args.names:
        current = registrations.get(name)
        if current and current[0].poll() is not None:
            log.warning("dns-sd -R for %s exited (%s), will re-register", name, current[0].returncode)
            registrations.pop(name)
            current = None

        found = None
        for stype in types:
            r = resolve(name, stype, me)
            if r:
                found = (stype, r)
                break
        if not found:
            if not current:
                log.info("%s not visible yet", name)
            continue

        stype, (host, port, txt) = found
        spec = (stype, port, txt)
        if current and current[1] == spec:
            continue
        if current:
            log.info("%s changed: %s -> %s", name, current[1], spec)
            stop(name)
        proc = subprocess.Popen([DNS_SD, "-R", name, stype, "local", port] + txt, stdout=subprocess.DEVNULL)
        registrations[name] = (proc, spec)
        log.info("registered %s as %s port %s (from %s) txt=%s pid=%d", name, stype, port, host, txt, proc.pid)
    time.sleep(args.interval)
