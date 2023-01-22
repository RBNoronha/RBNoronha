# Import the Azure PowerShell module
Import-Module Az

# Define a constant message for invalid input
$INVALID_INPUT_MSG = "Invalid input. Please enter a valid number."

# Get all available subscriptions
$subscriptions = Get-AzSubscription

# Check if more than one subscription is available
if ($subscriptions.Count -gt 1) {
    # Initialize a counter for the subscriptions
    $subEnum = 0

    # Print available subscriptions
    Write-Host "`nFollowing subscriptions are available:`n"
    foreach ($subscription in $subscriptions) {
        Write-Host "$($subEnum). $($subscription.Name)`t$($subscription.TenantId)"
        $subEnum ++
    }

    # Get user input for the desired subscription
    do {
        $subNumber = Read-Host "`nSelect subscription (by number)"
        # check if the input is a valid number
        if (!($subNumber -is [int]) -or ($subNumber -lt 0) -or ($subNumber -ge $subscriptions.Count)) {
            Write-Host $INVALID_INPUT_MSG -ForegroundColor Red
        }
    } while (!($subNumber -is [int]) -or ($subNumber -lt 0) -or ($subNumber -ge $subscriptions.Count))

    # Set the selected subscription as the current context
    $subscription = $subscriptions[$subNumber]
    Set-AzContext -Subscription $subscription.SubscriptionId | Out-Null

    # Print the selected subscription
    Write-Host "`nSelected following subscription:" -ForegroundColor Yellow
    Write-Host "$($subscription.Name) from tenant $($subscription.TenantId)`n" -ForegroundColor Green
}
else {
    # If only one subscription is available, set it as the current context
    $subscription = $subscriptions
    Set-AzContext -Subscription $subscription.SubscriptionId | Out-Null

    # Print the selected subscription
    Write-Host "`nSelected following subscription:" -ForegroundColor Yellow
    Write-Host "$($subscription.Name) from tenant $($subscription.TenantId)`n" -ForegroundColor Green
}
