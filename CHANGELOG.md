# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-03-13

### Added

- Initial deck-wizard skill for creating professional HTML presentations with PDF export
- Package as Claude Code plugin for sancrisoft-plugins marketplace (#1)

### Changed

- Audit and fix skills following Anthropic best practices (#2)
- Refactor PDF export to use native print for clickable links and copyable text

### Fixed

- Use correct plugin install syntax (name@marketplace format)
- Use slash command format for plugin install instructions
- Update installation instructions for Claude Code plugin format
- Restore Spanish diacritical marks and inverted question marks
- Fix 16:9 aspect ratio with scaled content for print
- PDF export now uses JPEG compression instead of PNG
- Remove unrelated marketing-site-skills from README
