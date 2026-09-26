# Turns the raw simulator captures in store_listing/screenshots_ios into the
# images the App Store listing actually shows: a caption above, the app screen
# below, bleeding off the bottom edge so the shot stays dense instead of ending
# in the empty space a tall phone leaves under a short list.
#
#   powershell -ExecutionPolicy Bypass -File store_listing\tools\compose_screenshots.ps1
#
# -Width/-Height pick the output size; App Store 6.9" is 1320x2868 and 6.5" is
# 1284x2778, and the same captures compose to either.

param(
  [int]$Width = 1320,
  [int]$Height = 2868,
  [string]$Source = "store_listing\screenshots_ios",
  [string]$OutDir = "store_listing\screenshots_ios\composed"
)

Add-Type -AssemblyName System.Drawing

$shots = @(
  @{ file = "01_chat_list.png";   head = "LINEのトークを、`nずっと残す。";      sub = "消えてしまう前に、まるごと保存。" },
  @{ file = "02_chat_detail.png"; head = "あの日の会話が、`nそのまま蘇る。";    sub = "名前も、時刻も、並びもそのまま。" },
  @{ file = "03_cross_search.png";head = "全部のトークを、`nまとめて検索。";    sub = "ひとことから、あの会話に戻れる。" },
  @{ file = "04_dashboard.png";   head = "会話を、`n数字で振り返る。";          sub = "よく話す相手も、盛り上がった月も。" },
  @{ file = "05_settings.png";    head = "大事なトークを、`nロックで守る。";    sub = "PIN・生体認証・バックアップに対応。" }
)

# Pulled from the app's mint palette so the frame and the screen agree.
$bgTop    = [System.Drawing.Color]::FromArgb(238, 245, 240)
$bgBottom = [System.Drawing.Color]::FromArgb(205, 227, 213)
$headCol  = [System.Drawing.Color]::FromArgb(27, 42, 34)
$subCol   = [System.Drawing.Color]::FromArgb(78, 104, 89)

$null = New-Item -ItemType Directory -Force -Path $OutDir

# Everything below is expressed against the 1320x2868 design and scaled, so a
# different output size keeps the same proportions rather than shifting text.
$s = $Height / 2868.0

foreach ($shot in $shots) {
  $srcPath = Join-Path $Source $shot.file
  if (-not (Test-Path $srcPath)) { Write-Output "skip (not found): $srcPath"; continue }

  $canvas = New-Object System.Drawing.Bitmap $Width, $Height
  $g = [System.Drawing.Graphics]::FromImage($canvas)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $rect = New-Object System.Drawing.Rectangle 0, 0, $Width, $Height
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $bgTop, $bgBottom, 90)
  $g.FillRectangle($brush, $rect)
  $brush.Dispose()

  $headFont = New-Object System.Drawing.Font("Yu Gothic UI", (58 * $s), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subFont  = New-Object System.Drawing.Font("Yu Gothic UI", (32 * $s), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)

  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = [System.Drawing.StringAlignment]::Center

  $headBrush = New-Object System.Drawing.SolidBrush $headCol
  $subBrush  = New-Object System.Drawing.SolidBrush $subCol
  $g.DrawString($shot.head, $headFont, $headBrush, ($Width / 2), (150 * $s), $fmt)
  $g.DrawString($shot.sub,  $subFont,  $subBrush,  ($Width / 2), (362 * $s), $fmt)

  # The screen sits below the caption and runs off the bottom of the canvas --
  # the interesting part of every screen is its top, and cropping there keeps
  # the half-empty lower half of a tall simulator out of the picture.
  $src = [System.Drawing.Image]::FromFile((Resolve-Path $srcPath))
  $shotW = [int]($Width * 0.84)
  $shotH = [int]($shotW * $src.Height / $src.Width)
  $shotX = [int](($Width - $shotW) / 2)
  $shotY = $Height - $shotH
  $radius = [int](44 * $s)

  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $radius * 2
  $path.AddArc($shotX, $shotY, $d, $d, 180, 90)
  $path.AddArc(($shotX + $shotW - $d), $shotY, $d, $d, 270, 90)
  $path.AddLine(($shotX + $shotW), ($shotY + $shotH), $shotX, ($shotY + $shotH))
  $path.CloseFigure()

  # A soft shadow, drawn as a few offset translucent copies of the outline.
  for ($i = 14; $i -ge 1; $i--) {
    $alpha = [int](3 + (14 - $i) * 0.7)
    $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($alpha, 30, 48, 38))
    $state = $g.Save()
    $g.TranslateTransform(0, $i * 1.2)
    $g.FillPath($shadowBrush, $path)
    $g.Restore($state)
    $shadowBrush.Dispose()
  }

  $g.SetClip($path)
  $g.DrawImage($src, $shotX, $shotY, $shotW, $shotH)
  $g.ResetClip()

  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, 30, 48, 38)), (2 * $s)
  $g.DrawPath($pen, $path)

  $outPath = Join-Path $OutDir $shot.file
  $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

  $pen.Dispose(); $path.Dispose(); $src.Dispose()
  $headFont.Dispose(); $subFont.Dispose(); $headBrush.Dispose(); $subBrush.Dispose()
  $g.Dispose(); $canvas.Dispose()
  Write-Output "wrote $outPath"
}
