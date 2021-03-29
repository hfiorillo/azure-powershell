
#Select SubscriptionId
$SubId = Read-Host "Please input your Subscription Id"
while ($SubId.Length -le 35) {
    Write-Host "[$(get-date -Format "dd/mm/yy hh:mm:ss")] Subscription Id not valid"
    $SubId = Read-Host "Please input your Subscription Id"
}

Select-AzSubscription -SubscriptionId $SubId
Write-Host "[$(get-date -Format "dd/mm/yy hh:mm:ss")] Subscription successfully selected"
Write-Host ""


### NEEDS UPDATING 
### MAKE SURE TO CHANGE THESE VALUES SPECIFIC TO YOUR ENVIRONMENT / TAGS
### WILL UPDATE TO INCLUDE WRITE HOST TO SET VALUES

$rs = get-azresource -TagName Owner

foreach($r in $rs){

    if($r.Tags.Owner -eq 'Graeme Ferguson'){
        $r.Tags.Owner = "NMITE"
        Set-AzResource  -ResourceId  $r.ResourceId -Tag $r.Tags -Force
    }
}

foreach($r in $rs){

    if($r.Tags.Owner -eq 'Unknown'){
        $r.Tags.Owner = "NMITE"
        Set-AzResource  -ResourceId  $r.ResourceId -Tag $r.Tags -Force
    }
}
