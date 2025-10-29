# **PowerShell Administration Basics**

[![Windows](https://img.shields.io/badge/OS-Windows-blue?logo=windows)](https://learn.microsoft.com/en-us/powershell/)  
[![PowerShell](https://img.shields.io/badge/Scripting-PowerShell-lightblue?logo=powershell)](https://learn.microsoft.com/en-us/powershell/)  
[![Focus](https://img.shields.io/badge/Focus-System%20Administration-orange)](https://en.wikipedia.org/wiki/System_administrator)  
[![Tool](https://img.shields.io/badge/Tool-PowerShell%20ISE-green)](https://learn.microsoft.com/en-us/powershell/scripting/core-powershell/ise/using-the-windows-powershell-ise)  

---

## **Project Overview**

This project demonstrates the use of **PowerShell scripting** for essential system administration tasks in a Windows environment. It covers key cmdlets for managing system processes, navigating the file system, creating and modifying files, and performing file integrity checks. These tasks are foundational for **IT operations**, **automation**, and **cybersecurity**.

The script automates the process of monitoring system health, managing file structures, and verifying file integrity. By leveraging **PowerShell ISE**, the project focuses on streamlining workflows and ensuring consistency and security through automation.

---

## **Objectives**

1. Automate system process monitoring with `Get-Process`.  
2. Navigate directories and manage files using PowerShell cmdlets (`Get-ChildItem`, `Set-Location`, `New-Item`, `Add-Content`, `Get-Content`).  
3. Perform file integrity checks with `Get-FileHash` to verify data integrity.  
4. Develop familiarity with PowerShell ISE for scripting, debugging, and automation.  

---

## **Step 1: Monitor System Processes with `Get-Process`**

The `Get-Process` cmdlet retrieves all running processes on the system. This can be useful for monitoring system health and identifying processes consuming excessive resources. However, the default output can be cluttered, making it hard to analyze effectively.

To filter and sort the output for better readability:

