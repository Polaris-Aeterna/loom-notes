# Build this Loom notebook with XeLaTeX (PowerShell).
Set-Location $PSScriptRoot
if (Get-Command latexmk -ErrorAction SilentlyContinue) {
    latexmk -xelatex -interaction=nonstopmode -file-line-error main.tex
} else {
    xelatex -interaction=nonstopmode main.tex
    xelatex -interaction=nonstopmode main.tex
}
Write-Host "Built: $PSScriptRoot\main.pdf"
