# Limitations

This cookbook installs and configures Sonatype Nexus Repository from the upstream archive. It does not manage PostgreSQL, reverse proxies, TLS certificates, or high availability topology.

## Platform Support

Sonatype documents Nexus Repository support for Linux, Windows, and macOS only. This cookbook manages Linux systems through Chef resources and systemd. Windows and macOS archives are available upstream but are outside this cookbook's supported convergence path.

Current upstream downloads include Linux x86-64 and Linux AArch64 archives. The default `download_url` property uses the current Linux x86-64 archive path. Use `download_url` and `download_sha256_checksum` when installing a different architecture or Nexus release.

## Runtime Constraints

Nexus Repository requires a dedicated non-root operating system user, high file descriptor limits, and enough disk and memory for the repository workload. The `nexus_install` resource creates a dedicated user and configures a systemd `LimitNOFILE` value, but capacity planning remains the operator's responsibility.

Current Nexus Repository releases require Java 21, and Sonatype bundles the recommended JVM in release 3.78.0 and later. This cookbook no longer installs Java separately.

## Package Constraints

Sonatype distributes Nexus Repository as archives and container images, not native apt, dnf, or yum packages. The cookbook uses the `ark` cookbook to install the archive and does not configure OS package repositories.

Sources:

* [Sonatype Nexus Repository System Requirements](https://help.sonatype.com/en/sonatype-nexus-repository-system-requirements.html)
* [Sonatype Nexus Repository Download](https://help.sonatype.com/en/download.html)
* [Sonatype Nexus Repository Download Archives](https://help.sonatype.com/en/download-archives---repository-manager-3.html)
