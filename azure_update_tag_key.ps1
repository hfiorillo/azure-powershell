$subscriptions = Get-AzSubscription
foreach ($sub in $subscriptions)
{

}


#Define old Tag key $oldkey and new Tag key $newKey
$oldKey = "AppOwner"
$newKey = "Owner"

#Find ResourceGroups with oldKey, backup findings to CSV, migrate existing oldKey value to newKey merging with existing tags, then delete oldKey.
$rgsOldKeyBackup = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -match $oldKey}
$rgsOldKeyBackup.count
if ($rgsOldKeyBackup) {
    Get-AzResourceGroup | Where-Object {$_.Tags.Keys -match $oldKey} | Out-File "C:\temp\AzRGs-Tag-Backup-$oldkey.csv"
    $rgs = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -match $oldKey}
    $rgs | ForEach-Object {
        $rgOldKeyValue = $_.Tags.$oldKey
        $rgNewTag = @{$newKey=$rgOldKeyValue}
        $rgOldTag = @{$oldKey=$rgOldKeyValue}
        $resourceID = $_.ResourceId
        Update-AzTag -ResourceId $resourceID -Tag $rgNewTag -Operation Merge
        $Check = Get-AzResourceGroup -Id $resourceID | Where-Object {$_.Tags.Keys -match $newKey}
        if ($Check) {
            Update-AzTag -ResourceId $resourceID -Tag $rgOldTag -Operation Delete
        }
    }   
}

#Find Resources with oldKey, backup findings to CSV, migrate existing oldKey value to newKey merging with existing tags, then delete oldKey.
$resourcesOldKeyBackup = Get-AzResource | Where-Object {$_.Tags.Keys -match $oldKey}
$resourcesOldKeyBackup.count
if ($resourcesOldKeyBackup) {
    Get-AzResource | Where-Object {$_.Tags.Keys -match $oldKey} | Out-File "C:\temp\AzResources-Tag-Backup-$oldkey.csv"
    $resources = Get-AzResource | Where-Object {$_.Tags.Keys -match $oldKey}
    $resources | ForEach-Object {
        $resourcesOldKeyValue = $_.Tags.$oldKey
        $resourcesNewTag = @{$newKey=$resourcesOldKeyValue}
        $resourcesOldTag = @{$oldKey=$resourcesOldKeyValue}
        $resourceID = $_.ResourceId
        Update-AzTag -ResourceId $resourceID -Tag $resourcesNewTag -Operation Merge
        $Check = Get-AzResource -ResourceId $resourceID | Where-Object {$_.Tags.Keys -match $newKey}
        if ($Check) {
            Update-AzTag -ResourceId $resourceID -Tag $resourcesOldTag -Operation Delete
        }
    }
}
