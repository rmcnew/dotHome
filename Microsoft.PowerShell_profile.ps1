# Oddly, Powershell doesn't have a built-in variable for the documents directory. So let's make one:
# From https://stackoverflow.com/questions/3492920/is-there-a-system-defined-environment-variable-for-documents-directory
#$env:DOCUMENTS = [Environment]::GetFolderPath("mydocuments")
$env:DOCUMENTS = "$HOME\OneDrive\Documents"
$DOCS = $env:DOCUMENTS

$PROGRAM_FILES = "C:\Program Files"
$LOCAL_PROGRAMS = "$HOME\AppData\Local\Programs"
# add locations to PATH
$RUST_BIN = "$HOME\.cargo\bin"
$MSVS = "$PROGRAM_FILES\Microsoft Visual Studio\2022\Community"
$LLVM_BIN = "$MSVS\VC\Tools\Llvm\bin"
$GIT_HOME = "$PROGRAM_FILES\Git"
$GIT_BINS = "$GIT_HOME\bin;$GIT_HOME\usr\bin;$GIT_HOME\mingw64\bin"
$PODMAN_BIN = "$PROGRAM_FILES\RedHat\Podman"
$EMSDK_HOME = "$HOME\bin\emsdk"
$EMSDK_BINS = "$EMSDK_HOME;$EMSDK_HOME\node\12.20.0_64bit\bin;$EMSDK_HOME\upstream\emscripten"
$MAKE_BIN = "$LOCAL_PROGRAMS\make"
$env:Path = "$HOME\bin;$RUST_BIN;$LLVM_BIN;$GIT_BINS;$PODMAN_BIN;$EMSDK_BINS;$MAKE_BIN;$env:PATH"

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
remove-item alias:cd -force
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


function outlook() {
    start-process "C:\Program Files\Microsoft Office\root\Office16\outlook.exe"
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
function wget {
	wget2 @Args
}
function wgrab {
	wget2 --random-wait -E -r -k -p -np @Args
}
function cmakeg {
	cmake -B build @Args
}
function cmakegr {
	cmake -B build -DCMAKE_BUILD_TYPE=Release @Args
}
function cmakeb {
	cmake ---build build @Args
}
function cmakebr {
	cmake --build build --config Release @Args
}
function cmakegb {
	cmake -B build && cmake --build build
}
function cmakegbr {
	cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release
}
function cmakegbt {
	cmake -B build && cmake --build build && ctest
}
function cmakegbrt {
	cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && ctest -C Release
}
function clangwasm {
	clang "--target=wasm32 -nostdlib -Wl,--no-entry -Wl,--export-all" @Args
}
function cbr {
	cargo build --release @Args
}
function cbrw {
	cargo build --release --target wasm32-unknown-unknown @Args
}


# start in home dir
cd $HOME
