# Oddly, Powershell doesn't have a built-in variable for the documents directory. So let's make one:
# From https://stackoverflow.com/questions/3492920/is-there-a-system-defined-environment-variable-for-documents-directory
#$env:DOCUMENTS = [Environment]::GetFolderPath("mydocuments")
$env:DOCUMENTS = "$HOME\OneDrive\Documents"
$docs = $env:DOCUMENTS

# add locations to PATH
$env:Path = "C:\Program Files (x86)\Vim\vim82;$env:PATH"

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
  $Path.Replace("$home", "~")
}

# customize the prompt
function prompt {
        Write-Output "[$env:USERNAME@$env:COMPUTERNAME $(Get-Location) $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')] "  
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

# vim and gvim
function view() {
    start-process "C:\Program Files (x86)\Vim\vim82\vim.exe" -ArgumentList "-R -p $args"
}

function gview() {
    start-process "C:\Program Files (x86)\Vim\vim82\gvim.exe" -ArgumentList "-R -p $args"
}

function vim() {
    start-process "C:\Program Files (x86)\Vim\vim82\vim.exe" -ArgumentList "-p $args"
}

function gvim() {
    start-process "C:\Program Files (x86)\Vim\vim82\gvim.exe" -ArgumentList "-p $args"
}

function vimdiff() {
    start-process "C:\Program Files (x86)\Vim\vim82\vim.exe" -ArgumentList "-d $args"
}

function gvimdiff() {
    start-process "C:\Program Files (x86)\Vim\vim82\gvim.exe" -ArgumentList "-d $args"
}


function outlook() {
    start-process "C:\Program Files (x86)\Microsoft Office\Office16\outlook.exe"
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

# zip and unzip
set-alias zip compress-archive
set-alias unzip expand-archive

# start in home dir
cd $HOME
