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
    agent_plist = prefix/"com.redhat.spice.vdagent.plist"
    agent_plist.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>Crashed</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>com.redhat.spice.vdagent</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/spice-vdagent</string>
          <string>-x</string>
          <string>-S</string>
          <string>/var/run/spice-vdagent-sock</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    XML
  end

  service do
    run [opt_bin/"spice-vdagentd", "-x", "-s", "/dev/tty.com.redhat.spice.0", "-S", "/var/run/spice-vdagent-sock"]
    keep_alive crashed: false
    run_at_load true
    error_log_path "/var/log/spice-vdagentd.stderr.log"
    log_path "/var/log/spice-vdagentd.stdout.log"
  end

  def caveats
    <<~EOS
      The spice-vdagentd daemon has been installed as a Homebrew service.

      To start the daemon:
        brew services start spice-vdagent

      For clipboard sharing, the per-user spice-vdagent agent must also run.
      A LaunchAgent plist has been generated at:
        #{prefix}/com.redhat.spice.vdagent.plist

      Install it with:
        cp #{prefix}/com.redhat.spice.vdagent.plist ~/Library/LaunchAgents/
        launchctl load ~/Library/LaunchAgents/com.redhat.spice.vdagent.plist

      Ensure your Proxmox VM has a VirtIO serial port with
      com.redhat.spice.0 port (auto-configured with SPICE display).
    EOS
  end

  test do
    assert_match "spice-vdagentd", shell_output("#{bin}/spice-vdagentd --help 2>&1", 1)
  end
end
