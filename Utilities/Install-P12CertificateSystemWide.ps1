<#
.SYNOPSIS
Installs a .p12 certificate file into the Local Machine's Personal certificate store.

.DESCRIPTION
This script imports a certificate (including its private key if present) from a password-protected .p12 file
into the Local Machine's Personal certificate store ('My'). This makes the certificate available to all users
and services running on the machine. It requires elevated privileges (run as Administrator or SYSTEM).
The private key is marked as not exportable by default.

.PARAMETER P12FilePath
The full path to the .p12 certificate file.

.PARAMETER P12Password
The password required to open the .p12 file.
WARNING: Storing passwords in plain text scripts is insecure. Consider alternative methods
         for production environments (e.g., secure parameters, configuration files with ACLs, secrets management).

.PARAMETER CertStoreLocation
(Optional) The target certificate store path. Defaults to 'Cert:\LocalMachine\My'.
Use 'Cert:\LocalMachine\Root' for Root CAs or 'Cert:\LocalMachine\CA' for Intermediate CAs if needed.

.EXAMPLE
.\Install-P12CertificateSystemWide.ps1 -P12FilePath "C:\Certs\mycert.p12" -P12Password "YourSecretPassword123"

.EXAMPLE
# Install a Root CA certificate
.\Install-P12CertificateSystemWide.ps1 -P12FilePath "C:\Certs\corp_root_ca.p12" -P12Password "RootCAPass" -CertStoreLocation "Cert:\LocalMachine\Root"

.NOTES
Date:   2025-04-07
Requires: PowerShell 3.0 or later. Must be run as Administrator or SYSTEM.
The -MachineKeySet parameter is essential for LocalMachine installs, especially under SYSTEM context.
The private key is set to non-exportable by default using -NotExportable. Remove or change if needed.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$P12FilePath,

    [Parameter(Mandatory=$true)]
    [string]$P12Password,

    [Parameter(Mandatory=$false)]
    [string]$CertStoreLocation = "Cert:\LocalMachine\My" # Default to Personal store
)

# --- Script Body ---

Write-Host "Starting certificate installation process..."

# Check if running with elevated privileges (Admin/SYSTEM)
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $windowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges (or as SYSTEM)."
    Exit 1 # Use appropriate exit code for your deployment tool
} else {
    Write-Host "Running with sufficient privileges (User: $($currentUser.Name))"
}

# Verify the P12 file exists
if (-not (Test-Path -Path $P12FilePath -PathType Leaf)) {
    Write-Error "Certificate file not found at '$P12FilePath'."
    Exit 1
} else {
     Write-Host "Certificate file found: $P12FilePath"
}

# Convert the plain text password to a SecureString
# WARNING: Password is in plain text here. Secure appropriately in production.
Write-Host "Converting password to SecureString..."
$SecurePassword = ConvertTo-SecureString -String $P12Password -AsPlainText -Force
if (!$SecurePassword) {
     Write-Error "Failed to convert password to SecureString."
     Exit 1
}

# Define import parameters
$importParams = @{
    FilePath          = $P12FilePath
    CertStoreLocation = $CertStoreLocation
    Password          = $SecurePassword
    Exportable        = $false         # Set to $true if you need the key exportable later
}

# Attempt to import the certificate
Write-Host "Attempting to import certificate to store: $CertStoreLocation"
try {
    $certificate = Import-PfxCertificate @importParams -ErrorAction Stop

    if ($certificate) {
        Write-Host "Successfully imported certificate:"
        Write-Host "  Thumbprint: $($certificate.Thumbprint)"
        Write-Host "  Subject:    $($certificate.Subject)"
        Write-Host "  Issuer:     $($certificate.Issuer)"
        Write-Host "  Installed to: $CertStoreLocation"
        Write-Host "Certificate installation completed successfully."
        # Consider Exit 0 for success in deployment tools
        # Exit 0
    } else {
        # Should not happen if ErrorAction is Stop, but good practice
        Write-Error "Certificate import command completed but did not return a certificate object. Check the store manually."
        Exit 1
    }
}
catch {
    # Catch any terminating errors during import
    Write-Error "Failed to import certificate '$P12FilePath'."
    Write-Error "Error Details: $($_.Exception.Message)"
    # Consider more detailed logging of $_ if needed
    # $_ | Format-List * -Force | Out-String | Write-Error
    Exit 1 # Use appropriate exit code for your deployment tool
}
finally {
    # Clean up the SecureString variable from memory
    if ($SecurePassword -ne $null) {
        $SecurePassword.Dispose()
        Write-Verbose "SecureString disposed." # Use Write-Host if you want this always visible
    }
}
