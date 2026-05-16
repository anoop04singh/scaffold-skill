Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot ".claude\skills\scaffold"
$outDir = Join-Path $repoRoot "downloads"
$outZip = Join-Path $outDir "scaffold-skill.zip"

if (-not (Test-Path $sourceRoot)) {
  throw "Missing source skill directory: $sourceRoot"
}

New-Item -ItemType Directory -Force $outDir | Out-Null
if (Test-Path $outZip) {
  Remove-Item -Force $outZip
}

$files = @(
  @{ Src = Join-Path $sourceRoot "SKILL.md"; Dst = "scaffold/SKILL.md" },
  @{ Src = Join-Path $sourceRoot "template.md"; Dst = "scaffold/template.md" },
  @{ Src = Join-Path $sourceRoot "README.md"; Dst = "scaffold/README.md" },
  @{ Src = Join-Path $sourceRoot "examples\sample-output.md"; Dst = "scaffold/examples/sample-output.md" }
)

foreach ($file in $files) {
  if (-not (Test-Path $file.Src)) {
    throw "Missing required file: $($file.Src)"
  }
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$zip = [System.IO.Compression.ZipFile]::Open($outZip, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($file in $files) {
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.Src, $file.Dst) | Out-Null
  }
}
finally {
  $zip.Dispose()
}

# Validation pass
$read = [System.IO.Compression.ZipFile]::OpenRead($outZip)
try {
  $entries = $read.Entries | ForEach-Object { $_.FullName }
  foreach ($entry in $entries) {
    if ($entry -match "\\\\") {
      throw "Invalid path separator found in ZIP entry: $entry"
    }
  }
  "Created: $outZip"
  "Entries:"
  $entries
}
finally {
  $read.Dispose()
}
