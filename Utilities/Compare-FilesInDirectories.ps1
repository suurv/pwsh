# taken from a StackOverflow answer
# https://stackoverflow.com/a/71363031

param(
    [String]
    $ReferenceDir,
    [String]
    $DifferenceDir
)

$result = [System.Collections.Generic.List[object]]::new()

$sb = {
    process {
        if($_.Name -eq 'Thumbs.db') { return }

        [PSCustomObject]@{
            h  = (Get-FileHash $_.FullName -Algorithm SHA1).Hash
            n  = $_.Name
            s  = $_.Length
            fn = $_.fullname
        }
    }
}

$refFiles  = Get-ChildItem $ReferenceDir -Recurse -File | & $sb
$diffFiles = Get-ChildItem $DifferenceDir -Recurse -File | & $sb

foreach($file in $diffFiles) {
    # this file exists on both folders, skip it
    if($file.h -in $refFiles.h) { continue }
    # this file exists on reference folder but has changed
    if($file.n -in $refFiles.n) {
        $file.PSObject.Properties.Add(
                [psnoteproperty]::new('Status', 'Changed in Ref')
        )
        $result.Add($file)
        continue
    }
    # this file does not exist on reference folder
    # based on previous conditions
    $file.PSObject.Properties.Add(
            [psnoteproperty]::new('Status', 'Unique in Diff')
    )
    $result.Add($file)
}

foreach($file in $refFiles) {
    # this file is unique in reference folder, rest of the files
    # not meeting this condition can be ignored since we're
    # interested only in files on reference folder that are unique
    if($file.h -notin $diffFiles.h) {
        $file.PSObject.Properties.Add(
                [psnoteproperty]::new('Status', 'Unique in Ref')
        )
        $result.Add($file)
    }
}

$result | Format-Table
