# Vesper Golden: JetBrains / Android Studio

IntelliJ-platform port. Works in Android Studio, IntelliJ, PyCharm, WebStorm, and Rider.

- `plugin/` holds the full plugin: the UI theme (`*.theme.json`), the editor color scheme (`*.icls`), and the Gradle build.
- Build the installable zip with `cd plugin && ./pack.sh` (no network) or `./gradlew buildPlugin`.

Full install and iteration steps are in [`../../docs/install.md`](../../docs/install.md).
