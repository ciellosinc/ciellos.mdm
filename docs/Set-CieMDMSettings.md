---
external help file: ciellos.mdm-help.xml
Module Name: ciellos.mdm
online version:
schema: 2.0.0
---

# Set-CieMDMSettings

## SYNOPSIS
Sets and processes MDM configuration settings from a JSON string or file path.

## SYNTAX

```
Set-CieMDMSettings [[-SettingsFilePath] <String>] [[-SettingsJsonString] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-CieMDMSettings function sets MDM configuration settings either from a JSON string or a file path.
It validates the input, processes the settings, and merges them into an ordered dictionary.
The function supports execution in different environments, including GitHub, Azure DevOps, and local desktop.

## EXAMPLES

### EXAMPLE 1
```
Set-CieMDMSettings -SettingsJsonString '{"key":"value"}'
```

### EXAMPLE 2
```
Set-CieMDMSettings -SettingsFilePath "C:\path\to\settings.json"
```

## PARAMETERS

### -SettingsFilePath
The file path to a JSON file containing the MDM settings.

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

### -SettingsJsonString
A JSON string containing the MDM settings.

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

### System.Collections.Specialized.OrderedDictionary
## NOTES
Ensure that only one of the parameters, SettingsJsonString or SettingsFilePath, is provided at a time.
- Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
