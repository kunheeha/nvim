#!/bin/bash
# Neovim jdtls setup for Bazel Java projects
# Generates Eclipse .classpath and .project files for jdtls
#
# Usage: bazel-java-setup.sh <workspace-root> <project-relative-path>
#
# Examples:
#   bazel-java-setup.sh /Users/kunheeh/Projects/services-pilot data-access/gatekeeper-service

set -e

WORKSPACE_ROOT="$1"
REL_PATH="$2"

if [ -z "$WORKSPACE_ROOT" ] || [ -z "$REL_PATH" ]; then
  echo "Usage: bazel-java-setup.sh <workspace-root> <project-relative-path>"
  exit 1
fi

PROJECT_ROOT="$WORKSPACE_ROOT/$REL_PATH"
BAZEL_PACKAGE="//$REL_PATH"
PROJECT_NAME=$(basename "$REL_PATH")

if [ ! -d "$PROJECT_ROOT" ]; then
  echo "Error: Directory not found: $PROJECT_ROOT"
  exit 1
fi

if [ ! -f "$PROJECT_ROOT/BUILD.bazel" ] && [ ! -f "$PROJECT_ROOT/BUILD" ]; then
  echo "Error: No BUILD file found in $PROJECT_ROOT"
  exit 1
fi

# Verify Java targets exist
cd "$WORKSPACE_ROOT"
bazel query "kind('java_.*', $BAZEL_PACKAGE/...)" --output=label 2>/dev/null | head -1 | grep -q . || {
  echo "Error: No Java targets found in $BAZEL_PACKAGE"
  exit 1
}

# Build all targets to ensure all JARs exist
echo "Building targets..."
bazel build "$BAZEL_PACKAGE/..." --keep_going 2>/dev/null || true

# Query for all JAR dependencies
echo "Querying dependencies..."
TMPFILE=$(mktemp)
bazel cquery "deps(kind('java_.*', $BAZEL_PACKAGE/...))" --output=files 2>/dev/null >"$TMPFILE"

# Get JAR paths, filter out tool JARs
JAR_DEPS=$(cat "$TMPFILE" |
  grep "\.jar$" |
  grep -v "\.runfiles/" |
  grep -v "\-exec-" |
  grep -v "rules_jvm_external+/private/tools" |
  grep -v "tools/errorprone" |
  grep -v "tools/sp_java" |
  grep -v "platformclasspath" |
  while read -r jar; do
    if [[ "$jar" == /* ]]; then
      echo "$jar"
    else
      echo "$WORKSPACE_ROOT/$jar"
    fi
  done | sort -u || true)

# Also get all export-project JARs (internal libraries)
echo "Finding internal library JARs..."
EXPORT_JARS=$(find "$WORKSPACE_ROOT/bazel-bin" -name "*-export-project.jar" 2>/dev/null | sort -u || true)
rm -f "$TMPFILE"

# Combine all JARs
ALL_JARS=$(echo -e "$JAR_DEPS\n$EXPORT_JARS" | sort -u | grep -v "^$")

# Find source directories in this project
SOURCE_DIRS=$(find "$PROJECT_ROOT" -type d -name "java" \( -path "*/src/main/*" -o -path "*/src/test/*" \) 2>/dev/null | sort -u)

# Generate .classpath
cat >"$PROJECT_ROOT/.classpath" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
EOF

# Add source paths
SRC_COUNT=0
for src in $SOURCE_DIRS; do
  rel=$(python3 -c "import os.path; print(os.path.relpath('$src', '$PROJECT_ROOT'))")
  echo "	<classpathentry kind=\"src\" path=\"$rel\"/>" >>"$PROJECT_ROOT/.classpath"
  SRC_COUNT=$((SRC_COUNT + 1))
done

# Add JARs (only if they exist)
JAR_COUNT=0
for jar in $ALL_JARS; do
  if [ -f "$jar" ]; then
    echo "	<classpathentry kind=\"lib\" path=\"$jar\"/>" >>"$PROJECT_ROOT/.classpath"
    JAR_COUNT=$((JAR_COUNT + 1))
  fi
done

# Add JRE container and output
cat >>"$PROJECT_ROOT/.classpath" <<'EOF'
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-21"/>
	<classpathentry kind="output" path="bin"/>
</classpath>
EOF

# Generate .project
cat >"$PROJECT_ROOT/.project" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>$PROJECT_NAME</name>
	<comment>Bazel Java Project</comment>
	<projects></projects>
	<buildSpec>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments></arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>
EOF

echo "Done: $SRC_COUNT sources, $JAR_COUNT JARs"
echo "Generated .classpath and .project in $PROJECT_ROOT"
