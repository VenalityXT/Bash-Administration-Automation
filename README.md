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

The `Get-Process` cmdlet is used to retrieve a list of all running processes on your system. This is useful for monitoring system health and identifying resource-heavy processes. However, the output of `Get-Process` can often be **cluttered and hard to read**, especially when there are many active processes.

### Initial `Get-Process` Usage

Using `Get-Process` without any additional filtering will display a long list of processes. Below is a screenshot of the output showing all processes:

<img width="710" height="1008" alt="image" src="https://github.com/user-attachments/assets/8f356e02-cff1-4847-9f2c-ae861f157fcd" />

As you can see, this output includes a lot of information, making it difficult to quickly identify specific processes.

---

### **Improved Efficiency: Filtering and Sorting the Output**

To make the output more manageable and highlight the most important processes (e.g., those using the most CPU), you can filter and sort the results.

For example, the following command sorts processes by CPU usage and limits the output to the top 10 processes:
```
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
```

<img width="722" height="247" alt="image" src="https://github.com/user-attachments/assets/4525e0c7-5520-4db4-aea3-fdd5fbb3e49b" />

**Explanation of Command:**

| Component | Description |
|-----------|-------------|
| `Get-Process` | Retrieves all running processes. |
| `|` | Pipe operator: sends the output of one command to the next. |
| `Sort-Object CPU -Descending` | Sorts processes by CPU usage in descending order. |
| `Select-Object -First 10` | Limits the output to the top 10 processes. |

This makes it easier to identify which processes are consuming the most resources, helping administrators focus on key areas of the system.

[Insert Image Here: `getprocess2.png`]  

---

## **Step 2: Navigate Directories with `Get-ChildItem` and `Set-Location`**

In PowerShell, `Get-ChildItem` lists the contents of a directory, similar to the `ls` command in Linux. `Set-Location` allows you to navigate between directories, akin to `cd` in Linux.

To list contents and change directories:
```
Get-ChildItem
Set-Location C:
Get-ChildItem
```

This can be compared to Linux commands:
```
ls
cd /
ls
```

<img width="638" height="494" alt="image" src="https://github.com/user-attachments/assets/06fc5e5c-1661-4d40-98c8-f1d5c94da5ce" />
<img width="307" height="74" alt="image" src="https://github.com/user-attachments/assets/4b8d03f4-9503-406e-9ffb-12e093594275" />

---

## **Step 3: Create Files and Directories with `New-Item`**

The `New-Item` cmdlet allows you to create both files and directories. For example:
```
New-Item -Path "C:\PowerShellLab" -ItemType Directory
New-Item -Path "C:\PowerShellLab\ServerReport.txt" -ItemType File
```

**Breakdown of Command:**

| Parameter  | Description                               | Example                  |
|------------|-------------------------------------------|--------------------------|
| `-Path`    | Specifies the path where the item is created. | `"C:\PowerShellLab"`      |
| `-ItemType` | Specifies the type of item to create.    | `Directory`, `File`, `SymbolicLink` |

<img width="532" height="161" alt="image" src="https://github.com/user-attachments/assets/1d20991a-c246-4bda-8b02-9e03b9a85a63" />
<img width="549" height="129" alt="image" src="https://github.com/user-attachments/assets/7809e95b-ac45-4f43-a111-8414dd67e838" />

---

## **Step 4: File Integrity Validation with `Get-FileHash`**

The `Get-FileHash` cmdlet computes a cryptographic hash (SHA256 by default) for a given file. A hash acts as a **digital fingerprint** — even a single character change will result in a different hash value.

To check the hash of a file:
```
Get-FileHash -Path "ServerReport.txt"
```

After appending content to the file:

```
Add-Content -Path "ServerReport.txt" -Value "CPU and Memory check: Normal"
Get-FileHash -Path "ServerReport.txt"
```

<img width="976" height="107" alt="image" src="https://github.com/user-attachments/assets/802e216d-69ff-4a8e-bb02-6f4098096c26" />
<img width="974" height="117" alt="image" src="https://github.com/user-attachments/assets/70cee887-4712-4929-a15f-515ef99fb9f2" />

**Explanation:**

- The hash value changes when the file's content changes.
- This technique is used in cybersecurity to validate the integrity of system files. Any tampering or corruption will result in a mismatch between the stored and calculated hash values.

---

## **Real-World Cybersecurity Relevance**

File integrity monitoring (FIM) is a critical component of cybersecurity. By storing baseline hash values of important files, administrators can periodically compare the current hash against the stored one. If the hashes differ, it may indicate that the file has been altered, possibly due to malware or unauthorized modifications.

Common tools like **Tripwire**, **OSSEC**, and **Splunk** use file hashes for similar integrity checks to detect malicious changes in system files, enforcing trust and security.

---

## **Summary**

This project showcases how PowerShell can be utilized for essential system administration tasks, including process monitoring, file management, and integrity validation. It provides practical experience in automating system checks, ensuring secure operations, and improving administrative workflows through PowerShell scripting.

By leveraging **PowerShell ISE**, this project aligns with both **IT operations** and **cybersecurity best practices**, providing a comprehensive introduction to automation and file integrity management.

--- 

This version now includes space for both screenshots: one showing the initial use of `Get-Process`, and another showing the more efficient filtered version. Let me know if you need further adjustments!


