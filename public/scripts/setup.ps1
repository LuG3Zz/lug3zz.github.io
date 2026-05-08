# setup.ps1
# Windows 新电脑一键配置脚本
# 本脚本基于 Scoop 包管理器，自动安装常用效率工具与开发环境
# 使用方法: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; irm https://lug3zz.github.io/scripts/setup.ps1 | iex

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  新电脑环境配置脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# --- 1. 安装 Scoop（如未安装）---
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "`n[1/5] 安装 Scoop..." -ForegroundColor Yellow
    irm https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 | iex
} else {
    Write-Host "`n[1/5] Scoop 已安装，跳过" -ForegroundColor Green
}

# --- 2. 切换到 xrgzs/scoop 优化版 ---
Write-Host "`n[2/5] 配置国内加速..." -ForegroundColor Yellow
scoop config scoop_repo 'https://gitcode.com/xrgzs/scoop'
scoop config scoop_branch 'master'
scoop config GH_PROXY 'ghfast.top'

# --- 3. 添加 bucket ---
Write-Host "`n[3/5] 添加 bucket..." -ForegroundColor Yellow
$buckets = @('main', 'extras', 'dorado', 'spc', 'nerd-fonts')
foreach ($bucket in $buckets) {
    if (-not (scoop bucket list | Where-Object { $_.Name -eq $bucket })) {
        Write-Host "  添加 $bucket bucket..." -ForegroundColor Gray
        scoop bucket add $bucket
    } else {
        Write-Host "  $bucket bucket 已存在" -ForegroundColor Gray
    }
}

# --- 4. 安装软件 ---
Write-Host "`n[4/5] 安装软件..." -ForegroundColor Yellow

# 终端增强
Write-Host "`n  >> 终端增强" -ForegroundColor Cyan
scoop install windows-terminal pwsh nu oh-my-posh fastfetch

# 开发工具
Write-Host "`n  >> 开发工具" -ForegroundColor Cyan
scoop install git nodejs-lts python anaconda3 vscode neovim MinGW uv

# 终端辅助
Write-Host "`n  >> 终端辅助" -ForegroundColor Cyan
scoop install lazygit bat fd scoop-search

# 效率工具
Write-Host "`n  >> 效率工具" -ForegroundColor Cyan
scoop install everything greenshot powertoys obsidian anki bandizip pdfgear

# 远程与传输
Write-Host "`n  >> 远程与传输" -ForegroundColor Cyan
scoop install mobaxterm winscp

# 字体
Write-Host "`n  >> 字体" -ForegroundColor Cyan
scoop install Maple-Mono-NF-CN

# --- 5. 清理缓存 ---
Write-Host "`n[5/5] 清理安装缓存..." -ForegroundColor Yellow
scoop cache rm *

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  安装完成！" -ForegroundColor Cyan
Write-Host "  提示: 首次使用 PowerShell 7 请配置 oh-my-posh 主题" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
