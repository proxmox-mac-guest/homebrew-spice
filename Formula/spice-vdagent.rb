class SpiceVdagent < Formula
  desc "SPICE guest agent for macOS (built from UTM vd_agent)"
  homepage "https://github.com/utmapp/vd_agent"
  url "https://github.com/utmapp/vd_agent/archive/refs/tags/spice-vdagent-0.22.1-macOS.tar.gz"
  sha256 "1898290b283de9f1c4d2dfd9e785f85d9170b6e44ba7b9e3ba8cdd340279399c"
  license "GPL-3.0-or-later"

  depends_on "glib" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64

  bottle do
    root_url "https://github.com/proxmox-mac-guest/spice-vdagent/releases/download/spice-vdagent-0.22.1"
    sha256 cellar: :any_skip_relocation, sequoia: "dbabb17efd34db6286f92b1f613506df68fbb916e02b77d913bdd055ff94f3b7"
  end

  def install
    system "xcodebuild", "archive",
           "-scheme", "vd_agent",
           "-archivePath", "vd_agent.xcarchive",
           "ARCHS=x86_64",
           "VALID_ARCHS=x86_64",
           "ONLY_ACTIVE_ARCH=NO",
           "MACOSX_DEPLOYMENT_TARGET=10.13"

    bin.install "vd_agent.xcarchive/Products/usr/local/bin/spice-vdagentd"
    bin.install "vd_agent.xcarchive/Products/usr/local/bin/spice-vdagent"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  service do
    run ["/bin/bash", "-c", "#{opt_bin}/spice-vdagentd -s /dev/tty.com.redhat.spice.0 -S #{var}/run/spice-vdagent-sock && exec #{opt_bin}/spice-vdagent -x -S #{var}/run/spice-vdagent-sock"]
    keep_alive crashed: false
    run_at_load true
    error_log_path var/"log/spice-vdagent.stderr.log"
    log_path var/"log/spice-vdagent.stdout.log"
  end

  def caveats
    <<~EOS
      SPICE guest agent has been fully installed.

      To start the agent and enable clipboard sharing, run:
        brew services start spice-vdagent

      (Do not use sudo. It must run as your user to access the clipboard.)

      Ensure your Proxmox VM has a VirtIO serial port with
      com.redhat.spice.0 port (auto-configured with SPICE display).
    EOS
  end

  test do
    assert_match "spice-vdagentd", shell_output("#{bin}/spice-vdagentd --help 2>&1", 1)
  end
end
