# Oddly, Powershell doesn't have a built-in variable for the documents directory. So let's make one:
# From https://stackoverflow.com/questions/3492920/is-there-a-system-defined-environment-variable-for-documents-directory
#$env:DOCUMENTS = [Environment]::GetFolderPath("mydocuments")
$env:DOCUMENTS = "$HOME\OneDrive\Documents"
$DOCS = $env:DOCUMENTS

# primary root folder for installed applications
$PROGRAM_FILES = "C:\Program Files"
$LOCAL_PROGRAMS = "$HOME\AppData\Local\Programs"

# LLVM and Clang
$env:LIBCLANG_PATH = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\bin"

# add locations to PATH
$WINDOWS_SSH = "C:\Windows\System32\OpenSSH"
$RUST_BIN = "$HOME\.cargo\bin"
$MSVS = "$PROGRAM_FILES\Microsoft Visual Studio\2022\Community"
$LLVM_BIN = "$MSVS\VC\Tools\Llvm\bin"
$GIT_HOME = "$PROGRAM_FILES\Git"
$GIT_BINS = "$GIT_HOME\bin;$GIT_HOME\usr\bin;$GIT_HOME\mingw64\bin"
$GO_TOOLCHAIN_BIN = "$LOCAL_PROGRAMS\go\bin"
$GO_BIN = "$HOME\go\bin"
$SYSINTERNALS_BIN = "$LOCAL_PROGRAMS/sysinternals"
$env:Path = "$HOME\bin;$RUST_BIN;$LLVM_BIN;$WINDOWS_SSH;$GIT_BINS;$GO_TOOLCHAIN_BIN;$GO_BIN;$SYSINTERNALS_BIN;$env:PATH"

# number of processor cores
$NPROC = Get-CimInstance -classname Win32_Processor | Select-Object -Property NumberOfLogicalProcessors

# turn off bell
Set-PSReadlineOption -BellStyle None

# Better tab completion and shortcut keys
Set-PSReadlineOption -EditMode Emacs

# Produce UTF-8 by default
# https://news.ycombinator.com/item?id=12991690
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

# https://technet.microsoft.com/en-us/magazine/hh241048.aspx
$MaximumHistoryCount = 10000;

# Set cursor to full block shape
$Host.UI.RawUI.CursorSize=100;

# "trash" command sends to Recycle Bin
Set-Alias trash Remove-ItemSafely

# Focus follows mouse / sloppy focus API
Add-Type -TypeDefinition @'
    using System;
    using System.Runtime.InteropServices;
    using System.ComponentModel;

    public static class Spi {
        [System.FlagsAttribute]
        private enum Flags : uint {
            None            = 0x0,
            UpdateIniFile   = 0x1,
            SendChange      = 0x2,
        }

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SystemParametersInfo(
            uint uiAction, uint uiParam, UIntPtr pvParam, Flags flags );

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SystemParametersInfo(
            uint uiAction, uint uiParam, out bool pvParam, Flags flags );

        private static void check( bool ok ) {
            if( ! ok )
                throw new Win32Exception( Marshal.GetLastWin32Error() );
        }

        private static UIntPtr ToUIntPtr( this bool value ) {
            return new UIntPtr( value ? 1u : 0u );
        }

        public static bool GetActiveWindowTracking() {
            bool enabled;
            check( SystemParametersInfo( 0x1000, 0, out enabled, Flags.None ) );
            return enabled;
        }

        public static void SetActiveWindowTracking( bool enabled ) {
            // note: pvParam contains the boolean (cast to void*), not a pointer to it!
            check( SystemParametersInfo( 0x1001, 0, enabled.ToUIntPtr(), Flags.SendChange ) );
        }

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SystemParametersInfo(
            uint uiAction, uint uiParam, out uint pvParam, Flags flags );

		public static uint GetActiveWindowTrackingTimeout() {
			uint timeout;
			check( SystemParametersInfo( 0x2002, 0, out timeout, Flags.None ) );
			return timeout;
		}

		public static void SetActiveWindowTrackingTimeout(uint timeout) {
			check( SystemParametersInfo( 0x2003, 0, new UIntPtr(timeout), Flags.SendChange) );
		}
    }
'@
# check if mouse-focus is enabled
function get-sloppy-focus() {
	[Spi]::GetActiveWindowTracking()
}
# disable mouse-focus (default)
function clear-sloppy-focus() {
	[Spi]::SetActiveWindowTracking( $false )
}
# enable mouse-focus
function set-sloppy-focus() {
	[Spi]::SetActiveWindowTracking( $true )
}
# get sloppy focus timeout
function get-sloppy-focus-timeout() {
	[Spi]::GetActiveWindowTrackingTimeout()
}
# set sloppy focus timeout
function set-sloppy-focus-timeout($timeout) {
	[Spi]::SetActiveWindowTrackingTimeout($timeout)
}


# easier to remember than "ii"
function open($file) {
  invoke-item $file
}

# Truncate homedir to ~
function limit-HomeDirectory($Path) {
  $Path.ToString().Replace("$home", "~")
}

# customize the prompt
function prompt {
    Write-Output "[$env:USERNAME@$env:COMPUTERNAME $($(Get-Location).ToString().Replace("$home", "~")) $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')] "  
}

function edge {
  start microsoft-edge:
}

function settings {
  start-process ms-settings:
}

# which
function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

# cut
function cut(){
	foreach ($part in $input) {
		$line = $part.ToString();
		$MaxLength = [System.Math]::Min(200, $line.Length)
		$line.subString(0, $MaxLength)
	}
}

# cd with shortcut resolving
if (Test-Path alias:cd) {
	remove-item alias:cd -force	
}
function cd($target)
{
    if ($target) {
        if(([string]$target).EndsWith(".lnk")) {
            $sh = new-object -com wscript.shell
            $fullpath = resolve-path $target
            $targetpath = $sh.CreateShortcut($fullpath).TargetPath
            set-location $targetpath
        } else {
            set-location $target
        }
    } else {
        set-location $HOME
    }
}

# quickly go to documents
function docs() {
    set-location $env:DOCUMENTS
}

# touch
#Remove-Item alias:touch -force
function touch($file) {
	if ( Test-Path $file ) {
		Set-FileTime $file
	} else {
		New-Item $file -type file
	}
}

# ln
function ln($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
}
set-alias new-link ln

# uptime
function uptime {
	Get-CimInstance Win32_OperatingSystem | select-object csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

# df
function df {
	get-volume
}

# grep (sort-of)
function grep($regex, $dir) {
	if ( $dir ) {
		get-childitem $dir | select-string $regex
		return
	}
	$input | select-string $regex
}

function wget {
	$url = $Args[0]
	$filename = [System.IO.Path]::GetFileName($url)
	Invoke-WebRequest -Uri "$url" -OutFile "$filename"
}

# pstree
function pstree {
	$ProcessesById = @{}
	foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
		$ProcessesById[$Process.ProcessId] = $Process
	}

	$ProcessesWithoutParents = @()
	$ProcessesByParent = @{}
	foreach ($Pair in $ProcessesById.GetEnumerator()) {
		$Process = $Pair.Value

		if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
			$ProcessesWithoutParents += $Process
			continue
		}

		if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
			$ProcessesByParent[$Process.ParentProcessId] = @()
		}
		$Siblings = $ProcessesByParent[$Process.ParentProcessId]
		$Siblings += $Process
		$ProcessesByParent[$Process.ParentProcessId] = $Siblings
	}

	function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
		$Process = $ProcessesById[$ProcessId]
		$Indent = " " * $IndentLevel
		if ($Process.CommandLine) {
			$Description = $Process.CommandLine
		} else {
			$Description = $Process.Caption
		}

		Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
		foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
			Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
		}
	}

	Write-Output ("{0,6} {1}" -f "PID", "Command Line")
	Write-Output ("{0,6} {1}" -f "---", "------------")

	foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
		Show-ProcessTree $Process.ProcessId 0
	}
}

# find
function find-file($name) {
	get-childitem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach-object {
		write-output = $PSItem.FullName
	}
}

set-alias find find-file
set-alias find-name find-file

# pkill
function pkill($name) {
	get-process $name -ErrorAction SilentlyContinue | stop-process
}

# pgrep
function pgrep($name) {
	get-process $name
}

#ls -a
function la() {
	Get-ChildItem -hidden -filter .*
}

# zip and unzip
set-alias zip compress-archive
set-alias unzip expand-archive

# "aliases"
function shs {
	simple-http-server @Args
}
function make {
	make -j $NPROC @Args
}
function ytdlx {
	yt-dlp -x --audio-format mp3 @Args
}
function ytdl {
	yt-dlp @Args
}
function cb {
	cargo build @Args
}
function cbr {
	cargo build --release @Args
}
function cbrw {
	cargo build --release --target wasm32-unknown-unknown @Args
}

function upgradePowerShell {
	winget upgrade --id Microsoft.PowerShell --source winget
}

# turn on sloppy focus on 
set-sloppy-focus
# set a short timeout
set-sloppy-focus-timeout(50)

# start in home dir
cd $HOME
