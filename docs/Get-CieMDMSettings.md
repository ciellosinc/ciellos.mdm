---
external help file: ciellos.mdm-help.xml
Module Name: ciellos.mdm
online version:
schema: 2.0.0
---

# Get-CieMDMSettings

## SYNOPSIS
Retrieves and processes MDM configuration settings from a JSON string or file path.

## SYNTAX

```
Get-CieMDMSettings [[-SettingsJsonString] <String>] [[-SettingsJsonPath] <String>] [-OutputAsHashtable]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-CieMDMSettings function retrieves MDM configuration settings either from a JSON string or a file path.
It validates the input, processes the settings, and returns the configuration as an ordered hashtable.
The function also supports additional configuration retrieval in a GitHub context.

## EXAMPLES

### EXAMPLE 1
```
Get-CieMDMSettings -SettingsJsonString '{"key":"value"}'
```

### EXAMPLE 2
```
Get-CieMDMSettings -SettingsJsonPath "C:\path\to\settings.json"
```

## PARAMETERS

### -SettingsJsonString
A JSON string containing the MDM settings.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingsJsonPath
The file path to a JSON file containing the MDM settings.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputAsHashtable
Outputs the settings as a hashtable if specified.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Ensure that only one of the parameters, SettingsJsonString or SettingsJsonPath, is provided at a time.
- Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
