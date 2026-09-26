# Turns the raw simulator captures into the images the store listing shows: a
# caption above, the app screen below.
#
#   powershell -ExecutionPolicy Bypass -File store_listing\tools\compose_screenshots.ps1
#   ... -Width 2048 -Height 2732 -Source store_listing\screenshots_ipad -OutDir store_listing\screenshots_ipad\composed
#
# App Store sizes: 6.9" is 1320x2868, 6.5" is 1284x2778, iPad 12.9" is
# 2048x2732. The same captures compose to any of them.

param(
  [int]$Width = 1320,
  [int]$Height = 2868,
  [string]$Source = "store_listing\screenshots_ios",
  [string]$OutDir = "store_listing\screenshots_ios\composed",
  # A tablet's screen is wider relative to the canvas, so its card can take more
  # of the width without the caption above it looking cramped.
  [double]$ImageWidthRatio = 0.84,
  # Only a tablet needs this. On a phone the screens already run to the bottom,
  # and cropping turns them into a short card floating in empty background.
  [switch]$CropToContent
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

# How far down the capture the last full-width row of content sits. A tablet
# leaves half its screen empty under a nine-row list, and pasting that in whole
# is what made the previous set look like an empty app; cropping to the content
# keeps every image dense regardless of the device it was shot on.
function Get-ContentBottom($bmp) {
  $bg = $bmp.GetPixel(4, [int]($bmp.Height * 0.5))
  $last = 0
  for ($y = 0; $y -lt $bmp.Height; $y += 4) {
    $diff = 0; $n = 0
    for ($x = 0; $x -lt $bmp.Width; $x += 16) {
      $p = $bmp.GetPixel($x, $y); $n++
      if ([Math]::Abs($p.R - $bg.R) + [Math]::Abs($p.G - $bg.G) + [Math]::Abs($p.B - $bg.B) -gt 12) { $diff++ }
    }
    # A floating action button is narrow and would otherwise defeat the crop,
    # so only rows that are mostly content count.
    if ($diff / $n -gt 0.4) { $last = $y }
  }
  return $last
}

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

  $src = New-Object System.Drawing.Bitmap $srcPath
  $cropH = $src.Height
  $bottom = $src.Height
  if ($CropToContent) {
    $bottom = Get-ContentBottom $src
    $cropH = [Math]::Min($src.Height, [int]($bottom + $src.Height * 0.035))
  }
  # A screen whose content runs to the bottom keeps the shape it was shot in.
  if (($cropH / $src.Height) -gt 0.90) { $cropH = $src.Height }

  $shotW = [int]($Width * $ImageWidthRatio)
  $shotH = [int]($shotW * $cropH / $src.Width)
  $shotX = [int](($Width - $shotW) / 2)

  $top = [int](500 * $s)
  if (($top + $shotH) -ge $Height) {
    # Tall enough to reach the bottom edge: bottom-align it and let it bleed
    # off, which reads as a screen continuing past the frame.
    $shotY = $Height - $shotH
    $roundBottom = $false
  } else {
    $shotY = $top + [int](($Height - $top - $shotH) / 2)
    $roundBottom = $true
  }

  $radius = [int](44 * $s)
  $d = $radius * 2
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddArc($shotX, $shotY, $d, $d, 180, 90)
  $path.AddArc(($shotX + $shotW - $d), $shotY, $d, $d, 270, 90)
  if ($roundBottom) {
    $path.AddArc(($shotX + $shotW - $d), ($shotY + $shotH - $d), $d, $d, 0, 90)
    $path.AddArc($shotX, ($shotY + $shotH - $d), $d, $d, 90, 90)
  } else {
    $path.AddLine(($shotX + $shotW), ($shotY + $shotH), $shotX, ($shotY + $shotH))
  }
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
  $destRect = New-Object System.Drawing.Rectangle $shotX, $shotY, $shotW, $shotH
  $srcRect = New-Object System.Drawing.Rectangle 0, 0, $src.Width, $cropH
  $g.DrawImage($src, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
  $g.ResetClip()

  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, 30, 48, 38)), (2 * $s)
  $g.DrawPath($pen, $path)

  $outPath = Join-Path $OutDir $shot.file
  $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

  $pen.Dispose(); $path.Dispose(); $src.Dispose()
  $headFont.Dispose(); $subFont.Dispose(); $headBrush.Dispose(); $subBrush.Dispose()
  $g.Dispose(); $canvas.Dispose()
  Write-Output ("wrote {0}  (crop {1} / content {2})" -f $outPath, $cropH, $bottom)
}
