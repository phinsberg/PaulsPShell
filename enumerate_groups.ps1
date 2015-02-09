#The MIT License
#
#Copyright (c) 2009 Tom Nolan <tom at tinyint dot com>
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
#files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
#modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
#is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
#OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
#IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
#
#Last Update: 2009-07-17
$startTime = Get-Date

function showHelp
{
@"

NAME
    enumerate_groups.ps1

SYNOPSIS
    Enumerates all users that are members of a specified set of distribution 
    groups.  The enumeration factors in dynamic and universal mail distribution
    groups, and enumerates all child groups.

SYNTAX
    .\enumerate_groups.ps1 <string[]> [-showTree]

DETAILED DESCRIPTION
    AUTHOR: Tom Nolan <tnolan at tinyint dot com>
    MODIFIED: 2009-07-17

PARAMETERS
    <string[]>
        Specifies a filter for what groups to return.  This can be a valid 
        regular expression, or a plain group name.  This parameter is required.
		Refer to RFC 2253 and the Microsoft specifications at the following 
		URL for valid characters: 
		http://technet.microsoft.com/en-us/library/cc776019(WS.10).aspx

    -showTree <SwitchParameter>
        Specifies that the enumeration of group members will return the names
        of each group in a tree format with UserMailbox and MailContact objects
        as leafs to each tree node.  If this is not specified only UserMailbox
        and MailContact objects will be returned, in a flat format.


    -------------------------- EXAMPLE 1 --------------------------

    .\enumerate_groups.ps1 Support -showTree

    This command will display members of the Support distribution group using
    tree format.

    Group Name:  Support
    Email Addresses:  Support@contoso.com

    Group Members
    -------------
    [ ITDept ]
     |--Anu Mipak
     |--Joe Blithe
     |--John Marcone
     |--Xander Cage
    William McCabe
    External_McCabe_Pager <8455551212@messaging.sprintpcs.com>


    -------------------------- EXAMPLE 2 --------------------------

    .\enumerate_groups.ps1 Support

    This command will display members of the Support distribution group using
    regular format.

    Group Name:  Support
    Email Addresses:  Support@contoso.com

    Group Members
    -------------
    Anu Mipak
    External_McCabe_Pager <8455551212@messaging.sprintpcs.com>
    Joe Blithe
    John Marcone
    William McCabe
    Xander Cage

REMARKS
    For more information email the author.
"@
}

Function EnumerateGroups
{
	# this function goes through the group members and calls out to the helper function to get appropriate data for each one
	$_GroupMembers = $args[0]
	$_OldTreeText = ($args[1] -replace("-", " ")) + " |--"
	$_NewTreeText = $_OldTreeText.substring(0,$_OldTreeText.length-4)
	if ($_NewTreeText.Length -ge 4) { $_NewTreeText = $_NewTreeText.substring(0,$_NewTreeText.length - 2) + "--" }
	if (-not $args[2]) { $_OldTreeText = ""; $_NewTreeText = "" }
	$_Member = $null
	$_ChildMembers = $null
	$_IsGroupTracked = $FALSE
	$_IsGroup = $FALSE
	$_Return = @()
	
	if ($_GroupMembers -ne $null)
	{
		foreach($_Member in $_GroupMembers)
		{
			$_IsGroup = ("DynamicDistributionGroup","MailUniversalDistributionGroup","MailUniversalSecurityGroup") -contains $_Member.RecipientType
			$_IsGroupTracked = (($global:_GroupTracking | Where-Object {$_ -eq $_Member.DisplayName}) -ne $null) -and $_IsGroup
			if (-not $_IsGroupTracked)  # we need this and the previous line check to prevent infinite loops if distribution groups are members of each other
			{
				if ($_IsGroup) { $global:_GroupTracking += $_Member.DisplayName }
				$_ChildMembers = GetMembers $_Member $_OldTreeText $args[2]
				if ($_ChildMembers -ne $null)
				{
					if ($_IsGroup)
					{
						if ($args[2])  # only show the group name if we have showTree enabled
						{
							$_Member.DisplayName = $_NewTreeText + "[ " + $_Member.DisplayName + " ]"  # use square brackets to indicate its a group
							$_Return = $_Return + $_Member + $_ChildMembers
						}
						else
						{
							$_Return = $_Return + $_ChildMembers
						}
					}
					else  # its not a group so we just need to output the user/contact information
					{
						if ($_Member.RecipientType -eq "MailContact")
							{ $_Member.DisplayName = $_NewTreeText + $_ChildMembers.DisplayName }
						else
							{ $_Member.DisplayName = $_NewTreeText + $_Member.DisplayName }
						$_Return = $_Return + $_Member
					}
				}
			}
		}
	}
	$_Return
}

Function GetMembers
{
	# this function takes a passed "member" of a group and processes accordingly
	$_Group = $args[0]
	$_OldTreeText = $args[1]
	$_NewTreeText = ""
	if ($_OldTreeText.length -ge 4) { $_NewTreeText = $_OldTreeText.substring(0,$_OldTreeText.length-4) }
	if ($_NewTreeText.Length -ge 4) { $_NewTreeText = $_NewTreeText.substring(0,$_NewTreeText.length - 2) + "--" }
	if (-not $args[2]) { $_OldTreeText = ""; $_NewTreeText = "" }
	$_Return = $null
	$_DynamicGroup = $null
	$_MailContact = $null
	
	switch ($_Group.RecipientType)
	{
		"DynamicDistributionGroup"
		{
			$_DynamicGroup = Get-DynamicDistributionGroup -Identity $_Group.DisplayName
			$_Return = EnumerateGroups (Get-Recipient -RecipientPreviewFilter $_DynamicGroup.recipientfilter -OrganizationalUnit $_DynamicGroup.RecipientContainer | Select-Object DisplayName, RecipientType | Sort-Object RecipientType,DisplayName) $_OldTreeText $args[2]
		}
		{$_ -eq "MailUniversalDistributionGroup" -or $_ -eq "MailUniversalSecurityGroup"}
		{
			$_Return = EnumerateGroups (Get-DistributionGroupMember -Identity $_Group.DisplayName | Select-Object DisplayName, RecipientType | Sort-Object RecipientType,DisplayName) $_OldTreeText $args[2]
		}
		"MailContact"
		{
			$_MailContact = Get-MailContact $_Group.DisplayName |Select-Object DisplayName, RecipientType, ExternalEmailAddress
			$_Return = @{"DisplayName"=$_MailContact.DisplayName + " <" + ($_MailContact.ExternalEmailAddress -replace("SMTP:", "")) + ">"; "RecipientType"="MailContact"}
			$_Return.DisplayName = $_NewTreeText + $_Return.DisplayName
		}
		"UserMailbox"
		{
			$_Return = Get-Mailbox -Identity $_Group.DisplayName | Select-Object DisplayName, RecipientType
			$_Return.DisplayName = $_NewTreeText + $_Return.DisplayName
		}
		default
		{
			# this is an unhandled group type so ignore it
			$_Return = $null
		}
	}
	
	$_Return
}


function main
{
	$groupFilter = $args[0]
	$treeView = $args[1]
	
	# this is used to keep track of which groups are being added so we dont end up with an infinite loop of enumerating groups
	$global:_GroupTracking=@()

	# there has to be a better way of getting these together... using + or , to join the tables doesn't work the way we need it to
	$AllGroups = @()
	foreach($Group in (Get-DistributionGroup |sort name |select Name, DisplayName, RecipientType |? { $_.DisplayName -match $groupfilter })) { if ($group -ne $null) { $AllGroups += $group } }
	foreach($Group in (Get-DynamicDistributionGroup |sort name |select Name, DisplayName, RecipientType |? { $_.DisplayName -match $groupfilter })) { if ($group -ne $null) { $AllGroups += $group } }

	Write-Host "`n`n"
	foreach($Group in $AllGroups)
	{
		# sometimes $Group is null so we need to check if thats the case and skip it
		if ($Group -ne $null) { $GroupMembers = GetMembers $Group "" $treeView }
		# if we had results in GetMembers then we need to output the data
		if ($GroupMembers -ne $null -and $Group -ne $null)
		{
			Write-Host "Group Name: " $Group.DisplayName
			# since dynamic groups need to be processed with a different set of commands we split this into a separate block
			switch ($group.RecipientType)
			{
				"DynamicDistributionGroup"
				{ 
					Write-Host "Email Addresses: " (get-dynamicdistributiongroup -Identity $Group.name | select -expand EmailAddresses | %{$_.SmtpAddress})
					$notes = ((Get-DynamicDistributionGroup $Group.DisplayName).Notes + "").Trim()
					if ($notes -ne "" -and $notes -ne $null) { Write-Host ("Notes: " + $notes) }
				}
				default
				{
					Write-Host "Email Addresses: " (get-distributiongroup -Identity $Group.name | select -expand EmailAddresses | %{$_.SmtpAddress})
					$notes = ((Get-Group $Group.DisplayName).Notes + "").Trim()
					if ($notes -ne "" -and $notes -ne $null) { Write-Host ("Notes: " + $notes) }
				}
			}
			Write-Host "`nGroup Members`n-------------" -noNewLine
			# if we aren't going to show the treeview then we should remove duplicate names from the result set
			if ($treeView)
				{ $GroupMembers | Select-Object DisplayName | format-table -hideTableHeaders }
			else
				{ $GroupMembers | Select-Object DisplayName -unique | Sort-Object DisplayName | format-table -hideTableHeaders }
			Write-Host "`n`n"
		}
		# no members but the group exists so we need to display that
		elseif ($GroupMembers -eq $null -and $Group -ne $null)
		{
			Write-Host "Group Name: " $Group.DisplayName
			Write-Host "Email Addresses: " (get-distributiongroup -Identity $Group.name | select -expand EmailAddresses | %{$_.SmtpAddress})
			$notes = ((Get-Group $Group.DisplayName).Notes + "").Trim()
			if ($notes.Trim() -ne "") { Write-Host ("Notes: " + $notes) }
			Write-Host "`nGroup Members`n-------------"
			Write-Host "No members found!`n`n`n"
		}
		# group was null so just show group not found
		else
		{
			Write-Host "Group not found!"
		}

		$global:_GroupTracking=@()
	}
	
	if ($AllGroups.Count -eq 0)
	{
		Write-Host "No groups found!"
	}
}


#ok here is the startup... check for parameters and process accordingly
$rx = "^[^,\+\""\\<>;#][^,\+""\\<>;]{0,62}$"
switch ($args.Count)
{
	1
	{
		if ($args[0] -eq "/?" -or $args[0] -eq "-help")
		{
			showHelp
		}
		else
		{
			$groupFilter = $args[0].Trim()
			if ($groupFilter -notmatch $rx)
			{
				#showHelp
				write-host ""
				write-Host "Error: The specified filter is not valid.  Please refer to the help for more information:  .\enumerate_groups.ps1 -help" -foregroundcolor red
			}
			else
			{
				main $groupFilter $false
				write-host "Total Execution Time: " ((Get-Date) - $startTime).TotalMilliseconds "ms"
			}
		}
	}
	2
	{
		$showTree = $args[1].ToLower() -eq "-showtree"
		$groupFilter = $args[0].Trim()
		if ($groupFilter -notmatch $rx)
		{
			#showHelp
			write-host ""
			write-Host "Error: The specified filter is not valid.  Please refer to the help for more information:  .\enumerate_groups.ps1 -help" -foregroundcolor red
		}
		else
		{
			main $groupFilter $showTree
			write-host "Total Execution Time: " ((Get-Date) - $startTime).TotalMilliseconds "ms"
		}
	}
	default
	{
			write-host ""
			write-Host "Error: Unknown arguments.  Please refer to the help for more information:  .\enumerate_groups.ps1 -help" -foregroundcolor red
	}
}
