# pwsh

A collection of scripts ethier written in house by SUURV or found online and made more easily available to run.

## Usage

Many of the scripts in this project can be adapted to run with some form of `irm` and `iex` combination.

For the examples I will use the Firefox script.

```powershell
# Let's not paste the long URL everywhere
$ScriptUrl = "https://github.com/suurv/pwsh/blob/main/Software/FireFox/Set-FireFox.ps1"

# Run the script with no parameters
irm $ScriptUrl | iex

# Since this Firefox script has parameters we can supply, we can supply them with the following
iex "& {$(irm $ScriptUrl)} -Install"
```

Not all scripts are equal and not all of them have good documentation within the script.
